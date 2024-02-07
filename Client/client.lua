-- MS-REPORTS by Jozo85 & the._nammeless

prefix = "[MS-REPORTS]"

RegisterCommand("report", function(source, args, rawCommand)
    local src = source
    local input = lib.inputDialog('Report player', {'ID', 'Reason'})

    if input then 
        local pID = tonumber(input[1])
        local reason = input[2]

        if pID == nil then
            TriggerEvent('chatMessage', '', {255, 255, 255}, prefix..'^1ERROR: You must include a ID!') 
        elseif reason == nil then
            TriggerEvent('chatMessage', '', {255, 255, 255}, prefix..'^1ERROR: You must include a reason!')
        else
            TriggerServerEvent("ms-scripts:Report", pID, reason)
        end
    end
end, false)