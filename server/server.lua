local Core = exports[Config.Core]:GetCoreObject()

RegisterServerEvent('mp_moneywash:withdraw')
AddEventHandler('mp_moneywash:withdraw', function(input, tax)
	local src = source
    local Player = Core.Functions.GetPlayer(src)
	local markedAmount = 0
	for k,v in pairs(Player.PlayerData.items) do
		if v.name == Config.BlackMoneyItem then markedAmount = markedAmount + v.amount end
	end
	if (markedAmount >= input) and input >= 100 then
		Player.Functions.RemoveItem(Config.BlackMoneyItem, input)
		local newAmount = input - (input * tax)
		Player.Functions.AddMoney("cash", newAmount, "Money-Wash")
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
    ['image']   = "https://CHANGEME.com/laundry_icon.png"
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

