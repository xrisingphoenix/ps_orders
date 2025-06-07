ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('ps_orders:getmoney', function(source, cb, account)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getAccount(account).money
    cb(money)
end)

RegisterServerEvent("ps_orders:removemoney")
AddEventHandler("ps_orders:removemoney", function(amount, account)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeAccountMoney(account, amount)
end)

RegisterServerEvent("ps_orders:additems")
AddEventHandler("ps_orders:additems", function(warenkorb)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,item in pairs(warenkorb) do
        -- print(item.name) -- debug
        xPlayer.addInventoryItem(item.name, 1)
    end
end)

RegisterServerEvent("ps_orders:altertpolice")
AddEventHandler("ps_orders:altertpolice", function(minutes, hint, blip, coords)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        for k, jobname in pairs(Config.PoliceJobs) do
            if xPlayer.job.name == jobname then
                TriggerClientEvent("ps_orders:alertpolice_c", xPlayer.source, minutes, hint, blip, coords)
            end
        end
    end
end)

RegisterServerEvent("ps_orders:webhook")
AddEventHandler("ps_orders:webhook", function(text)
    local xPlayer = ESX.GetPlayerFromId(source)
	local webhook = Config.Webhook
	local information = {
		{
			["color"] = '6684876',
			["author"] = {
				["icon_url"] = 'https://i.ibb.co/DgtFmvr6/ps-logo-1-circle.png',
				["url"] = 'https://discord.com/invite/CUXK7CWx3P',
				["name"] = 'Phoenix Studios',
			},
			
			['url'] = 'https://github.com/Ph-o-e-n-ix/',
			["title"] = 'Electrician Job',
	
			["description"] = '**' ..xPlayer.getName()..'** '..text,
	
			["footer"] = {
				["text"] = os.date('%d/%m/%Y [%X] • PHOENIX STUDIOS'),
				["icon_url"] = 'https://i.ibb.co/60rCYFmk/logo2.png',
			}
		}
	}
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'PHOENIX STUDIOS', embeds = information, avatar_url = 'https://i.ibb.co/mV504dFz/ps-logo-2-circle.png' }), {['Content-Type'] = 'application/json'}) 
end)