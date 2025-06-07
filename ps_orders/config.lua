Config  = {}

Config.Debug = false -- Debug (Waittime will be 5 Seconds, for devtest)

Config.Webhook = '' -- Youre Webhook Link

Config.Locale = 'en' -- 'de' 'en'

Config.DistToSpawnPed = 150 -- Spawn Ped when you go to get the Items

Config.ColorScheme = '#d79051' -- in Menu

Config.Time = { -- What the Player can choose to wait for the Order (between min and max minutes)
    min = 5, 
    max = 120
}

Config.Start = {
    {
        ped = 'g_m_y_ballaeast_01', -- https://wiki.rage.mp/index.php?title=Peds
        coords = vector4(412.5513, 314.2726, 103.0209, 206.0059), -- Where the Ped is standing to order from
        category = {'Food'}, -- You can decide, what type of Items you can by that are defined in Config.Items
        prefix = '~g~', -- PrefixColor for the 3D text (~g~ is green, ~r~ is red, ...) 
        blip = { -- https://wiki.rage.mp/index.php?title=Blips
            enable = true, -- Blip on Map
            blipid = 52,
            blipcolor = 5, 
            blipscale = 0.8,
            blipname = 'Legal Shop'
        },
    },
    {
        ped = 'g_m_y_ballaeast_01',
        coords = vector4(310.4442, 354.5016, 105.3212, 262.4408),
        category = {'Drugs', 'Weapons'},
        prefix = '~r~',
        blip = {
            enable = false,
            blipid = 52,
            blipcolor = 1, 
            blipscale = 0.5,
            blipname = 'Illegal Shop'
        },
    },
}

Config.PoliceJobs = {
    'police',
    'sheriff',
}

Config.PoliceAlert = function(text) -- Thats the Notify for the Cops
    ESX.ShowNotification(text)
end

Config.DefaultMessage = 'Informant: A deal will take place in %s minutes. I cant say exactly where' -- Thats the Default Message for the Cops if hint = nil


Config.Notify = function(text) -- Thats the Default Notify for the Player
    ESX.ShowNotification(text)
end

Config.Items = { -- You can create as much Types with Items as you want.
    ['Drugs'] = { -- You can name the Category however you like, but it needs to match then with the category defined in the Config.Start section
        account = 'money', -- 'bank' , 'money', 'black_money' | if nil, he will ask you , what you want to pay with
        items = { -- You can ass as many Items as you want with their custom Prices
            {itemname = 'joint', label = 'Joint', maxamount = 40, price = 400},
            {itemname = 'mushroom', label = 'Magic Mushrooms', maxamount = 70, price = 90},
            {itemname = 'heroin', label = 'Heroin', maxamount = 13, price = 750},
            {itemname = 'meth', label = 'Meth', maxamount = 12, price = 750},
        },
        randomspots = { -- The Randomspots. One will be picket randomly if the Order has come ready
            {ped = 'g_m_y_ballaeast_01', coords = vector4(269.2207, -1728.5336, 29.6456, 318.3220), hint = nil }, -- hint = nil instead using -> Config.DefaultMessage
            {ped = 'g_m_y_ballaeast_01', coords = vector4(398.4790, 316.8883, 103.0208, 164.4525), hint = "In North of the City will be a Deal in about %s Minutes"}, -- %s are the Minutes
            {ped = 'g_m_y_ballaeast_01', coords = vector4(225.1348, -2036.4785, 18.3766, 49.9179), hint = nil}, -- (you can also describe location depend on coords you place) 
            {ped = 'g_m_y_ballaeast_01', coords = vector4(748.7099, -529.1163, 27.7778, 69.3600), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(1583.2987, 3597.2612, 35.4174, 120.8862), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(2380.2859, 3348.5652, 47.9523, 41.3470), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(379.8652, 2629.2974, 44.6724, 27.1830), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(180.0314, 2793.2776, 45.6551, 288.4757), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(-1142.4631, -1144.3086, 2.8445, 115.9836), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(-1179.4077, -929.3506, 6.9699, 113.4022), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(-1772.0704, -378.6576, 46.4795, 2.7380), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(-596.5286, 209.6689, 74.1727, 184.1932), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(191.5726, 39.8605, 84.2174, 154.2222), hint = nil},
        },
        alertpolice = { 
            enable = true, -- If Cop Notify is enables or not
            chance = 15, -- Chance 1-100 (100 is 100% Chance to Notify the Cops)
            blip = true -- Should the Cops also get a Blip close to the Spot or only the Message
        },
    }, 

    ['Weapons'] = {
        account = 'black_money',
        items = {
            {itemname = 'weapon_assaultrifle', label = 'AK47', maxamount = 1, price = 250000},
            {itemname = 'weapon_compactrifle', label = 'Compactrifle', maxamount = 1, price = 200000},
            {itemname = 'weapon_bullpuprifle', label = 'Bullpup', maxamount = 1, price = 250000},
            {itemname = 'weapon_pistol50', label = 'Pistol 50.', maxamount = 1, price = 60000},
            {itemname = 'weapon_pistol', label = 'Pistol', maxamount = 1, price = 25000},
            {itemname = 'armor', label = 'Armor', maxamount = 5, price = 20000},
            {itemname = 'rifle_ammo', label = 'Rifle Ammo', maxamount = 15, price = 800},
            {itemname = 'pistol_ammo', label = 'Pistol Ammo', maxamount = 20, price = 500},
        },
        randomspots = {
            {ped = 'g_m_y_ballaeast_01', coords = vector4(269.2207, -1728.5336, 29.6456, 318.3220), hint = nil },
            {ped = 'g_m_y_ballaeast_01', coords = vector4(65.1345, -80.4352, 62.9022, 61.8201), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(225.1348, -2036.4785, 18.3766, 49.9179), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(748.7099, -529.1163, 27.7778, 69.3600), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(1583.2987, 3597.2612, 35.4174, 120.8862), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(2380.2859, 3348.5652, 47.9523, 41.3470), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(379.8652, 2629.2974, 44.6724, 27.1830), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(180.0314, 2793.2776, 45.6551, 288.4757), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(-1142.4631, -1144.3086, 2.8445, 115.9836), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(-1179.4077, -929.3506, 6.9699, 113.4022), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(-1772.0704, -378.6576, 46.4795, 2.7380), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(-596.5286, 209.6689, 74.1727, 184.1932), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(191.5726, 39.8605, 84.2174, 154.2222), hint = nil},
        },
        alertpolice = { 
            enable = true,
            chance = 15,
            blip = true
        },
    }, 

    ['Food'] = { -- As Example this is an legal Business , so it makes sense to disable all alert options to the police
        account = nil,
        items = {
            {itemname = 'water', label = 'Food 1', maxamount = 3, price = 100},
            {itemname = 'water', label = 'Food 2', maxamount = 3, price = 100},
            {itemname = 'water', label = 'Food 3', maxamount = 3, price = 100},
            {itemname = 'water', label = 'Food 4', maxamount = 3, price = 100},
            {itemname = 'water', label = 'Food 5', maxamount = 3, price = 100},
            {itemname = 'water', label = 'Food 6', maxamount = 3, price = 100},
        },
        randomspots = {
            {ped = 'g_m_y_ballaeast_01', coords = vector4(398.4790, 316.8883, 103.0208, 164.4525), hint = nil },
            {ped = 'g_m_y_ballaeast_01', coords = vector4(398.4790, 316.8883, 103.0208, 164.4525), hint = nil},
            {ped = 'g_m_y_ballaeast_01', coords = vector4(398.4790, 316.8883, 103.0208, 164.4525), hint = nil},
        },
        alertpolice = { 
            enable = false,
            chance = 0,
            blip = false
        },
    },
}

Translation = {
    ['de'] = {
        ['order_already_running'] = 'Aktuell läuft bereits eine Bestellung',
        ['menu_category_title'] = 'Kategorie',
        ['menu_category_desc'] = 'Wähle eine Kategorie',
        ['menu_order_title'] = 'Bestellung',
        ['menu_cart_title'] = 'Warenkorb',
        ['menu_cart_desc'] = 'Warenkorb anzeigen',
        ['menu_put_cart'] = '%s$ | in den Warenkorb',
        ['menu_max_amount'] = 'Max: %sx',
        ['dialog_amount'] = 'Anzahl',
        ['dialog_amount_desc'] = 'Menge angeben',
        ['item_added_cart'] = '%sx %s erfolgreich hinzugefügt',
        ['max_order_limit'] = 'Du kannst max. %sx %s bestellen',
        ['menu_order_finish_title'] = 'Bestellen',
        ['menu_order_finish_desc'] = 'Bestellung aufgeben',
        ['dialog_confirm_title'] = 'Bestätigen',
        ['dialog_confirm_desc'] = 'Bestätige deine Bestellung in Höhe von %s$',
        ['dialog_time_title'] = 'Zeit',
        ['dialog_time_desc'] = 'Wann soll die Bestellung abholbereit sein?',
        ['dialog_time_desc2'] = 'In Minuten | Min: %s Minuten | Max: %s Minuten',
        ['canceled_order'] = 'Bestellen abgebrochen',
        ['menu_remove_item_desc'] = 'Entferne das Item aus deinem Warenkorb',
        ['webhook_started_order'] = 'hat eine Bestellung aufgegeben und muss %s$ bezahlen.\nWartezeit: %s Minuten\nItems:\n%s',
        ['pic_notify_char'] = 'CHAR_DEFAULT', -- Picture Notification Image
        ['pic_notify_desc'] = 'Deine Bestellung wird in ~g~%s Minute/n~s~ verfügbar sein. Du wirst benachrichtigt.',
        ['pic_notify_desc2'] = 'Bestellung aufgegeben',
        ['pic_notify_pay_card'] = '~g~Bezahlung per Karte~s~',
        ['pic_notify_pay_cash'] = '~g~Bezahlung mit Bargeld~s~',
        ['pic_notify_pay_black'] = '~r~Bezahlung mit Schwarzgeld~s~',
        ['pic_notify_order_ready_desc'] = 'Deine Bestellung steht ~g~bereit~s~. ~o~GPS Koordinaten~s~ wurden übermittelt',
        ['pic_notify_order_ready_desc2'] = 'Bestellung abholbereit',
        ['blip_pickup_coords'] = 'Abholkoordinaten',
        ['3dtext_pickup_items'] = 'Ware abholen',
        ['pickup_price'] = 'Kosten: %s$',
        ['payment_method_title'] = 'Zahlungsart',
        ['payment_method_desc'] = 'Welche Zahlungsart willst du anwenden?',
        ['dialog_payment_cash'] = 'Barzahlung',
        ['dialog_payment_card'] = 'Karte',
        ['dialog_choose_option'] = 'Wähle eine Option',
        ['webhook_paid_items'] = 'hat die Bestellung abgeholt und hat %s$ bezahlt.\n\n**Items**:\n%s',
        ['not_enough_money_cash'] = 'Du hast nicht genug Bargeld',
        ['not_enough_money_bank'] = 'Du hast nicht genug Geld auf der Bank',
        ['not_enough_money_black'] = 'Du hast nicht genug Schwarzgeld',
    },
    ['en'] = {
        ['order_already_running'] = 'An order is already in progress',
        ['menu_category_title'] = 'Category',
        ['menu_category_desc'] = 'Select a category',
        ['menu_order_title'] = 'Order',
        ['menu_cart_title'] = 'Cart',
        ['menu_cart_desc'] = 'View cart',
        ['menu_put_cart'] = '%s$ | Add to cart',
        ['menu_max_amount'] = 'Max: %sx',
        ['dialog_amount'] = 'Quantity',
        ['dialog_amount_desc'] = 'Enter quantity',
        ['item_added_cart'] = '%sx %s successfully added',
        ['max_order_limit'] = 'You can order a maximum of %sx %s',
        ['menu_order_finish_title'] = 'Place Order',
        ['menu_order_finish_desc'] = 'Submit your order',
        ['dialog_confirm_title'] = 'Confirm',
        ['dialog_confirm_desc'] = 'Confirm your order for %s$',
        ['dialog_time_title'] = 'Time',
        ['dialog_time_desc'] = 'When should the order be ready for pickup?',
        ['dialog_time_desc2'] = 'In minutes | Min: %s minutes | Max: %s minutes',
        ['canceled_order'] = 'Order canceled',
        ['menu_remove_item_desc'] = 'Remove the item from your cart',
        ['webhook_started_order'] = 'placed an order and needs to pay %s$.\nWaiting time: %s minutes\nItems:\n%s',
        ['pic_notify_char'] = 'CHAR_DEFAULT', -- Picture Notification Image
        ['pic_notify_title'] = 'Your order will be ready in ~g~%s minute(s)~s~. You will be notified.',
        ['pic_notify_desc'] = 'Your order will be ready in ~g~%s minute(s)~s~. You will be notified.',
        ['pic_notify_desc2'] = 'Order placed',
        ['pic_notify_pay_card'] = '~g~Paid by card~s~',
        ['pic_notify_pay_cash'] = '~g~Paid in cash~s~',
        ['pic_notify_pay_black'] = '~r~Paid with dirty money~s~',
        ['pic_notify_order_ready_desc'] = 'Your order is ~g~ready~s~. ~o~GPS coordinates~s~ have been sent.',
        ['pic_notify_order_ready_desc2'] = 'Order ready for pickup',
        ['blip_pickup_coords'] = 'Pickup Coordinates',
        ['3dtext_pickup_items'] = 'Pick up items',
        ['pickup_price'] = 'Cost: %s$',
        ['payment_method_title'] = 'Payment Method',
        ['payment_method_desc'] = 'Which payment method do you want to use?',
        ['dialog_payment_cash'] = 'Cash',
        ['dialog_payment_card'] = 'Card',
        ['dialog_choose_option'] = 'Choose an option',
        ['webhook_paid_items'] = 'picked up the order and paid %s$.\n\n**Items**:\n%s',
        ['not_enough_money_cash'] = 'You dont have enough cash',
        ['not_enough_money_bank'] = 'You dont have enough money in your Bankaccount',
        ['not_enough_money_black'] = 'You dont have enough dirty money',
    }    
}