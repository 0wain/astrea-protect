AstreaToolbox.Core.EnableModule("protect", true)

AstreaToolbox.Translations["protect"] = "Protect"
AstreaToolbox.Config["protect"] = AstreaToolbox.Config["protect"] or {}

if CLIENT then 
    AstreaToolbox.derma.downloadImage("LeMumxi", "main", function(fileName)
        AstreaToolbox.Config["protect"]["Material"] = AstreaToolbox.derma.images[fileName] or Material("astrea/main/"..fileName..".png")
    end)
end 

AstreaToolbox.Core.AddSetting("net", "protect", {["type"] = "bool", ["clientside"] = false}, false, "Net Messages", "Should Net Messages be monitored?")
AstreaToolbox.Core.AddSubSetting("net", "net_limit", "protect", {["type"] = "number", ["clientside"] = false, ["min"] = 0, ["max"] = 200}, 70, "Net Message Threshold", "The amount of Net Messages needed to be received by a user within the buffer to trigger a prevention.")
AstreaToolbox.Core.AddSubSetting("net", "net_buffer", "protect", {["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 10}, 2, "Net Message Buffer", "The buffer between Net Message Threshold resets (Seconds).")
AstreaToolbox.Core.AddSubSetting("net", "net_print", "protect", {["type"] = "bool", ["clientside"] = false}, true, "Net Message Logging", "Log incoming net messages in server console.")
AstreaToolbox.Core.AddSubSetting("net", "net_whitelist", "protect", {["type"] = "list", ["clientside"] = false, {["type"] = "string", ["min"]= 0, ["max"]= 128, ["printname"] = "Net Message", ["case"] = "lower"}}, {}, "Net Message Whitelist", "The net message")

-- Load any other files
if SERVER then
    include("astrea_core/modules/protect/sv_core.lua")
end