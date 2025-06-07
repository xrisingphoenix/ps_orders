ESX = exports["es_extended"]:getSharedObject()

AddEventHandler('onClientResourceStart', function(ressourceName)
    if(GetCurrentResourceName() ~= ressourceName) then 
        return 
    end 
    print("" ..ressourceName.." started sucessfully")
end)

local busy = false
local warenkorb = {}
local warenkorblabel = {}
local price = 0

Citizen.CreateThread(function()
    for k,v in pairs(Config.Start) do
        if v.blip.enable then 
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, v.blip.blipid)
            SetBlipColour(blip, v.blip.blipcolor)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.blip.blipscale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.blipname)
            EndTextCommandSetBlipName(blip)
        end
        
        local hash = GetHashKey(v.ped)
        RequestModel(hash)
        while not HasModelLoaded(hash) do 
            Citizen.Wait(25)
        end
        local ped = CreatePed(4, hash, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(Config.Start) do
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local vec3coords = vector3(v.coords.x, v.coords.y, v.coords.z)
            local dist = #(vec3coords - coords)
            if dist <= 1.5 then 
                DrawText3D(v.coords.x, v.coords.y, v.coords.z, v.prefix..'[E]~s~ '..v.blip.blipname)
                if IsControlJustReleased(0, 38) then 
                    if not busy then
                        openshop(v.category)
                    else
                        Config.Notify(Translation[Config.Locale]['order_already_running'])
                    end
                end
            end
        end
    end
end)

function openshop(category)
    price = 0
    globaloptions = category
    local optionen = {}
    options2 = {
        title = Translation[Config.Locale]['menu_category_title'], 
        description = Translation[Config.Locale]['menu_category_desc'],
        icon = 'fa-solid fa-list',
        iconColor = 'white'
    }
    table.insert(optionen, options2)
    for k,v in pairs(category) do
        for _, item in pairs(Config.Items) do
            if v == _ then 
                optionen[#optionen+1] = 
                {
                    title = _,
                    description = Translation[Config.Locale]['menu_category_desc'],
                    icon = 'fa-solid fa-list',
                    iconColor = Config.ColorScheme,
                    progress = 100,
                    colorScheme = Config.ColorScheme,
                    onSelect = function()
                        openitems(_)
                    end,
                }
            end
        end 
    end
    lib.registerContext({
        id = 'ps_orders_1',
        title = Translation[Config.Locale]['menu_order_title'],
        icon = 'fa-solid fa-basket-shopping',
        onExit = function()
            for k in pairs (warenkorb) do
                warenkorb [k] = nil
            end
            price = 0
        end,
        options = optionen
    
    })
    lib.showContext('ps_orders_1')

end


function openitems(category)
    local optionen = {}
    if json.encode(warenkorb) == '[]' then 
    else 
        local optionen4 = { 
            title = Translation[Config.Locale]['menu_cart_title'],
            icon = 'fa-solid fa-basket-shopping',
            description = Translation[Config.Locale]['menu_cart_desc'],
            progress = 100,
            colorScheme = 'blue',
            onSelect = function()
                openwarenkorb(warenkorb, category)
            end,
        }
        table.insert(optionen, optionen4)
    end
    local itemlist = Config.Items[category].items
    for k,v in pairs(itemlist) do
        local descr =  string.format(Translation[Config.Locale]['menu_put_cart'], tostring(v.price))
        optionen[#optionen+1] =  
        {
            title = v.label,
            colorScheme = 'yellow',
            description = descr,
            -- image = v.image,
            icon = 'fa-solid fa-box',
            iconColor = Config.ColorScheme,
            progress = 100,
            colorScheme = Config.ColorScheme, 
            onSelect = function()
                local desc = string.format(Translation[Config.Locale]['menu_max_amount'], v.maxamount)
                local dialog = lib.inputDialog(Translation[Config.Locale]['dialog_amount'], {
                    { type = 'number', label = Translation[Config.Locale]['dialog_amount_desc'], description= desc, default = '0', min = 1, max = v.maxamount, icon = 'fa-solid fa-arrow-up-short-wide'}
                    }
                )
                if dialog ~= nil then
                    if dialog[1] <= v.maxamount then
                        if dialog[1] == 0 then
                            openitems(category)
                        else 
                            for i = 1, dialog[1], 1 do 
                                price = price + v.price
                                table.insert(warenkorb, { name = v.itemname, label = v.label, price = v.price})
                                -- table.insert(warenkorblabel, v.label)
                            end
                            Config.Notify(string.format(Translation[Config.Locale]['item_added_cart'], dialog[1], v.label))
                            openitems(category)
                        end
                    else 
                        Config.Notify(string.format(Translation[Config.Locale]['max_order_limit'], v.maxamount, v.label))
                        openitems(category)
                    end
                else 
                    openitems(category)
                end
            end,
        }
    end
    lib.registerContext({
        id = 'ps_orders_2',
        title = Translation[Config.Locale]['menu_order_title'],
        icon = 'lightning',
        menu = 'ps_orders_1',
        onExit = function()
            for k in pairs (warenkorb) do
                warenkorb [k] = nil
            end
            price = 0
        end,
        options = optionen
    
    })
    lib.showContext('ps_orders_2')
end

function openwarenkorb(warenkorb, category)
    local test = {}
    if json.encode(warenkorb) == '[]' then 
    else
        local bestellen = {
            title = Translation[Config.Locale]['menu_order_finish_title'],
            description = Translation[Config.Locale]['menu_order_finish_desc'],
            progress = 100,
            colorScheme = 'green',
            onSelect = function()
                local dialog = lib.inputDialog(Translation[Config.Locale]['dialog_confirm_title'], {
                    {type = 'checkbox', label = string.format(Translation[Config.Locale]['dialog_confirm_desc'], price)},
                    }
                )
                if dialog ~= nil then 
                    if dialog[1] then 
                        
                        local dia = lib.inputDialog(Translation[Config.Locale]['dialog_time_title'], {
                            { type = 'number', label = Translation[Config.Locale]['dialog_time_desc'], description= string.format(Translation[Config.Locale]['dialog_time_desc2'], Config.Time.min, Config.Time.max), default = '1', min = Config.Time.min, max = Config.Time.max, icon = 'fa-regular fa-clock'}
                            }
                        )
                        if dia ~= nil then 
                            if dia[1] > 0 then
                                local minutes = dia[1]
                                startorder(minutes, warenkorb, price, category)
                            end 
                        end
                                    
                    else 
                        Config.Notify(Translation[Config.Locale]['canceled_order'])
                        openwarenkorb(warenkorb, category)
                    end 
                else 
                    openwarenkorb(warenkorb, category)
                end
            end,
        }
        table.insert(test, bestellen)
    end





    for k,v in pairs(warenkorb) do
        test[#test+1] =  
        {
            title = v.label,
            description = Translation[Config.Locale]['menu_remove_item_desc'],
            -- image = v.image,
            icon = 'fa-solid fa-xmark',
            iconColor = 'red',
            progress = 100,
            colorScheme = 'red', 
            onSelect = function()
                table.remove(warenkorb, k)
                price = price - v.price
                openwarenkorb(warenkorb, category)
            end,
        }
    end

    lib.registerContext({
        id = 'ps_orders_warenkorb',
        title = Translation[Config.Locale]['menu_cart_title'],
        icon = 'lightning',
        menu = 'ps_orders_2',
        onExit = function()
            for k in pairs (warenkorb) do
                warenkorb [k] = nil
            end
            price = 0
        end,
        options = test
    
    })
    lib.showContext('ps_orders_warenkorb')
end

function startorder(minutes, warenkorb, price, category)
    busy = true
    local text = string.format(Translation[Config.Locale]['webhook_started_order'], price, minutes, json.encode(warenkorb))
    TriggerServerEvent("ps_orders:webhook", text)
    local time = (minutes * 60000)
    local randomspot = Config.Items[category].randomspots[math.random(#Config.Items[category].randomspots)]
    if Config.Items[category].alertpolice.enable then 
        local chance = Config.Items[category].alertpolice.chance
        local random = math.random(1,100)
        if random < chance then 
            TriggerServerEvent("ps_orders:altertpolice", minutes, randomspot.hint, Config.Items[category].alertpolice.blip, randomspot.coords)
        end
    end
    local account = Config.Items[category].account
    if account == nil then
        showPictureNotification(Translation[Config.Locale]['pic_notify_char'], string.format(Translation[Config.Locale]['pic_notify_desc'], minutes), Translation[Config.Locale]['menu_order_title'], Translation[Config.Locale]['pic_notify_desc2'])
    elseif account == 'bank' then
        showPictureNotification(Translation[Config.Locale]['pic_notify_char'], string.format(Translation[Config.Locale]['pic_notify_desc'], minutes), Translation[Config.Locale]['menu_order_title'], Translation[Config.Locale]['pic_notify_pay_card'])
    elseif account == 'money' then
        showPictureNotification(Translation[Config.Locale]['pic_notify_char'], string.format(Translation[Config.Locale]['pic_notify_desc'], minutes), Translation[Config.Locale]['menu_order_title'], Translation[Config.Locale]['pic_notify_pay_cash'])
    elseif account == 'black_money' then 
        showPictureNotification(Translation[Config.Locale]['pic_notify_char'], string.format(Translation[Config.Locale]['pic_notify_desc'], minutes), Translation[Config.Locale]['menu_order_title'], Translation[Config.Locale]['pic_notify_pay_black'])
    end
    if Config.Debug then 
        Citizen.Wait(5000)
    else 
        Citizen.Wait(time)
    end
    showPictureNotification(Translation[Config.Locale]['pic_notify_char'], Translation[Config.Locale]['pic_notify_order_ready_desc'], Translation[Config.Locale]['menu_order_title'], Translation[Config.Locale]['pic_notify_order_ready_desc2'])
    
    local blip = AddBlipForCoord(randomspot.coords)
    SetBlipSprite(blip, 280)
    SetBlipColour(blip, 47)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Translation[Config.Locale]['blip_pickup_coords'])
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, true)

    local hash = GetHashKey(randomspot.ped)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Citizen.Wait(25)
    end
    local xyz = vector3(randomspot.coords.x, randomspot.coords.y, randomspot.coords.z)
    local plcoords = GetEntityCoords(PlayerPedId())
    while #(plcoords - xyz) > Config.DistToSpawnPed do 
        Citizen.Wait(500)
        plcoords = GetEntityCoords(PlayerPedId())
    end
    abholped = CreatePed(4, hash, randomspot.coords.x, randomspot.coords.y, randomspot.coords.z - 1.0, randomspot.coords.w, true, false)
    FreezeEntityPosition(abholped, true)
    SetBlockingOfNonTemporaryEvents(abholped, true)
    SetEntityInvincible(abholped, true)
    local done = false
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local pedpos = GetEntityCoords(abholped)
            local xyz = vector3(randomspot.coords.x, randomspot.coords.y, randomspot.coords.z)
            local plcoords = GetEntityCoords(PlayerPedId())
            local dist = #(plcoords - xyz)
            if dist <= 1.5 and not done then 
                DrawText3D(xyz.x, xyz.y, xyz.z, '~g~[E]~s~ '..Translation[Config.Locale]['3dtext_pickup_items'])
                if IsControlJustReleased(0, 38) then 
                    if busy then
                        if Config.Items[category].account == nil then
                            local account = nil
                            local preis = string.format(Translation[Config.Locale]['pickup_price'], tostring(price))
                            local dialog = lib.inputDialog(Translation[Config.Locale]['payment_method_title'], {
                                { type = 'select', label = Translation[Config.Locale]['payment_method_desc'], description = preis, options = {
                                    { value = 'default',label = Translation[Config.Locale]['dialog_payment_cash']},
                                    { value = 'card', label = Translation[Config.Locale]['dialog_payment_card']},
                                }, 
                                description= Translation[Config.Locale]['dialog_choose_option'],
                                default = 'default',
                                icon = 'fa-solid fa-money-bill-wave'}}) 
                            if dialog ~= nil then 
                                if dialog[1] == 'default' then
                                    account = 'money'
                                else 
                                    account = 'bank'
                                end 
                                ESX.TriggerServerCallback('ps_orders:getmoney', function(money)
                                    if money >= price then
                                        done = true 
                                        busy = false
                                        TriggerServerEvent("ps_orders:removemoney", price, account)
                                        RemoveBlip(blip)
                                        startanim(abholped, 'mp_common', 'givetake1_a')
                                        startanim(PlayerPedId(), 'mp_common', 'givetake1_a')
        
                                        local text = string.format(Translation[Config.Locale]['webhook_paid_items'],price, json.encode(warenkorb))
                                        TriggerServerEvent("ps_orders:webhook", text)
        
        
                                        Citizen.Wait(2500)
                                        TriggerServerEvent("ps_orders:additems", warenkorb)
                                        ClearPedTasks(abholped)
                                        ClearPedTasks(PlayerPedId())
                                        FreezeEntityPosition(abholped, false)
        
                                        for k in pairs (warenkorb) do
                                            warenkorb [k] = nil
                                        end
                                        price = 0
                                        
                                        TaskSmartFleePed(abholped, PlayerPedId(), 200.0, -1)
                                        Citizen.Wait(15000)
                                        DeleteEntity(abholped)
                                    else 
                                        if account == 'bank' then 
                                            Config.Notify(Translation[Config.Locale]['not_enough_money_bank'])
                                        elseif account == 'money' then
                                            Config.Notify(Translation[Config.Locale]['not_enough_money_cash'])
                                        end
                                    end
                                end, account)
                            end 
                        else 
                            local account = Config.Items[category].account
                            ESX.TriggerServerCallback('ps_orders:getmoney', function(money)
                                if money >= price then
                                    busy = false 
                                    TriggerServerEvent("ps_orders:removemoney", price, account)
        
                                    local text = string.format(Translation[Config.Locale]['webhook_paid_items'],price, json.encode(warenkorb))
                                    TriggerServerEvent("ps_orders:webhook", text)
                                    RemoveBlip(blip)
                                    startanim(abholped, 'mp_common', 'givetake1_a')
                                    startanim(PlayerPedId(), 'mp_common', 'givetake1_a')
        
                                    Citizen.Wait(2500)
                                    TriggerServerEvent("ps_orders:additems", warenkorb)
                                    ClearPedTasks(abholped)
                                    ClearPedTasks(PlayerPedId())
                                    FreezeEntityPosition(abholped, false)
        
                                    for k in pairs (warenkorb) do
                                        warenkorb [k] = nil
                                    end
                                    price = 0
        
                                    TaskSmartFleePed(abholped, PlayerPedId(), 200.0, -1)
                                    Citizen.Wait(5000)
                                    DeleteEntity(abholped)
                                else 
                                    if account == 'black_money' then
                                        Config.Notify(Translation[Config.Locale]['not_enough_money_black'])
                                    elseif account == 'bank' then 
                                        Config.Notify(Translation[Config.Locale]['not_enough_money_bank'])
                                    elseif account == 'money' then
                                        Config.Notify(Translation[Config.Locale]['not_enough_money_cash'])
                                    end
                                end
                            end, account)
                        end
                    end
                end
            end
        end
    end)
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

RegisterNetEvent("ps_orders:alertpolice_c")
AddEventHandler("ps_orders:alertpolice_c", function(minutes, hint, blip, coords)
    if hint == nil then 
        Config.PoliceAlert((Config.DefaultMessage):format(minutes))
    else 
        Config.PoliceAlert((hint):format(minutes))
    end
    if blip then 
        local random1 = math.random(1, 100)
        local randomness1
        local randomness2
        if random1 > 100 then
            randomness1 = math.random(-15.0,15.0)
            randomness2 = math.random(-15.0,15.0)
        else
            randomness1 = math.random(-50.0,50.0)
            randomness2 = math.random(-50.0,50.0)
        end
        local radius = AddBlipForRadius(coords.x + randomness1, coords.y + randomness2, coords.z, 100.0)
        SetBlipHighDetail(radius, true)
        SetBlipColour(radius, 1)
        SetBlipAlpha (radius, 128)
        SetBlipAsShortRange(radius, true)
        SetBlipRoute(radius, true)
        
        Citizen.Wait(60000)
        RemoveBlip(radius)
    end
end)

function showPictureNotification(icon, msg, title, subtitle)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg);
    SetNotificationMessage(icon, icon, true, 1, title, subtitle);
    DrawNotification(false, true);
end

function startanim(entity, dictionary, animation)
    RequestAnimDict(dictionary)
    while not HasAnimDictLoaded(dictionary) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(entity, dictionary, animation, 1.0, -1, -1, 3, 0, false, false, false)
end