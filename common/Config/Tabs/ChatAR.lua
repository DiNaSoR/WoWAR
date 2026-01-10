-- Arabic Chat options group
-------------------------------------------------------------------------------------------------------

WOWTR = WOWTR or {}
WOWTR.Config = WOWTR.Config or {}
WOWTR.Config.Groups = WOWTR.Config.Groups or {}

function WOWTR.Config.Groups.ChatAR()
  return WOWTR.Config.MakeTab("chatAR", {
    order = 6,
    name = function() return WOWTR.Config.Label("chatService", "Arabic Chat") end,
    hidden = function() return not (WOWTR_Localization and WOWTR_Localization.lang == 'AR') end,
    args = {
      basics = {
        type = "group", inline = true, order = 1,
        name = WOWTR.Config.Label("chatService", "Arabic Chat"),
        args = {
          active = { type = "toggle", name = WOWTR.Config.Label("activateChatService", "Enable"), desc = WOWTR.Config.Label("activateChatServiceDESC", "Enable Arabic chat input."), order = 1, width = "full" },
        }
      },
      appearance = {
        type = "group", inline = true, order = 5,
        name = WOWTR.Config.Label("fontSizeHeader", "Appearance"),
        args = {
          setsize = { type = "toggle", name = WOWTR.Config.Label("chatFontActivate", "Custom size"), desc = WOWTR.Config.Label("chatFontActivateDESC", "Enable custom font size for Arabic chat."), order = 2, width = "full" },
          fontsize = { type = "range", name = WOWTR.Config.Label("fontsizeChat", "Font size"), desc = WOWTR.Config.Label("fontsizeChatDESC", "Adjust chat font size."), min = 10, max = 24, step = 1, order = 3, width = "full" },
        }
      },
    },
  })
end

