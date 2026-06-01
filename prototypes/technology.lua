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
		order = 'c-g-a-a',
	},
	-- Tier 2
	{
		type = 'technology',
		name = const.technology_prefix .. '2',
		icon_size = 256,
		icon = const:png('technology/electric-railway'),
		effects = {},
		prerequisites = { const.technology_prefix .. '1', 'chemical-science-pack' },
		unit = {
			count = 300,
			ingredients = {
				{ 'automation-science-pack', 2 },
				{ 'logistic-science-pack', 2 },
				{ 'chemical-science-pack', 1 },
			},
			time = 30,
		},
		order = 'c-g-a-a-a-b',
	},
	-- Tier 3
	{
		type = 'technology',
		name = const.technology_prefix .. '3',
		icon_size = 256,
		icon = const:png('technology/electric-railway'),
		effects = {},
		prerequisites = { const.technology_prefix .. '2', 'utility-science-pack' },
		unit = {
			count = 300,
			ingredients = {
				{ 'automation-science-pack', 3 },
				{ 'logistic-science-pack', 3 },
				{ 'chemical-science-pack', 1 },
				{ 'utility-science-pack', 1 },
			},
			time = 30,
		},
		order = 'c-g-a-a-a-c',
	},
}

local Technology = {}

function Technology:defaultTechnology()
	data:extend {
		electric_railway[1],
	}
end

---@param mk_engines boolean
---@param mk_cargo boolean
---@param mk_fluid boolean
function Technology:unlockAdvancedTiers(mk_engines, mk_cargo, mk_fluid)

	if not (mk_engines or mk_cargo or mk_fluid) then return end

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
	end

	data:extend {
		electric_railway[2],
		electric_railway[3],
	}
end

return Technology
