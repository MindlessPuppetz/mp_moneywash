local Core = exports[Config.Core]:GetCoreObject()

RegisterNetEvent('mp_moneywash:client:openMenu', function()
    local PlayerData = Core.Functions.GetPlayerData()
	local gang = PlayerData.gang.name
	local job = PlayerData.job.name
	local markedAmount = 0
	for k,v in pairs(PlayerData.items) do
		if v.name == Config.BlackMoneyItem then markedAmount = markedAmount + v.amount end
	end
	if markedAmount >= 100 then
		local tax = ((OnJob(job) or InGang(gang)) and 0.0 or Config.Fee)
		local input = lib.inputDialog(Config.Name, {
			{type = 'number', label = 'Money Wash ('.. math.floor(tax * 100) ..'% Fee)', default = markedAmount, description = 'Amount to be washed:', icon = 'fas fa-dollar-sign', required = true, min = 100, max = markedAmount, step = 1},
		})
	
		if not input then
			return 
		else
			local duration = Config.ProgressBar.Duration
			if Config.ProgressBar.Multiplyer?.Enable and markedAmount >= Config.ProgressBar.Multiplyer.IncreasePer then
				if markedAmount >= (Config.ProgressBar.Multiplyer.IncreasePer * 2) then 
					local multi = markedAmount / Config.ProgressBar.Multiplyer.IncreasePer
					local increase = multi * Config.ProgressBar.Multiplyer.IncreaseBy
					duration = duration + increase
					if duration > Config.ProgressBar.Multiplyer.Max then duration = Config.ProgressBar.Multiplyer.Max end
				else
					duration = duration + Config.ProgressBar.Multiplyer.IncreaseBy
				end
			end
			Core.Functions.Notify("Washing will take ".. duration .." seconds to complete. Press X to cancel.", "info", 10000)
			if lib.progressCircle({
				duration     = duration * 1000,
				position     = 'bottom',
				useWhileDead = false,
				allowRagdoll = false,
				allowCuffed  = false,
				canCancel    = true,
				anim = {
					dict     = 'mini@repair',
					clip     = 'fixing_a_player'
				},
				disable = {
					combat   = true,
					move     = true,
				},
			}) then TriggerServerEvent('mp_moneywash:withdraw', input[1], tax) end
		end
	else
		Core.Functions.Notify("You don't seem to have enough laundry to wash.", "error")
	end
end)

-- Render Zones
if Config.Target == 'qb' then
    for k,v in pairs(Config.WASH) do
        exports['qb-target']:AddBoxZone('Money_Wash'..k, v.coords, v.length, v.width, {
            name      = v.name,
            debugPoly = Config.Debug,
            heading   = v.heading,
            minZ      = v.minz,
            maxZ      = v.maxz,
            }, {
            options   = {
                {
                    event = "mp_moneywash:client:openMenu",
                    icon  = "fas fa-washing-machine",
                    label = Lang['open_wash'],
                },
            },
            distance   = v.dist
        })
    end
elseif Config.Target == 'ox' then
    for k,v in pairs(Config.WASH) do
		exports.ox_target:addBoxZone({
			coords    = v.coords,
			size      = vec3(v.length, v.width, 2),
			rotation  = v.heading,
			debug     = Config.Debug,
			options   = {
				{
					event = "mp_moneywash:client:openMenu",
					icon  = "fas fa-washing-machine",
					label = Lang['open_wash'],
				},
			},
			distance  = v.dist
		})
    end
end
