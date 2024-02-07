-- MS-REPORTS by Jozo85 & the._nammeless

prefix = "[MS-REPORTS]"

RegisterNetEvent("ms-scripts:Report")
AddEventHandler("ms-scripts:Report", function(pID, reason)
    local src = source
    local name = GetPlayerName(src)
    local ids = ExtractIdentifiers(pID);
    local steam = ids.steam:gsub("steam:", "");
    local steamDec = tostring(tonumber(steam,16));
    steam = "https://steamcommunity.com/profiles/"..steamDec;
    local gameLicense = ids.license;
    local discord = ids.discord;  

    if pID ~= nil and reason ~= nil then
        if GetPlayerIdentifiers(pID)[1] == nil then
            TriggerClientEvent('chatMessage', src, prefix.."\n^1ERROR: Player is not online.")
        else
            TriggerClientEvent('chatMessage', src, prefix.."\nThank you for submitting a report!")
                local players = GetAllPlayers()
                for i=1, #players do
                    if IsPlayerAceAllowed(players[i], "report.view") then
                        TriggerClientEvent('chatMessage', players[i], 
                        prefix.."\n^1Player ^1[^3"..pID.."^1] ^3"..GetPlayerName(pID).." ^1was reported by: ^1[^3"..src.."^1] ^3"..name.." ^1for: ^3"..reason)
                    end
                end

            if Config.Screenshot then
                exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(pID,
                Config.DiscordWebhook,
                {
                    encoding = "png",
                    quality = 1
                },
                {
                    embeds = {
                        {
                            ["color"] = 15844367,
                            ["title"] = "Player ["..pID.."] ["..GetPlayerName(pID).."] was reported..",
                            ["description"] = "**Reason**: ``"..reason.."``"..
                            "\n**Game License:** ``"..gameLicense..
                            "``\n**Discord UID:** ``"..discord:gsub('discord:', '')..
                            "``\n**Discord-Tag:** <@!"..discord:gsub('discord:', '')..">"..
                            "\n**Steam:** "..steam,
                            ["footer"] = {
                                ["text"] = "Reported by: ["..src.."] "..name,
                                ["icon_url"] = "https://cdn.discordapp.com/attachments/710862611000066142/1204841701131288607/ms.png?ex=65d63346&is=65c3be46&hm=15afed850d55879aad771f91d79b7b5b34638eca33b5fae991d1dd11243cfb96&",
                            },
                        }
                    }
                },
                30000)
            else
                sendToDisc("Player ["..pID.."] ["..GetPlayerName(pID).."] was reported..", 
                "**Reason**: ``"..reason.."``"..
                "\n**Game License:** ``"..gameLicense..
                "``\n**Discord UID:** ``"..discord:gsub('discord:', '')..
                "``\n**Discord-Tag:** <@!"..discord:gsub('discord:', '')..">"..
                "\n**Steam:** "..steam,
                "Reported by: ["..src.."] "..name)
            end
        end
    end
end)

-- Functions
function sendToDisc(title, msg, fmsg)
    local embed = {
        {
            ["color"] = 15844367,
            ["title"] = "**".. title .."**",
            ["description"] = msg,
            ["footer"] = {
                ["text"] = fmsg,
                ["icon_url"] = "https://cdn.discordapp.com/attachments/710862611000066142/1204841701131288607/ms.png?ex=65d63346&is=65c3be46&hm=15afed850d55879aad771f91d79b7b5b34638eca33b5fae991d1dd11243cfb96&",
            },
        }
    }
    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function GetAllPlayers()
    local players = {}

    for _, i in ipairs(GetPlayers()) do
        table.insert(players, i)    
    end

    return players
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end