ESX = exports["es_extended"]:getSharedObject()
local disablesprint = false
local enableragdoll = false
local busy = false
local istargetplayer = false
local test = false
local inbloodtest = false

AddEventHandler('onClientResourceStart', function(ressourceName)
    if(GetCurrentResourceName() ~= ressourceName) then 
        return 
    end 
    print("" ..ressourceName.." started sucessfully")
end)

if Config.Debug then 
    RegisterCommand("deletebloodtype", function()
        TriggerServerEvent("phoenix:deletebloodtype")
    end)
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.Station) do
        local blip = AddBlipForCoord(v.sitcoords)
        SetBlipSprite(blip, 366)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Translation[Config.Locale]["blipname"])
        EndTextCommandSetBlipName(blip)
    end
end)

if Config.StationToggle then
    Citizen.CreateThread(function()
        for _, h in pairs(Config.Station) do
            local pedhash = GetHashKey(h.pedname)
            RequestModel(pedhash)
            while not HasModelLoaded(pedhash) do 
                Citizen.Wait(25)
            end
            local stationPed = CreatePed(4, pedhash, h.coords.x, h.coords.y, h.coords.z - 1.0, h.coords.w, false, false)
            FreezeEntityPosition(stationPed, true)
            SetEntityInvincible(stationPed, true)
            SetEntityAsMissionEntity(stationPed, true, true)
            SetBlockingOfNonTemporaryEvents(stationPed, true)
        end
    end)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local playerPed = PlayerPedId()
            local playercoords = GetEntityCoords(playerPed)
            for k, v in pairs(Config.Station) do 
                local distance = Vdist(playercoords.x, playercoords.y, playercoords.z, v.coords.x, v.coords.y, v.coords.z)
                if distance < 3 then
                    DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.25, Translation[Config.Locale]["press_e"])
                    DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.10, Translation[Config.Locale]["press_g"])  
                    if distance < 2 then
                        if IsControlJustReleased(0, 38) then 
                            local bloodtype = exports["phoenix_bloodtypes"]:callbloodtype()
                            if bloodtype == nil then 
                                Config.MSG(Translation[Config.Locale]["bloodgroup_not_avaiable"])
                            else 
                                Config.MSG(Translation[Config.Locale]["bloodgroup"]..' '..bloodtype)
                            end
                            if Config.PayFee then
                                test = false
                                TriggerServerEvent("phoenix:pay_fee", test)
                            end
                        end
                        if IsControlJustReleased(0, 47) then 
                            local blood = exports["phoenix_bloodtypes"]:callbloodtype()
                            if blood == nil then 
                                test = true
                                TriggerServerEvent("phoenix:pay_fee", test)
                                startbloodtest()
                            else 
                                Config.MSG(Translation[Config.Locale]["already_have_bloodtype"])
                            end
                        end
                    end
                end    
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        if disablesprint then
            DisableControlAction(0, 21)
            DisableControlAction(0, 24)
            DisableControlAction(0, 22)
        end 
        if enableragdoll then 
            SetPedToRagdoll(ped, 1000, 1000, 0, false, false, false)
            Wait(0)
        end
    end
end)

RegisterNetEvent("phoenix:takeblood")
AddEventHandler("phoenix:takeblood", function(blooditem, istargetplayer)
    if not busy then
        busy = true
        local bloodtype = exports["phoenix_bloodtypes"]:callbloodtype()
        if blooditem    == 'blood_ap' then
            if bloodtype == 'AB+' or bloodtype == 'A+' then 
                startbloodreserve('blood_ap', istargetplayer)
            else 
                wrongblood('blood_ap', istargetplayer)
            end
        elseif blooditem == 'blood_0n' then
                startbloodreserve('blood_0n', istargetplayer)
        elseif blooditem == 'blood_bp' then
            if bloodtype == 'B+' or bloodtype == 'AB+' then
                startbloodreserve('blood_bp', istargetplayer)
            else 
                wrongblood('blood_bp', istargetplayer)
            end
        elseif blooditem == 'blood_an' then
            if bloodtype == 'A-' or bloodtype == 'A+' or bloodtype == 'AB+' or bloodtype == 'AB-' then
                startbloodreserve('blood_an', istargetplayer)
            else 
                wrongblood('blood_an', istargetplayer)
            end
        elseif blooditem == 'blood_0p' then
            if bloodtype == '0+' or bloodtype == 'B+' or bloodtype == 'A+' or bloodtype == 'AB+' then
                startbloodreserve('blood_0p', istargetplayer)
            else 
                wrongblood('blood_0p', istargetplayer)
            end 
        elseif blooditem == 'blood_abp' then
            if bloodtype == 'AB+'  then 
                startbloodreserve('blood_abp', istargetplayer)
            else 
                wrongblood('blood_abp', istargetplayer)
            end
        elseif blooditem == 'blood_bn' then
            if bloodtype == 'B+' or bloodtype == 'B-' or bloodtype == 'AB-' or bloodtype == 'AB+' then 
                startbloodreserve('blood_bn', istargetplayer)
            else 
                wrongblood('blood_bn', istargetplayer)
            end
        elseif blooditem == 'blood_abn' then
            if bloodtype == 'AB-' or bloodtype == 'AB+' then 
                startbloodreserve('blood_abn', istargetplayer)
            else 
                wrongblood('blood_abn', istargetplayer)
            end
        end
    else 
        Config.MSG(Translation[Config.Locale]["already_busy"])
    end
end)

RegisterNetEvent("phoenix:bloodtestitem")
AddEventHandler("phoenix:bloodtestitem", function()
    local targetplayer, distance = ESX.Game.GetClosestPlayer()
    local targetid = GetPlayerServerId(targetplayer)
    if distance < 3 then 
        if not inbloodtest then
            inbloodtest = true
            local bloodtypetarget = exports["phoenix_bloodtypes"]:callbloodtypetarget(targetplayer)
            if bloodtypetarget == nil then
                TriggerServerEvent("phoenix:setbloodtype", targetid)
                TriggerServerEvent("phoenix:bloodtestitem_s", targetid)
                TriggerServerEvent("phoenix:removeblooditem", 'blood_test')
                Config.ProgressBar(Translation[Config.Locale]["blood_will_be_taken"], 5000)
                Citizen.Wait(2000)
                local bloodtypetarget2 = exports["phoenix_bloodtypes"]:callbloodtypetarget(targetplayer)
                Config.MSG(Translation[Config.Locale]["bloodtype_target"]..' '..bloodtypetarget2)
                inbloodtest = false
            else
                TriggerServerEvent("phoenix:removeblooditem", 'blood_test')
                TriggerServerEvent("phoenix:bloodtestitem_s", targetid)
                Config.ProgressBar(Translation[Config.Locale]["blood_will_be_taken"], 5000)
                Config.MSG(Translation[Config.Locale]["bloodtype_target"]..' '..bloodtypetarget)
                inbloodtest = false
            end
        end
    else 
        Config.MSG(Translation[Config.Locale]["no_player_nearby"])
    end
end)

RegisterNetEvent("phoenix:bloodtestitem_c")
AddEventHandler("phoenix:bloodtestitem_c", function(targetid)
    local playerped = PlayerPedId()
    Config.ProgressBar(Translation[Config.Locale]["blood_will_be_taken"], 5000)
end)

RegisterNetEvent("phoenix:takebloodmedic_c")
AddEventHandler("phoenix:takebloodmedic_c", function(targetid)
    local playerped = PlayerPedId()
    inbloodtest = true
    Config.ProgressBar(Translation[Config.Locale]["blood_will_be_taken"], 15000)
    inbloodtest = false
end)

RegisterNetEvent("phoenix:setblood_target_c")
AddEventHandler("phoenix:setblood_target_c", function(targetid)
   local playerped = PlayerPedId()
   exports["phoenix_bloodtypes"]:setbloodtype()
end)

RegisterNetEvent("phoenix:takebloodmedic")
AddEventHandler("phoenix:takebloodmedic", function()
    local targetplayer, distance = ESX.Game.GetClosestPlayer()
    local targetid = GetPlayerServerId(targetplayer)
    if distance < 3 then 
        local bloodtypetarget = exports["phoenix_bloodtypes"]:callbloodtypetarget(targetplayer)
        if bloodtypetarget == nil then
            Config.MSG(Translation[Config.Locale]["has_to_test_blood"])
        else  
            local playerid = GetPlayerServerId(PlayerId())
            TriggerServerEvent("phoenix_bloodtypes:sendwebhook", targetid, playerid, bloodtypetarget, 'took')
            TriggerServerEvent("phoenix:takebloodmedic_s", targetid)
            TriggerServerEvent("phoenix:removeblooditem", 'blood_empty')
            if Config.NeededItem == nil then
            else 
                TriggerServerEvent("phoenix:removeblooditem", Config.NeededItem)
            end
            Config.ProgressBar(Translation[Config.Locale]["blood_will_be_taken"], 30000)
            local blooditem = ''
            if bloodtypetarget == 'A+' then 
                blooditem = 'blood_ap'
            elseif bloodtypetarget == '0+' then
                blooditem = 'blood_0p'
            elseif bloodtypetarget == 'B+' then
                blooditem = 'blood_bp'
            elseif bloodtypetarget == 'A-' then
                blooditem = 'blood_an'
            elseif bloodtypetarget == '0-' then
                blooditem = 'blood_0n'
            elseif bloodtypetarget == 'AB+' then
                blooditem = 'blood_abp'
            elseif bloodtypetarget == 'B-' then
                blooditem = 'blood_bn'   
            elseif bloodtypetarget == 'AB-' then
                blooditem = 'blood_abn'
            end 
            Citizen.Wait(150)
            if blooditem == nil then 
                Config.MSG(Translation[Config.Locale]["item_got_nil"])
            else 
                TriggerServerEvent("phoenix:addblooditem", blooditem)
                Config.MSG(Translation[Config.Locale]["you_took_blood"]..' '..bloodtypetarget)
            end
        end
    else 
        Config.MSG(Translation[Config.Locale]["no_player_nearby"])
    end
end)

RegisterNetEvent("phoenix:openmenu")
AddEventHandler("phoenix:openmenu", function(blooditem)
    local playerPed = PlayerPedId()
	local elemente = {
		{label = Translation[Config.Locale]["give_player"], value = 'player'},
		{label = Translation[Config.Locale]["give_self"], value = 'self'},
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
        title = Translation[Config.Locale]["Blood_menu_title"],
        align = 'top-left',
        elements = elemente
    }, function(data, menu)
        menu.close()
        inmenu = false
        if data.current.value == 'player' then 
            local target, distance = ESX.Game.GetClosestPlayer()
            ESX.TriggerServerCallback('phoenix:isclosestthere', function(enough)
                if enough then
                    if distance < 2 then 
                        local targetplayer = GetPlayerServerId(target)
                        local playerid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent("phoenix:sendclosest_s", targetplayer, blooditem)
                        TriggerServerEvent("phoenix:removeblooditem", blooditem)
                        TriggerServerEvent("phoenix_bloodtypes:sendwebhook", targetplayer, playerid, blooditem, 'gave')
                        Config.MSG(Translation[Config.Locale]["giving_blood_transfusion"])
                        Config.ProgressBar(Translation[Config.Locale]["blood_transfusion_started"], 30000)
                    else 
                        Config.MSG(Translation[Config.Locale]["no_player_nearby"])
                    end
                else 
                    Config.MSG(Translation[Config.Locale]["no_player_nearby"])
                end 
            end)
        end 
        if data.current.value == 'self' then
            TriggerEvent("phoenix:takeblood", blooditem)
        end 
    end, 
    function(data, menu)
        menu.close()
        inmenu = false
    end)
end)

RegisterNetEvent("phoenix:sendclosest_c") -- Target Player Event
AddEventHandler("phoenix:sendclosest_c", function(blooditem)
    local playerped = PlayerPedId()
    TriggerEvent("phoenix:takeblood", blooditem, true)
    Config.MSG(Translation[Config.Locale]["you_get_Blood_transfusion"])
end)

RegisterNetEvent("phoenix:notifyclient")
AddEventHandler("phoenix:notifyclient", function(translatetext)
    Config.MSG(Translation[Config.Locale][translatetext])
end)

function startbloodtest()
    for k, v in pairs(Config.Station) do
        SetEntityCoords(PlayerPedId(), v.sitcoords.x, v.sitcoords.y, v.sitcoords.z)
        SetEntityHeading(PlayerPedId(), v.sitcoords.w)
    end
    RequestAnimDict("timetable@ron@ig_3_couch")
    while not HasAnimDictLoaded("timetable@ron@ig_3_couch") do 
        Citizen.Wait(25)
    end
    TaskPlayAnim(PlayerPedId(), "timetable@ron@ig_3_couch", "base", 8.0, -8.0, -1, 1, 0, 0, 0, 0)
    
    Config.ProgressBar(Translation[Config.Locale]["blood_will_be_taken"], 60000)
    local health = GetEntityHealth(PlayerPedId())
    SetEntityHealth(PlayerPedId(), (health - 5))
    Config.MSG(Translation[Config.Locale]["blood_took_successfull"])
    ClearPedTasks(PlayerPedId())
    Citizen.Wait(5000)
    DoScreenFadeOut(1000)
    Citizen.Wait(500)
    SetTimecycleModifier("Drug_deadman")
    DoScreenFadeIn(1000)
    Citizen.Wait(1000)
    Config.MSG(Translation[Config.Locale]["your_dizzy"])
    Citizen.Wait(60000)
    ClearTimecycleModifier()
    TriggerServerEvent("phoenix:setbloodtype")
    Config.MSG(Translation[Config.Locale]["received_blootype"])
    Citizen.Wait(5000)
    Config.MSG(Translation[Config.Locale]["go_to_doc"])
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

function startbloodreserve(itemname, istargetplayer)
    local playerped = PlayerPedId()
    local health = GetEntityHealth(playerped)
    TriggerServerEvent("phoenix:removeblooditem", itemname)
    if not istargetplayer then
        usesyringe()
    end
    Config.ProgressBar(Translation[Config.Locale]["blood_transfusion_started"], 30000)
    DeleteObject(syringeObj)
    Config.MSG(Translation[Config.Locale]["blood_transfusion_success"])
    ClearPedTasks(PlayerPedId())
    SetEntityHealth(playerped, 200)
    Config.AfterBloodtransfusion()
    busy = false
    Config.MSG(Translation[Config.Locale]["feeling_better"])
end

function wrongblood(itemname, istargetplayer)
    if Config.WrongBlood then 
        TriggerServerEvent("phoenix:removeblooditem", itemname)
        if not istargetplayer then
            usesyringe()
        end
        Config.ProgressBar(Translation[Config.Locale]["blood_transfusion_started"], 30000)
        DeleteObject(syringeObj)
        ClearPedTasks(PlayerPedId())
        Config.MSG(Translation[Config.Locale]["blood_transfusion_success"])

        RequestAnimSet("move_m@drunk@slightlydrunk")
      
        while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
            Wait(0)
        end
        Citizen.Wait(15000)

        SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
        DoScreenFadeOut(1000)
        Citizen.Wait(500)
        SetTimecycleModifier("Drug_deadman")
        DoScreenFadeIn(1000)
        ApplyDamageToPed(PlayerPedId(), 5, false)
        Citizen.Wait(5000)
        Config.MSG(Translation[Config.Locale]["youre_not_good"])
        Citizen.Wait(25000)
        Config.MSG(Translation[Config.Locale]["youre_getting_weaker"])
        ApplyDamageToPed(PlayerPedId(), 5, false)
        Citizen.Wait(15000)
        Config.MSG(Translation[Config.Locale]["cant_walk"])
        disablesprint = true

        RequestAnimSet("move_m@drunk@verydrunk")
        while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
            Wait(0)
        end
        SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", true)
        ApplyDamageToPed(PlayerPedId(), 5, false)
        Citizen.Wait(20000)
        enableragdoll = true
        Citizen.Wait(15000)
        Config.MSG(Translation[Config.Locale]["you_died"])
        SetEntityHealth(PlayerPedId(), 0)
        ResetPedMovementClipset(PlayerPedId(), 0)
        disablesprint = false
        enableragdoll = false
        busy = false
    else 
        Config.MSG(Translation[Config.Locale]["blood_not_compatible"])
        busy = false
    end
end

function usesyringe()
    FreezeEntityPosition(PlayerPedId())
    local syringeProp = `prop_syringe_01`
    local syringeDict = "rcmpaparazzo1ig_4"
    local syringeAnim = "miranda_shooting_up"
    local syringeBone = 28422
    local syringeOffset = vector3(0, 0, 0)
    local syringeRot = vector3(0, 0, 0)
    RequestAnimDict(syringeDict)

    while not HasAnimDictLoaded(syringeDict) do
        Citizen.Wait(150)
    end

    RequestModel(syringeProp)

    while not HasModelLoaded(syringeProp) do
        Citizen.Wait(150)
    end

    local playerPed = PlayerPedId()
    syringeObj = CreateObject(syringeProp, 0.0, 0.0, 0.0, true, true, false)
    local syringeBoneIndex = GetPedBoneIndex(playerPed, syringeBone)

    SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
    AttachEntityToEntity(syringeObj, playerPed, syringeBoneIndex, syringeOffset.x, syringeOffset.y, syringeOffset.z, syringeRot.x, syringeRot.y, syringeRot.z, false, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(syringeProp)

    TaskPlayAnim(playerPed, syringeDict, syringeAnim, 8.0, -8.0, -1, 16, 0, 0, 0, 0)

    RemoveAnimDict(syringeDict)
end

exports("callbloodtype", function()
    ESX.TriggerServerCallback('phoenix:bloodtype', function(result)
        for k, v in pairs(result) do 
            bloodtype = v.bloodtype
        end
    end)
    Citizen.Wait(100)
    return bloodtype
end)

exports("callbloodtypetarget", function(targetplayer)
    local targetid = GetPlayerServerId(targetplayer)
    ESX.TriggerServerCallback('phoenix:bloodtypetarget', function(bluttyp)
        for k, v in pairs(bluttyp) do 
            bloodtype = v.bloodtype
        end
    end, targetid)
    Citizen.Wait(100)
    return bloodtype
end)

exports("deletebloodtype", function()
    TriggerServerEvent("phoenix:deletebloodtype")
end)

exports("setbloodtype", function(blood)
    if blood == nil then
        local type3 = exports["phoenix_bloodtypes"]:callbloodtype()
        if type3 == nil then
            TriggerServerEvent("phoenix:setbloodtype")
            --Config.MSG(Translation[Config.Locale]["received_blootype"])
        end
    else 
        local type2 = exports["phoenix_bloodtypes"]:callbloodtype()
        if type2 == nil then
            TriggerServerEvent("phoenix:setbloodtype", blood)
            --Config.MSG(Translation[Config.Locale]["received_blootype"])
        end
    end
end)

--exports["phoenix_bloodtypes"]:setbloodtype()
--exports["phoenix_bloodtypes"]:setbloodtype('AB+')

--exports["phoenix_bloodtypes"]:callbloodtype()
--exports["phoenix_bloodtypes"]:callbloodtypetarget()
--exports["phoenix_bloodtypes"]:deletebloodtype()
