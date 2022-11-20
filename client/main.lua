ESX = exports.es_extended:getSharedObject()

RegisterNetEvent('mdn_fakeplatesystem:changePlate', function(canRemove)

    if not IsPedInAnyVehicle(PlayerPedId()) then

        local vehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

        if vehicle ~= 0 and distance < 3.5 then

            SetNuiFocus(true, true)

            RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')

            while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do

                Citizen.Wait(0)

            end

            TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, -8.0, -1, 1, 0, false, false, false)

            SendNUIMessage({
                action = 'show',
                config = Config
            })

            if canRemove then

                TriggerServerEvent('mdn_fakeplatesystem:removeItem')

            end

        else

            ESX.ShowNotification(_U('no_nearby_vehicle'))

        end

    else

        ESX.ShowNotification(_U('exit_vehicle'))

    end

end)

RegisterNUICallback('close', function()

    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())

end)

RegisterNUICallback('changePlate', function(data)

    local foundInBlackList = false

    data.plate = string.upper(data.plate)

    SetNuiFocus(false, false)

    for k, v in pairs(Config.BlackList) do

        if string.lower(data.plate) == string.lower(v) then

            foundInBlackList = true

            break

        end

    end

    if not foundInBlackList then

        local vehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

        if vehicle ~= 0 and distance < 3.5 then
            local plate = GetVehicleNumberPlateText(vehicle)
            local plateCleanned = ''

            if plate:sub(1, 1) == ' ' then
                for i = 1, plate:len() do
                    if plate:sub(i, i) == ' ' then
                        plateCleanned = plate:sub(i+1, plate:len())
                    else
                        break
                    end
                end
            end

            plate = plateCleanned
            
            if plate:sub(plate:len(), plate:len()) == ' ' then
                for i = 0, plate:len() do
                    if plate:sub(plate:len()-i, plate:len()-i) == ' ' then
                        plateCleanned = plate:sub(1, (plate:len()-i) - 1)
                    else
                        break
                    end
                end
            end

            if plateCleanned == data.plate then

                ESX.ShowNotification(_U('plate_already', data.plate))

            else

                exports.mdn_progressbar:Progress(_U('changing_plate'), Config.Time)

                Wait(Config.Time)

                ClearPedTasks(PlayerPedId())

                ESX.TriggerServerCallback('mdn_fakeplatesystem:updatePlate', function() end, plateCleanned, data.plate)

            end

        else

            ESX.ShowNotification(_U('no_nearby_vehicle'))

        end

    else

        ESX.ShowNotification(_U('plate_not_allowed', data.plate))

    end

end)

RegisterNetEvent('mdn_fakeplatesystem:updatePlate', function(coords, oldPlate, newPlate)

    local vehicles = ESX.Game.GetVehicles()

    for k,v in pairs(vehicles) do

        local plate = GetVehicleNumberPlateText(v)
        local plateCleanned = ''

        if plate:sub(1, 1) == ' ' then
            for i = 1, plate:len() do
                if plate:sub(i, i) == ' ' then
                    plateCleanned = plate:sub(i+1, plate:len())
                else
                    break
                end
            end
        end

        plate = plateCleanned
        
        if plate:sub(plate:len(), plate:len()) == ' ' then
            for i = 0, plate:len() do
                if plate:sub(plate:len()-i, plate:len()-i) == ' ' then
                    plateCleanned = plate:sub(1, (plate:len()-i) - 1)
                else
                    break
                end
            end
        end

        if plateCleanned == oldPlate then

            SetVehicleNumberPlateText(v, newPlate)

        end

    end

end)