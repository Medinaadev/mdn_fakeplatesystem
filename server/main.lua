ESX = exports.es_extended:getSharedObject()

if Config.Command ~= false then

    RegisterCommand(Config.Command, function(source)

        if not Config.Item.useItem then

            TriggerClientEvent('mdn_fakeplatesystem:changePlate', source)

        elseif Config.Item.useItem and not Config.Item.usableItem then

            local xPlayer = ESX.GetPlayerFromId(source)

            if xPlayer.getInventoryItem(Config.Item.item).count > 0 then

                TriggerClientEvent('mdn_fakeplatesystem:changePlate', source, Config.Item.removeItem)

            else

                xPlayer.showNotification(_U('no_item'))

            end

        else

            TriggerClientEvent('esx:showNotification', source, _U('command_disabled'))

        end

    end)

end

if Config.Item.useItem and Config.Item.usableItem then

    ESX.RegisterUsableItem(Config.Item.item, function(source)

        local xPlayer = ESX.GetPlayerFromId(source)

        TriggerClientEvent('mdn_fakeplatesystem:changePlate', source, Config.Item.removeItem)

    end)

end

RegisterNetEvent('mdn_fakeplatesystem:removeItem', function()

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem(Config.Item.item, 1)

end)

ESX.RegisterServerCallback('mdn_fakeplatesystem:updatePlate', function(source, cb, oldPlate, newPlate)

    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.DataBaseChange then

        local plateExists = false
        local awaiting = true

        if Config.SQL == 'oxmysql' then

            exports.oxmysql:scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', { newPlate }, function(result)

                if result then

                    plateExists = true

                end

                awaiting = false

            end)

        elseif Config.SQL == 'ghmattimysql' then

            local result = exports.ghmattimysql:scalarSync('SELECT plate FROM owned_vehicles WHERE plate = ?', { newPlate })

            if result then

                plateExists = true

            end

            awaiting = false

        elseif Config.SQL == 'mysql-async' then

            exports['mysql-async']:mysql_fetch_scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', { newPlate }, function(result)

                if result then

                    plateExists = true

                end

                awaiting = false

            end)

        end

        while awaiting do

            Wait(250)

        end

        if not plateExists then

            print(plateExists)

            if Config.SQL == 'oxmysql' then

                oldPlate = oldPlate:gsub("^%s*(.-)%s*$", "%1")

                exports.oxmysql:query('SELECT * FROM owned_vehicles WHERE plate = ?', { oldPlate }, function(result)
                    if result and result[1] then

                        local props = json.decode(result[1].vehicle)
    
                        props.plate = newPlate
    
                        props = json.encode(props)
    
                        exports.oxmysql:execute('UPDATE owned_vehicles SET plate = ?, vehicle = ? WHERE plate = ?', { newPlate, props, oldPlate })
    
                    end
                end)

            elseif Config.SQL == 'ghmattimysql' then

                local result = exports.ghmattimysql:executeSync('SELECT * FROM owned_vehicles WHERE plate = ?', { oldPlate })

                if result and result[1] then

                    local props = json.decode(result[1].vehicle)

                    props.plate = newPlate

                    props = json.encode(props)

                    exports.ghmattimysql:executeSync('UPDATE owned_vehicles SET plate = ?, vehicle = ? WHERE plate = ?', { newPlate, props, oldPlate })

                end

            elseif Config.SQL == 'mysql-async' then

                exports['mysql-async']:mysql_fetch_all('SELECT * FROM owned_vehicles WHERE plate = ?', { oldPlate }, function(result)

                    if result and result[1] then

                        local props = json.decode(result[1].vehicle)

                        props.plate = newPlate

                        props = json.encode(props)

                        exports['mysql-async']:mysql_execute('UPDATE owned_vehicles SET plate = ?, vehicle = ? WHERE plate = ?', { newPlate, props, oldPlate })

                    end

                end)

            end

            TriggerClientEvent('mdn_fakeplatesystem:updatePlate', -1, GetEntityCoords(GetPlayerPed(source)), oldPlate, newPlate)

            xPlayer.showNotification(_U('plate_changed', newPlate))

        else

            xPlayer.showNotification(_U('plate_already_exists'))

        end

    else

        TriggerClientEvent('mdn_fakeplatesystem:updatePlate', -1, GetEntityCoords(GetPlayerPed(source)), oldPlate, newPlate)

        xPlayer.showNotification(_U('plate_changed', newPlate))

    end

end)