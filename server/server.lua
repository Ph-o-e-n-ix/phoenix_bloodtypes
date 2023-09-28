ESX = exports["es_extended"]:getSharedObject()

--Blooditems
ESX.RegisterUsableItem('blood_ap', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == Config.JobForMenu then
        TriggerClientEvent("phoenix:openmenu", source, 'blood_ap')
    else 
        TriggerClientEvent("phoenix:takeblood", source, 'blood_ap')
   	end
end)

ESX.RegisterUsableItem('blood_0p', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == Config.JobForMenu then
        TriggerClientEvent("phoenix:openmenu", source, 'blood_0p')
    else 
        TriggerClientEvent("phoenix:takeblood", source, 'blood_0p')
   	end
end)

ESX.RegisterUsableItem('blood_bp', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == Config.JobForMenu then
        TriggerClientEvent("phoenix:openmenu", source, 'blood_bp')
    else 
        TriggerClientEvent("phoenix:takeblood", source, 'blood_bp')
   	end
end)

ESX.RegisterUsableItem('blood_an', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == Config.JobForMenu then
        TriggerClientEvent("phoenix:openmenu", source, 'blood_an')
    else 
        TriggerClientEvent("phoenix:takeblood", source, 'blood_an')
   	end
end)

ESX.RegisterUsableItem('blood_0n', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == Config.JobForMenu then
        TriggerClientEvent("phoenix:openmenu", source, 'blood_0n')
    else 
        TriggerClientEvent("phoenix:takeblood", source, 'blood_0n')
   	end
end)

ESX.RegisterUsableItem('blood_abp', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == Config.JobForMenu then
        TriggerClientEvent("phoenix:openmenu", source, 'blood_abp')
    else 
        TriggerClientEvent("phoenix:takeblood", source, 'blood_abp')
   	end
end)

ESX.RegisterUsableItem('blood_bn', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == Config.JobForMenu then
        TriggerClientEvent("phoenix:openmenu", source, 'blood_bn')
    else 
        TriggerClientEvent("phoenix:takeblood", source, 'blood_bn')
   	end
end)

ESX.RegisterUsableItem('blood_abn', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == Config.JobForMenu then
        TriggerClientEvent("phoenix:openmenu", source, 'blood_abn')
    else 
        TriggerClientEvent("phoenix:takeblood", source, 'blood_abn')
   	end
end)


--MedicItems
ESX.RegisterUsableItem('blood_test', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
	local players = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
		    players = players + 1
        end
   	end
    if players > 1 then
        TriggerClientEvent("phoenix:bloodtestitem", source)
    else 
        TriggerClientEvent("phoenix:notifyclient", source, "no_player_nearby")
    end
end)

ESX.RegisterUsableItem('blood_empty', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    local players = 0
    if xPlayer.job.name == Config.JobForMenu then
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer then
                players = players + 1
            end
        end
        if players > 1 then
            local xPlayer = ESX.GetPlayerFromId(source)
            if Config.NeededItem == nil then
                TriggerClientEvent("phoenix:takebloodmedic", source)
            else
                local item = xPlayer.getInventoryItem('syringe').count
                if item > 0 then
                    TriggerClientEvent("phoenix:takebloodmedic", source)
                else 
                    TriggerClientEvent("phoenix:notifyclient", source, "do_not_have_syringe")
                end 
            end
        else 
            TriggerClientEvent("phoenix:notifyclient", source, "no_player_nearby")
        end
    end
end)


RegisterServerEvent("phoenix:setblood_target")
AddEventHandler("phoenix:setblood_target", function(targetid)
   local xPlayertarget = ESX.GetPlayerFromId(targetid)
   TriggerClientEvent("phoenix:setblood_target_c", targetid)
end)

RegisterServerEvent("phoenix:removeblooditem")
AddEventHandler("phoenix:removeblooditem", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemname, 1)
end)

RegisterServerEvent("phoenix:addblooditem")
AddEventHandler("phoenix:addblooditem", function(itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(itemname, 1)
end)


ESX.RegisterServerCallback('phoenix:bloodtype', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    MySQL.Async.fetchAll('SELECT bloodtype FROM phoenix_bloodtypes WHERE identifier = @identifier',{
        ['@identifier'] = identifier,
    },function(result)
        if  result then
            local bloodtype = result.bloodtype
            cb(result)
        end
    end)
end)

ESX.RegisterServerCallback('phoenix:isclosestthere', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    local players = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
		    players = players + 1
        end
   	end
    if players > 1 then
        cb(true)
    else 
        cb(false)
    end
end)

ESX.RegisterServerCallback('phoenix:bloodtypetarget', function(source, cb, targetid)
    local xPlayertarget = ESX.GetPlayerFromId(targetid)
    MySQL.Async.fetchAll('SELECT bloodtype FROM phoenix_bloodtypes WHERE identifier = @targetidentifier',{
        ['@targetidentifier'] = xPlayertarget.identifier,
    },function(result2)
        if  result2 then
            cb(result2)
        end
    end)
end)

RegisterServerEvent("phoenix:bloodtestitem_s")
AddEventHandler("phoenix:bloodtestitem_s", function(targetid)
    TriggerClientEvent("phoenix:bloodtestitem_c", targetid)
end)

RegisterServerEvent("phoenix:takebloodmedic_s")
AddEventHandler("phoenix:takebloodmedic_s", function(targetid)
    TriggerClientEvent("phoenix:takebloodmedic_c", targetid)
end)

RegisterServerEvent("phoenix:deletebloodtype")
AddEventHandler("phoenix:deletebloodtype", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier(source)
    MySQL.single('SELECT identifier, name, bloodtype FROM phoenix_bloodtypes WHERE identifier = ?', 
    { identifier }, function(result2)
        if result2 then
            MySQL.query.await('DELETE FROM phoenix_bloodtypes WHERE identifier = @identifier',{
                ['@identifier'] = xPlayer.identifier,
            }, function()
            end)
            TriggerClientEvent("phoenix:notifyclient", xPlayer.source, "you_deleted_your_bloodtype")
        else 
            TriggerClientEvent("phoenix:notifyclient", xPlayer.source, "no_bloodtype_in_sql")
        end 
    end)
end)

RegisterServerEvent("phoenix:setbloodtype")
AddEventHandler("phoenix:setbloodtype", function(blood)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier(source)
    MySQL.single('SELECT identifier, name, bloodtype FROM phoenix_bloodtypes WHERE identifier = ?', 
    { identifier }, function(result)
        if not result then
            local random = math.random(0,100)
            local bloodtype = ''
            local name = xPlayer.getName(source)
            local identifier = xPlayer.getIdentifier(source)
            if blood == nil then
                -- This Stats are based on real Stats of the Population
                if (random < 100 and random >= 63) then -- 37 Percent probability
                    bloodtype = 'A+'
                elseif  (random < 63 and random >= 28) then -- 35 Percent
                    bloodtype = '0+'
                elseif  (random < 28 and random >= 19) then -- 9 Percent
                    bloodtype = 'B+'
                elseif  (random < 19 and random >= 13) then -- 6 Percent
                    bloodtype = 'A-'
                elseif  (random < 13 and random >= 7) then -- 6 Percent
                    bloodtype = '0-' --Golden Bloodtype
                elseif  (random < 7 and random >= 3) then -- 4 Percent
                    bloodtype = 'AB+'
                elseif  (random < 3 and random >= 1) then -- 2 Percent
                    bloodtype = 'B-'
                elseif random == 0 then 
                    bloodtype = 'AB-'
                end
            else 
                if blood == 'A+' or blood == '0+' or blood == 'B+'  or blood == 'A-' or blood == '0-' or blood == 'AB+' or blood == 'B-' or blood == 'AB-' then
                    bloodtype = blood 
                else 
                    print("Bloodtype does not exist")
                    return 
                end
            end
            
            MySQL.Async.execute("INSERT INTO phoenix_bloodtypes (identifier, name, bloodtype) VALUES (@identifier,@name,@bloodtype)", {
            ['@identifier'] = identifier, 
            ['@name'] = name, 
            ['@bloodtype'] = bloodtype
            })
            print("Done")
        else
            if Config.Debug then
                print("You already have a Bloodtype")
            end
        end
    end)
end)

RegisterServerEvent("phoenix:sendclosest_s")
AddEventHandler("phoenix:sendclosest_s", function(targetplayer, blooditem)
   local xPlayer = ESX.GetPlayerFromId(targetplayer)
   local blooditem2 = blooditem
   TriggerClientEvent("phoenix:sendclosest_c", targetplayer, blooditem2)
end)

RegisterServerEvent("phoenix:pay_fee")
AddEventHandler("phoenix:pay_fee", function(test)
    local xPlayer = ESX.GetPlayerFromId(source)
    if test then
        xPlayer.removeAccountMoney('bank', 500)
    else
        xPlayer.removeAccountMoney('bank', 50)
    end
end)
