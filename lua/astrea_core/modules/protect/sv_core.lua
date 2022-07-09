local lastWipe = {}
local messageCount = {}

local function logNetPrint(msg)
    if (!AstreaToolbox.Core.GetSetting("net_print")) then return end -- They don't have printing enabled
    print("[Astrea Protect | Net Messages]", msg)
end

function net.Incoming(len, client)
	local i = net.ReadHeader()
	local strName = util.NetworkIDToString( i )
	
    -- They're already being kicked, ignore any future messages
    if client.netMessageKicked then return end

	if not strName then return end
	local netMsg = strName:lower()

	local func = net.Receivers[netMsg]
	if not func then return end
	
	if AstreaToolbox.Core.GetSetting("net") then
		if not table.HasValue(AstreaToolbox.Core.GetSetting("net_whitelist"), netMsg) then
			if client then
                local id64 = client:SteamID64()
                local name = client:Nick()

				if (not lastWipe[id64]) or (not messageCount[id64]) then
					lastWipe[id64] = 0
					messageCount[id64] = 0
					logNetPrint(string.format("New user being registered to the system: %s (%s)", name, id64))
				end

				if lastWipe[id64] < (CurTime() - AstreaToolbox.Core.GetSetting("net_buffer")) then
					messageCount[id64] = 0
					lastWipe[id64] = CurTime()
					logNetPrint(string.format("Reset: %s's message counter", name))
				end

				local C = messageCount[id64] or 0

				messageCount[id64] = C + 1

				if (C) and (!(AstreaToolbox.Core.GetSetting("net_limit") == 0)) and (C > AstreaToolbox.Core.GetSetting("net_limit")) then
					logNetPrint(string.format("Kicking %s (%s) for suspected net message spamming", name, id64))
					client:Kick("Suspected Exploiting")

					AstreaToolbox.Core.AddTableRow("net_log", {string.format("%s (%s)", name, id64), strName, os.time()})

					client.netMessageKicked = true
					return
				end

                logNetPrint(string.format("Message received from %s (%s). The net message was '%s'. Their current count is: %i", name, id64, strName, messageCount[id64]))
			else
                logNetPrint(string.format("Message received from Unknown user. The net message was '%s'", strName))
			end
		end
	end
	
	len = len - 16
	func( len, client )
end



local function logHTTPPrint(msg)
    if (!AstreaToolbox.Core.GetSetting("http_print")) then return end -- They don't have printing enabled
    print("[Astrea Protect | HTTP]", msg)
end

function http.Fetch( url, onsuccess, onfailure, header )
	if AstreaToolbox.Core.GetSetting("http") then
		if (AstreaToolbox.Core.GetSetting("http_blacklist")) then
			for k, v in pairs(AstreaToolbox.Core.GetSetting("http_blacklist")) do
				if (string.find(string.lower(url), string.low(v))) then
					logHTTPPrint(string.format("Request to %s blocked as the domain is in the blacklist", url))
					return
				end
			end
		end

		logHTTPPrint(string.format("Fetch request made to %s", url))
		AstreaToolbox.Core.AddTableRow("http_log", {url, "Fetch", os.time()})
	end

	local request = {
		url			= url,
		method		= "get",
		headers		= header or {},

		success = function( code, body, headers )

			if ( !onsuccess ) then return end

			onsuccess( body, body:len(), headers, code )

		end,

		failed = function( err )

			if ( !onfailure ) then return end

			onfailure( err )

		end
	}

	HTTP( request )
end

function http.Post( url, onsuccess, onfailure, header )
	if AstreaToolbox.Core.GetSetting("http") then
		if (AstreaToolbox.Core.GetSetting("http_blacklist")) then
			for k, v in pairs(AstreaToolbox.Core.GetSetting("http_blacklist")) do
				if (string.find(string.lower(url), string.low(v))) then
					logHTTPPrint(string.format("Request to %s blocked as the domain is in the blacklist", url))
					return
				end
			end
		end

		logHTTPPrint(string.format("Post request made to %s", url))
		AstreaToolbox.Core.AddTableRow("http_log", {url, "Post", os.time()})
	end


	local request = {
		url			= url,
		method		= "post",
		parameters	= params,
		headers		= header or {},

		success = function( code, body, headers )

			if ( !onsuccess ) then return end

			onsuccess( body, body:len(), headers, code )

		end,

		failed = function( err )

			if ( !onfailure ) then return end

			onfailure( err )

		end
	}

	HTTP( request )
end