------------------------------------------------------------------------
-- technology
------------------------------------------------------------------------

local const = require('lib.constants')

local Technology = {}
function Technology:defaultTechnology()
	local electric_railway_1 = {
		type = 'technology',
		name = const.technology_names[1],
		icon = const:png('technology/electric-railway'),
		icon_size = 256,
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.locomotive_names[1],
			},
			{
				type = 'unlock-recipe',
				recipe = const.control_station_names[1],
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
	}

	data:extend {
		electric_railway_1,
	}
end

function Technology:unlockTrainTechnology()
	local electric_railway_2 = {
		type = 'technology',
		name = const.technology_names[2],
		icon_size = 256,
		icon = const:png('technology/electric-railway'),
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.locomotive_names[2],
			},
		},
		prerequisites = { const.technology_names[1] },
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
	}

	local electric_railway_3 = {
		type = 'technology',
		name = const.technology_names[3],
		icon_size = 256,
		icon = const:png('technology/electric-railway'),
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.locomotive_names[3],
			},
		},
		prerequisites = { const.technology_names[2], 'utility-science-pack' },
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
	}
	data:extend {
		electric_railway_2,
		electric_railway_3,
	}
end

function Technology:unlockCargoTechnology()
	local cargo_wagon_2 = {
		type = 'technology',
		name = const.technology_names[4],
		icon_size = 64,
		icon = const:png('item/cargo-wagon'),
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.technology_names[4],
			},
		},
		prerequisites = { 'railway', 'low-density-structure' },
		unit =
		{
			count = 50,
			ingredients = {
				{ 'automation-science-pack', 3 },
				{ 'logistic-science-pack', 2 },
				{ 'chemical-science-pack', 1 },
			},
			time = 30,
		},
		order = 'c-g-a-a-c',
	}

	local cargo_wagon_3 = {
		type = 'technology',
		name = const.technology_names[5],
		icon_size = 64,
		icon = const:png('item/cargo-wagon'),
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.technology_names[5],
			},
		},
		prerequisites = { const.technology_names[4], 'utility-science-pack' },
		unit = {
			count = 100,
			ingredients =
			{
				{ 'automation-science-pack', 4 },
				{ 'logistic-science-pack', 3 },
				{ 'chemical-science-pack', 2 },
				{ 'utility-science-pack', 1 },
			},
			time = 30,
		},
		order = 'c-g-a-a-c-b',
	}

	data:extend {
		cargo_wagon_2,
		cargo_wagon_3,
	}
end

function Technology:unlockFluidTechnology()
	local fluid_wagon_2 = {
		type = 'technology',
		name = const.technology_names[6],
		icon_size = 64,
		icon = const:png('item/fluid-wagon'),
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.technology_names[6],
			},
		},
		prerequisites = { 'fluid-wagon', 'low-density-structure' },
		unit = {
			count = 50,
			ingredients = {
				{ 'automation-science-pack', 3 },
				{ 'logistic-science-pack', 2 },
				{ 'chemical-science-pack', 1 },
			},
			time = 30,
		},
		order = 'c-g-a-b-b',
	}

	local fluid_wagon_3 = {
		type = 'technology',
		name = const.technology_names[7],
		icon_size = 64,
		icon = const:png('item/fluid-wagon'),
		effects = {
			{
				type = 'unlock-recipe',
				recipe = const.technology_names[7],
			},
		},
		prerequisites = { const.technology_names[6], 'utility-science-pack' },
		unit = {
			count = 100,
			ingredients = {
				{ 'automation-science-pack', 4 },
				{ 'logistic-science-pack', 3 },
				{ 'chemical-science-pack', 2 },
				{ 'utility-science-pack', 1 },
			},
			time = 30,
		},
		order = 'c-g-a-b-c',
	}

	data:extend {
		fluid_wagon_2,
		fluid_wagon_3,
	}
end

return Technology
