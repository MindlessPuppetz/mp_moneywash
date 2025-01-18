local Core = exports[Config.Core]:GetCoreObject()

RegisterServerEvent('mp_moneywash:withdraw')
AddEventHandler('mp_moneywash:withdraw', function(input, tax)
	local src = source
    local Player = Core.Functions.GetPlayer(src)
	local markedAmount = 0

    if Config.Inventory  == 'ox' then
        local items = exports.ox_inventory:GetItemCount(src, Config.BlackMoneyItem)
        markedAmount = items or 0
        if Config.Debug then
            print ("Step 1: markedAmount: ".. markedAmount)
            print ("Step 1: items: ".. items)
            print ("Step 1: input: ".. input)
        end
    elseif Config.Inventory == 'qb' then
        local items = Player.PlayerData.items
        for k,v in pairs(items) do
            if v.name == Config.BlackMoneyItem then markedAmount = markedAmount + v.amount end
        end
    end

    if (markedAmount >= input) and input >= Config.Minimum then
        if Config.Debug then
            print ("Step 2: markedAmount: ".. markedAmount)
            print ("Step 2: input: ".. input)
            print ("Step 2: tax: ".. tax)
        end
        local newAmount = input - (input * tax)
        if Config.Inventory == "qb" then
            Player.Functions.RemoveItem(Config.BlackMoneyItem, input)
            Player.Functions.AddMoney("cash", newAmount, "Money-Wash")
        elseif Config.Inventory == "ox" then
            exports.ox_inventory:RemoveItem(src, Config.BlackMoneyItem, input)
            exports.ox_inventory:AddItem(src, Config.MoneyItem, newAmount)
        end
        Core.Functions.Notify(src, "You received $".. newAmount .." in clean laundry." , "success")
        local creator = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname .."("..Player.PlayerData.source..")["..Player.PlayerData.citizenid.."]"
        DiscordLog(creator, input, newAmount)
	else
		Core.Functions.Notify(src, "You don't seem to have the required amount of laundry you are trying to wash.", "error")
	end
end)

Discord = {
    ['webhook'] = Config.Webhook,
    ['name']    = 'Money Wash',
    ['image']   = Config.WHImage,
}

function DiscordLog(name, deposit, receive)
    local embed = {
        {
            ["color"]        = 04255,
            ["title"]        = "**Money Washed:**",
            ["description"]  = "Deposited: $".. deposit ..". Received: $".. receive,
            ["url"]          = "",
            ["footer"] = {
                ["text"]     = "Washed by: "..name,
                ["icon_url"] = ""
            },
            ["thumbnail"] = {
                ["url"]      = "",
            },
		}
	}
    PerformHttpRequest(Discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = Discord['name'], embeds = embed, avatar_url = Discord['image']}), { ['Content-Type'] = 'application/json' })
end

