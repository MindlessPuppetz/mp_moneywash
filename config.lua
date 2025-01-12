Config = {}
Config.Core = "qb-core"                 -- change to your core name
Config.Webhook = "CHANGE ME"            -- change to your discord webhook
Config.Debug = false                    -- debug polyzones
Config.WASH = {                         -- Can support multiple locations.
    { name = "laundry1", coords = vector3(1122.373, -3193.474, -41.40308), length = 2.0, width = 2.0, heading = 0.0, minz = -41.0, maxz = -39.0, dist = 2.0},
	--{ name = "laundry2", coords = vector3(-1868.48, 2065.24, 134.43), length = 1.5, width = 1.5, heading = 0.0, minz = -36.0, maxz = -38.0, dist = 2.0},
}

Config.Fee = 0.50                       -- 0.30 = 30%
Config.BlackMoneyItem = "markedbills"   -- name of black money

Config.ProgressBar = {
  Duration = 30,                        -- minimum timer amount in seconds
  Multiplyer = {
    Enable = true,                      -- enable/disable multiplyer
    IncreasePer = 100000,               -- marked bills amount
    IncreaseBy = 5,                     -- time increased by (in seconds) for every IncreasePer
    Max = 120,                          -- time in seconds
  },
}

Config.Gangs = {
  'mafia',
  'reaper',
  'ltc',
}

Config.Jobs = {
  'cardealer',
}

Lang = {
	['invalid_amount'] = 'Invalid amount',
	['wash_money']     = 'You have Washed $',
	['open_wash'] 	   = 'Open Wash',
}

-- Shared Functions - Do Not Edit
function OnJob(job)
	for i = 1, #Config.Jobs do
		if Config.Jobs[i] == job then
			return true
		end
	end
	return false
end
function InGang(gang)
	for i = 1, #Config.Gangs do
		if Config.Gangs[i] == gang then
			return true
		end
	end
	return false
end