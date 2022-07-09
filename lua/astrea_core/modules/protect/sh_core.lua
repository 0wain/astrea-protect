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
AstreaToolbox.Core.AddSubSetting("net", "net_print", "protect", {["type"] = "bool", ["clientside"] = false}, true, "Net Message Print", "Log incoming net messages in server console.")
AstreaToolbox.Core.AddSubSetting("net", "net_whitelist", "protect", {["type"] = "list", ["clientside"] = false, {["type"] = "string", ["min"]= 0, ["max"]= 128, ["printname"] = "Net Message", ["case"] = "lower"}}, {}, "Net Message Whitelist", "A list of Net Messages that are whitelisted from being monitored.")
AstreaToolbox.Core.AddSubSetting("net", "net_log", "protect", {
    ["type"] = "table", 
    ["columns"] = {
        [1] = {
            ["name"] = "player",
            ["datatype"] = "TEXT",
            ["visible"] = true,
            ["printname"] = "Player"
        }, 
        [2] = {
            ["name"] = "net_msg",
            ["datatype"] = "TEXT",
            ["visible"] = true,
            ["printname"] = "Net Message"
        }, 
        [3] = {
            ["name"] = "date",
            ["datatype"] = "INTEGER",
            ["visible"] = true, 
            ["display"] = function(str)
                return os.date('%c', str)
            end,
            ["printname"] = "Date"
        }
    },

    ["descending"] = true 
}, {}, "Net Logs", "A list of all logged net violations.")

AstreaToolbox.Core.AddSetting("http", "protect", {["type"] = "bool", ["clientside"] = false}, false, "HTTP", "Should HTTP Requests be monitored?")
AstreaToolbox.Core.AddSubSetting("http", "http_print", "protect", {["type"] = "bool", ["clientside"] = false}, true, "HTTP Print", "Log incoming HTTP requests in server console.")
AstreaToolbox.Core.AddSubSetting("http", "http_blacklist", "protect", {["type"] = "list", ["clientside"] = false, {["type"] = "string", ["min"]= 0, ["max"]= 500, ["printname"] = "Domain", ["case"] = "lower"}}, {}, "HTTP Blacklist", "A list of domains that are blocked by the HTTP library.")
AstreaToolbox.Core.AddSubSetting("http", "http_log", "protect", {
    ["type"] = "table", 
    ["columns"] = {
        [1] = {
            ["name"] = "url",
            ["datatype"] = "TEXT",
            ["visible"] = true,
            ["printname"] = "URL"
        }, 
        [2] = {
            ["name"] = "method",
            ["datatype"] = "TEXT",
            ["visible"] = true,
            ["printname"] = "Method"
        }, 
        [3] = {
            ["name"] = "date",
            ["datatype"] = "INTEGER",
            ["visible"] = true, 
            ["display"] = function(str)
                return os.date('%c', str)
            end,
            ["printname"] = "Date"
        }
    },

    ["descending"] = true 
}, {}, "HTTP Logs", "A list of all logged HTTP requests.")

-- Load any other files
if SERVER then
    include("astrea_core/modules/protect/sv_core.lua")
end