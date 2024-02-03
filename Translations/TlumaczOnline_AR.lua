-- Arabic database of translated quest texts
-- for the addon WoWAR-Quests

TO_lang = "AR";
TO_date = "2023-05-26";

-- ÇEVRİMİÇİ çeviri tablosu
QTR_Tlumacz_Online = {
};

function pairsByKeys (t)
   local a = {}
   for n in pairs(t) do table.insert(a, n) end
   table.sort(a, function(a, b) return a > b end)
   local i = 0      -- iterator variable
   local iter = function ()   -- iterator function
      i = i + 1
      if a[i] == nil then return nil
         else return a[i], t[a[i]]
      end
   end
   return iter
end

