#!/usr/bin/env python3
"""
Mnemo vector memory engine.
Optional semantic layer for .cursor/memory with MCP tools.
"""
import os
import re
import sqlite3
import hashlib
from pathlib import Path

import sqlite_vec
try:
    from sqlite_vec import serialize_f32
except ImportError:
    # sqlite-vec>=0.1.6 exposes serialize_float32 instead of serialize_f32.
    from sqlite_vec import serialize_float32 as serialize_f32
from mcp.server.fastmcp import FastMCP

SCHEMA_VERSION = 1
EMBED_DIM = 1536
REPO_ROOT = Path(__file__).resolve().parents[2]
MEM_ROOT = REPO_ROOT / ".cursor" / "memory"
DB_PATH = MEM_ROOT / "mnemo_vector.sqlite"
ENV_PATH = REPO_ROOT / ".env"


def _load_dotenv_if_present() -> None:
    if not ENV_PATH.exists():
        return
    try:
        for raw_line in ENV_PATH.read_text(encoding="utf-8").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip().strip('"').strip("'")
            if key and (key not in os.environ or not os.environ.get(key)):
                os.environ[key] = value
    except OSError:
        # Non-fatal: env vars may already be provided by the host process.
        pass


_load_dotenv_if_present()
_configured_provider = os.getenv("MNEMO_PROVIDER")
if _configured_provider:
    PROVIDER = _configured_provider.lower()
elif os.getenv("GEMINI_API_KEY"):
    PROVIDER = "gemini"
else:
    PROVIDER = "openai"

SKIP_NAMES = {
    "README.md",
    "index.md",
    "lessons-index.json",
    "journal-index.json",
    "journal-index.md",
}
SKIP_DIRS = {"legacy", "templates"}

mcp = FastMCP("MnemoVector")


def get_embedding(text: str) -> list[float]:
    # Conservative provider-agnostic cap for dense text/CJK/code.
    trimmed = text[:12000] if len(text) > 12000 else text
    if PROVIDER == "gemini":
        key = os.getenv("GEMINI_API_KEY")
        if not key:
            raise RuntimeError("GEMINI_API_KEY is not set")
        from google import genai
        client = genai.Client(api_key=key)
        result = client.models.embed_content(
            model="gemini-embedding-001",
            contents=trimmed,
            config={"output_dimensionality": EMBED_DIM},
        )
        return result.embeddings[0].values

    key = os.getenv("OPENAI_API_KEY")
    if not key:
        raise RuntimeError("OPENAI_API_KEY is not set")
    from openai import OpenAI
    client = OpenAI(api_key=key)
    resp = client.embeddings.create(input=[trimmed], model="text-embedding-3-small")
    return resp.data[0].embedding


def get_db() -> sqlite3.Connection:
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    db = sqlite3.connect(str(DB_PATH), timeout=30)
    db.execute("PRAGMA journal_mode=WAL")
    db.execute("PRAGMA busy_timeout=10000")
    db.enable_load_extension(True)
    sqlite_vec.load(db)
    return db


def init_db() -> sqlite3.Connection:
    db = get_db()
    db.execute("CREATE TABLE IF NOT EXISTS schema_info (key TEXT PRIMARY KEY, value TEXT)")
    row = db.execute("SELECT value FROM schema_info WHERE key='version'").fetchone()
    ver = int(row[0]) if row else 0

    if ver < SCHEMA_VERSION:
        db.execute("DROP TABLE IF EXISTS file_meta")
        db.execute("DROP TABLE IF EXISTS vec_memory")
        db.execute(
            """
            CREATE TABLE file_meta (
                path TEXT PRIMARY KEY,
                hash TEXT NOT NULL,
                chunk_count INTEGER DEFAULT 0,
                updated_at REAL DEFAULT (unixepoch('now'))
            )
            """
        )
        db.execute(
            f"""
            CREATE VIRTUAL TABLE vec_memory USING vec0(
                embedding float[{EMBED_DIM}] distance_metric=cosine,
                +ref_path TEXT,
                +content TEXT,
                +source_file TEXT
            )
            """
        )
        db.execute(
            "INSERT OR REPLACE INTO schema_info(key, value) VALUES ('version', ?)",
            (str(SCHEMA_VERSION),),
        )
        db.commit()
    return db


def chunk_markdown(content: str, file_path: Path) -> list[tuple[str, str]]:
    chunks: list[tuple[str, str]] = []
    path_str = str(file_path).replace("\\", "/")

    # Journal: one chunk per date section.
    if "journal/" in path_str.lower():
        parts = re.split(r"^(##\s+\d{4}-\d{2}-\d{2})", content, flags=re.MULTILINE)
        preamble = parts[0].strip()
        if preamble:
            chunks.append((preamble, f"@{path_str}"))
        i = 1
        while i < len(parts) - 1:
            heading = parts[i].strip()
            body = parts[i + 1].strip()
            date = heading.replace("##", "").strip()
            chunks.append((f"{heading}\n{body}".strip(), f"@{path_str}# {date}"))
            i += 2
        if chunks:
            return chunks

    # Lessons are already atomic.
    if file_path.parent.name == "lessons" and file_path.name.startswith("L-"):
        text = content.strip()
        if text:
            m = re.match(r"(L-\d{3})", file_path.name)
            ref = f"@{path_str}# {m.group(1)}" if m else f"@{path_str}"
            chunks.append((text, ref))
        return chunks

    parts = re.split(r"^(#{1,4}\s+.+)$", content, flags=re.MULTILINE)
    preamble = parts[0].strip()
    if preamble:
        chunks.append((preamble, f"@{path_str}"))

    i = 1
    while i < len(parts) - 1:
        heading_line = parts[i].strip()
        body = parts[i + 1].strip()
        heading_text = re.sub(r"^#{1,4}\s+", "", heading_line)
        full = f"{heading_line}\n{body}".strip() if body else heading_line
        if full.strip():
            chunks.append((full, f"@{path_str}# {heading_text}"))
        i += 2

    if not chunks and content.strip():
        chunks.append((content.strip(), f"@{path_str}"))
    return chunks


@mcp.tool()
def vector_sync() -> str:
    try:
        db = init_db()
    except Exception as e:
        return f"DB init failed: {e}"

    files: dict[str, Path] = {}
    for p in MEM_ROOT.glob("**/*.md"):
        if p.name in SKIP_NAMES:
            continue
        if any(skip in p.parts for skip in SKIP_DIRS):
            continue
        files[str(p)] = p

    updated = 0
    skipped = 0
    errors = 0

    known = db.execute("SELECT path FROM file_meta").fetchall()
    for (stored,) in known:
        if stored not in files:
            db.execute("DELETE FROM vec_memory WHERE source_file = ?", (stored,))
            db.execute("DELETE FROM file_meta WHERE path = ?", (stored,))
            updated += 1

    for str_path, file_path in files.items():
        try:
            content = file_path.read_text(encoding="utf-8-sig")
        except (UnicodeDecodeError, PermissionError, OSError):
            errors += 1
            continue

        if not content.strip():
            skipped += 1
            continue

        f_hash = hashlib.sha256(content.encode("utf-8")).hexdigest()
        row = db.execute("SELECT hash FROM file_meta WHERE path = ?", (str_path,)).fetchone()
        if row and row[0] == f_hash:
            skipped += 1
            continue

        db.execute("DELETE FROM vec_memory WHERE source_file = ?", (str_path,))
        chunks = chunk_markdown(content, file_path)
        embedded = 0
        chunk_errors = 0

        for text, ref in chunks:
            try:
                emb = get_embedding(text)
                db.execute(
                    "INSERT INTO vec_memory(embedding, ref_path, content, source_file) VALUES (?, ?, ?, ?)",
                    (serialize_f32(emb), ref, text, str_path),
                )
                embedded += 1
            except Exception:
                chunk_errors += 1

        if chunk_errors == 0:
            db.execute(
                "INSERT OR REPLACE INTO file_meta(path, hash, chunk_count, updated_at) VALUES (?, ?, ?, unixepoch('now'))",
                (str_path, f_hash, embedded),
            )
        else:
            # Mark as dirty so next sync retries this file even if content is unchanged.
            db.execute(
                "INSERT OR REPLACE INTO file_meta(path, hash, chunk_count, updated_at) VALUES (?, ?, ?, unixepoch('now'))",
                (str_path, "DIRTY", embedded),
            )
            errors += chunk_errors
        updated += 1

    db.commit()
    db.close()
    msg = f"Synced: {updated} files processed, {skipped} unchanged"
    if errors:
        msg += f", {errors} chunk errors (will retry)"
    return msg


@mcp.tool()
def vector_search(query: str, top_k: int = 5) -> str:
    try:
        db = init_db()
        emb = get_embedding(query)
        rows = db.execute(
            "SELECT ref_path, content, distance FROM vec_memory WHERE embedding MATCH ? AND k = ? ORDER BY distance",
            (serialize_f32(emb), top_k),
        ).fetchall()
        db.close()
    except Exception as e:
        return f"Search failed: {e}"

    if not rows:
        return "No relevant memory found."

    out = []
    for ref, content, dist in rows:
        sim = round(1.0 - dist, 4)
        preview = " ".join(content[:400].split())
        out.append(f"[sim={sim:.3f}] {ref}\n{preview}")
    return "\n\n---\n\n".join(out)


@mcp.tool()
def vector_forget(path_pattern: str = "") -> str:
    try:
        db = init_db()
        removed = 0
        if path_pattern:
            like = f"%{path_pattern}%"
            r1 = db.execute("DELETE FROM vec_memory WHERE source_file LIKE ?", (like,)).rowcount
            r2 = db.execute("DELETE FROM file_meta WHERE path LIKE ?", (like,)).rowcount
            removed = max(r1, r2)
        else:
            known = db.execute("SELECT path FROM file_meta").fetchall()
            for (p,) in known:
                if not Path(p).exists():
                    db.execute("DELETE FROM vec_memory WHERE source_file = ?", (p,))
                    db.execute("DELETE FROM file_meta WHERE path = ?", (p,))
                    removed += 1
        db.commit()
        db.close()
        return f"Pruned {removed} entries."
    except Exception as e:
        return f"Forget failed: {e}"


@mcp.tool()
def vector_health() -> str:
    lines = []
    try:
        db = init_db()
        ver = db.execute("SELECT value FROM schema_info WHERE key='version'").fetchone()
        lines.append(f"Schema: v{ver[0] if ver else '?'}")
        files = db.execute("SELECT COUNT(*) FROM file_meta").fetchone()[0]
        vecs = db.execute("SELECT COUNT(*) FROM vec_memory").fetchone()[0]
        dirty = db.execute("SELECT COUNT(*) FROM file_meta WHERE hash = 'DIRTY'").fetchone()[0]
        lines.append(f"Files tracked: {files}")
        lines.append(f"Vector chunks: {vecs}")
        if dirty:
            lines.append(f"Dirty files: {dirty}")
        lines.append(f"DB integrity: {db.execute('PRAGMA integrity_check').fetchone()[0]}")
        db.close()
    except Exception as e:
        lines.append(f"DB error: {e}")

    try:
        _ = get_embedding("health check")
        lines.append(f"Embedding API ({PROVIDER}): OK")
    except Exception as e:
        lines.append(f"Embedding API ({PROVIDER}): FAILED - {e}")
    return "\n".join(lines)


if __name__ == "__main__":
    mcp.run()