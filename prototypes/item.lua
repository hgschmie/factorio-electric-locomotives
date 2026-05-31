------------------------------------------------------------------------
-- items
------------------------------------------------------------------------

local util = require('util')
local meld = require('meld')

local const = require('lib.constants')

local locomotive = data.raw['item-with-entity-data']['locomotive']

local function make_engine(index)
	return meld(util.copy(locomotive), {
		name = const.locomotive_names[index],
		icon = meld.delete(),
		icon_size = meld.delete(),
		icons = {
			{
				icon = const:png('item/locomotive'),
				icon_size = 64,
				tint = const.tier_tint[index],
			}
		},
		subgroup = 'train-transport',
		order = 'c[rolling-stock]-a[locomotive]-' .. index,
		place_result = const.locomotive_names[index],
	})
end

data:extend {
	make_engine(1),
	make_engine(2),
	make_engine(3),
}

local cargo_wagon = data.raw['item-with-entity-data']['cargo-wagon']
local fluid_wagon = data.raw['item-with-entity-data']['fluid-wagon']

local function make_cargo_wagon(index)
	return meld(util.copy(cargo_wagon), {
		name = const.cargo_wagon_names[index],
		icon = meld.delete(),
		icon_size = meld.delete(),
		icons = {
			{
				icon = const:png('item/cargo-wagon'),
				icon_size = 64,
				tint = const.tier_tint[index],
			}
		},
		subgroup = 'train-transport',
		order = 'c[rolling-stock]-b[cargo-wagon]-' .. index,
		place_result = const.cargo_wagon_names[index],
	})
end

local function make_fluid_wagon(index)
	return meld(util.copy(fluid_wagon), {
		name = const.fluid_wagon_names[index],
		icon = meld.delete(),
		icon_size = meld.delete(),
		icons = {
			{
				icon = const:png('item/fluid-wagon'),
				icon_size = 64,
				tint = const.tier_tint[index],
			},
		},
		subgroup = 'train-transport',
		order = 'c[rolling-stock]-c[fluid-wagon]-' .. index,
		place_result = const.fluid_wagon_names[index],
	})
end

data:extend {
	make_cargo_wagon(2),
	make_cargo_wagon(3),
	make_fluid_wagon(2),
	make_fluid_wagon(3),
}

local et_fuel_category = {
	--- PrototypeBase
	type = 'fuel-category',
	name = 'et-electric-fuel',
	hidden = true,
	hidden_in_factoriopedia = true,
}

local current_collector = {
	type = 'item',
	name = 'et-current-collector',
	icon = const:png('item/current-collector-icon'),
	icon_size = 32,
	subgroup = 'electric-transport',
	order = 'a[electric-transport]-b[et-current-collector]-1',
	stack_size = 200,
}

data:extend {
	et_fuel_category,
	current_collector,
}

-- At full acceleration, a type 1 loco burns 10kJ per tick
-- a fuel item lasts ~ 20 ticks before refuel, so if it runs out of
-- fuel, it will decelerate and stop within 1/3 of a second.

local ticks_per_fuel = 20

local function make_fuel(index)
	local factor = const.tier_multipliers[index]

	---@type data.ItemPrototype
	return {
		--- PrototypeBase
		type = 'item',
		name = const.fuel_names[index],
		hidden = true,
		hidden_in_factoriopedia = true,

		--- ItemPrototype
		stack_size = 1,
		icon = const:png('item/part-electronic-transformer-1'),
		icon_size = 64,
		fuel_category = 'et-electric-fuel',
		flags = {
			'hide-from-bonus-gui',
			'hide-from-fuel-tooltip',
		},
		fuel_value = (loco_consumption_per_tick * factor * ticks_per_fuel) .. 'kJ',
	}
end

data:extend {
	make_fuel(1),
	make_fuel(2),
	make_fuel(3),
}

local function make_control_station(index)
	return meld(util.copy(data.raw['item']['small-lamp']), {
		type = 'item',
		name = const.control_station_names[index],
		icon = const:png('item/control-station-' .. index),
		icon_size = 64,
		subgroup = 'electric-transport',
		order = 'a[electric-transport]-a[et-control-station]-' .. index,
		place_result = const.control_station_names[index],
	})
end

data:extend {
	make_control_station(1),
	make_control_station(2),
	make_control_station(3),
}
