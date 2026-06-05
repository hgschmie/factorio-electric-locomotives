------------------------------------------------------------------------
-- technology
------------------------------------------------------------------------

local const = require('lib.constants')

local electric_railway = {
	-- Tier 1
	{
		type = 'technology',
		name = const.technology_prefix .. '1',
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.locomotive_prefix .. '1',
			},
			{
				type = 'unlock-recipe',
				recipe = const.control_station_prefix .. '1',
			},
			{
				type = 'unlock-recipe',
				recipe = 'et-current-collector',
			},
		},
		prerequisites = {
			'railway',
			'electric-engine',
			'battery',
			'low-density-structure',
		},
		unit = {
			count = 300,
			ingredients = {
				{ 'automation-science-pack', 1 },
				{ 'logistic-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- Tier 2
	{
		type = 'technology',
		name = const.technology_prefix .. '2',
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.locomotive_prefix .. '2',
			},
			{
				type = 'unlock-recipe',
				recipe = const.control_station_prefix .. '2',
			},
		},
		prerequisites = {
			const.technology_prefix .. '1',
		},
		unit = {
			count = 300,
			ingredients = {
				{ 'automation-science-pack', 2 },
				{ 'logistic-science-pack', 2 },
				{ 'chemical-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- Tier 3
	{
		type = 'technology',
		name = const.technology_prefix .. '3',
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.locomotive_prefix .. '3',
			},
			{
				type = 'unlock-recipe',
				recipe = const.control_station_prefix .. '3',
			},
		},
		prerequisites = {
			const.technology_prefix .. '2',
		},
		unit = {
			count = 300,
			ingredients = {
				{ 'automation-science-pack', 3 },
				{ 'logistic-science-pack', 3 },
				{ 'chemical-science-pack', 2 },
				{ 'utility-science-pack', 1 },
			},
			time = 30,
		},
	},
}

local speed_tiers = {
	-- Tier 1
	{
		type = 'technology',
		name = const.technology_speed_prefix .. 1,
		localised_description = { const:locale('et-electric-railway-speed'), tostring((const.speed_progression[1] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_prefix .. '1',
		},
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 1 },
				{ 'logistic-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- Tier 2
	{
		type = 'technology',
		name = const.technology_speed_prefix .. 2,
		localised_description = { const:locale('et-electric-railway-speed'), tostring((const.speed_progression[2] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_speed_prefix .. 1,
		},
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 2 },
				{ 'logistic-science-pack', 2 },
				{ 'chemical-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- Tier 3
	{
		type = 'technology',
		name = const.technology_speed_prefix .. 3,
		localised_description = { const:locale('et-electric-railway-speed'), tostring((const.speed_progression[3] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_speed_prefix .. 2,
		},
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 3 },
				{ 'logistic-science-pack', 3 },
				{ 'chemical-science-pack', 2 },
				{ 'utility-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- faster
	{
		type = 'technology',
		name = const.technology_speed_prefix .. 4,
		localised_description = { const:locale('et-electric-railway-speed'), tostring((const.speed_progression[4] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_speed_prefix .. 3,
		},
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 4 },
				{ 'logistic-science-pack', 4 },
				{ 'chemical-science-pack', 3 },
				{ 'utility-science-pack', 2 },
				{ 'production-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- fastest
	{
		type = 'technology',
		name = const.technology_speed_prefix .. 5,
		localised_description = { const:locale('et-electric-railway-speed'), tostring((const.speed_progression[5] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_speed_prefix .. 4,
		},
		unit = {
			count = 200,
			ingredients = {
				{ 'automation-science-pack', 4 },
				{ 'logistic-science-pack', 4 },
				{ 'chemical-science-pack', 3 },
				{ 'utility-science-pack', 2 },
				{ 'production-science-pack', 1 },
			},
			time = 30,
		},
	},
}

local acceleration_tiers = {
	-- Tier 1
	{
		type = 'technology',
		name = const.technology_acceleration_prefix .. 1,
		localised_description = { const:locale('et-electric-railway-acceleration'), tostring((const.acceleration_progression[1] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_prefix .. '1',
		},
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 1 },
				{ 'logistic-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- Tier 2
	{
		type = 'technology',
		name = const.technology_acceleration_prefix .. 2,
		localised_description = { const:locale('et-electric-railway-acceleration'), tostring((const.acceleration_progression[2] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_acceleration_prefix .. 1,
		},
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 2 },
				{ 'logistic-science-pack', 2 },
				{ 'chemical-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- Tier 3
	{
		type = 'technology',
		name = const.technology_acceleration_prefix .. 3,
		localised_description = { const:locale('et-electric-railway-acceleration'), tostring((const.acceleration_progression[3] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_acceleration_prefix .. 2,
		},
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 3 },
				{ 'logistic-science-pack', 3 },
				{ 'chemical-science-pack', 2 },
				{ 'utility-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- faster
	{
		type = 'technology',
		name = const.technology_acceleration_prefix .. 4,
		localised_description = { const:locale('et-electric-railway-acceleration'), tostring((const.acceleration_progression[4] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_acceleration_prefix .. 3,
		},
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 4 },
				{ 'logistic-science-pack', 4 },
				{ 'chemical-science-pack', 3 },
				{ 'utility-science-pack', 2 },
				{ 'production-science-pack', 1 },
			},
			time = 30,
		},
	},
	-- fastest
	{
		type = 'technology',
		name = const.technology_acceleration_prefix .. 5,
		localised_description = { const:locale('et-electric-railway-acceleration'), tostring((const.acceleration_progression[5] - 1) * 100) },
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		enabled = false,
		upgrade = true,
		effects = {},
		prerequisites = {
			const.technology_acceleration_prefix .. 4,
		},
		unit = {
			count = 200,
			ingredients = {
				{ 'automation-science-pack', 4 },
				{ 'logistic-science-pack', 4 },
				{ 'chemical-science-pack', 3 },
				{ 'utility-science-pack', 2 },
				{ 'production-science-pack', 1 },
			},
			time = 30,
		},
	},
}

local Technology = {}

local mod_data = assert(data.raw['mod-data'][const.name])

function Technology:defaultTechnology(mk_engines)
	local names = mod_data.data.technology.base
	names[#names + 1] = electric_railway[1].name

	electric_railway[1].enabled = true

	if mk_engines then
		-- only enable first tier, rest is done in advanced
		speed_tiers[1].enabled = true
		acceleration_tiers[1].enabled = true
	else
		for _, technology in pairs(speed_tiers) do
			technology.enabled = true
		end

		for _, technology in pairs(acceleration_tiers) do
			technology.enabled = true
		end

		data:extend(speed_tiers)
		data:extend(acceleration_tiers)
	end

	data:extend {
		electric_railway[1],
	}
end

---@param mk_engines boolean
---@param mk_cargo boolean
---@param mk_fluid boolean
function Technology:unlockAdvancedTiers(mk_engines, mk_cargo, mk_fluid)
	if not (mk_engines or mk_cargo or mk_fluid) then return end

	local names = mod_data.data.technology.advanced

	for idx = 2, 3 do
		local effects = electric_railway[idx].effects

		if mk_engines then
			effects[#effects + 1] = {
				type = 'unlock-recipe',
				recipe = const.locomotive_prefix .. idx,
			}
			effects[#effects + 1] = {
				type = 'unlock-recipe',
				recipe = const.control_station_prefix .. idx,
			}
		end

		if mk_cargo then
			effects[#effects + 1] = {
				type = 'unlock-recipe',
				recipe = const.cargo_wagon_prefix .. idx,
			}
		end

		if mk_fluid then
			effects[#effects + 1] = {
				type = 'unlock-recipe',
				recipe = const.fluid_wagon_prefix .. idx,
			}
		end

		names[#names + 1] = electric_railway[idx].name
	end

	if mk_engines then
		for idx = 2, 5 do
			if idx < 4 then
				speed_tiers[idx].prerequisites[#speed_tiers[idx].prerequisites + 1] = const.technology_prefix .. idx
				acceleration_tiers[idx].prerequisites[#acceleration_tiers[idx].prerequisites + 1] = const.technology_prefix .. idx
			end

			speed_tiers[idx].enabled = true
			acceleration_tiers[idx].enabled = true
		end

		data:extend(speed_tiers)
		data:extend(acceleration_tiers)
	end

	data:extend {
		electric_railway[2],
		electric_railway[3],
	}
end

return Technology
