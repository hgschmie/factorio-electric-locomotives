------------------------------------------------------------------------
-- entities
------------------------------------------------------------------------

local sounds = require('__base__.prototypes.entity.sounds')

local util = require('util')
local meld = require('meld')
local collision_mask_util = require('collision-mask-util')

local const = require('lib.constants')

local cargo_wagon = data.raw['cargo-wagon']['cargo-wagon']
local fluid_wagon = data.raw['fluid-wagon']['fluid-wagon']

local locomotive = data.raw['locomotive']['locomotive']
local MAX_POWER = locomotive.max_power:sub(locomotive.max_power:find('%d+'))

-- how many ticks must a control station support
local TICK_FACTOR = Framework.settings:startup_setting(const.settings_names.tick_interval)

-- how many locos should a control station support at full load
local LOCOS_PER_TIER = Framework.settings:startup_setting(const.settings_names.engines_per_control_station)

-- at full acceleration, a base loco pulls 600kW, which is 10kJ/tick
loco_consumption_per_tick = MAX_POWER / 60 -- global to use in items

local Entity = {}

local function make_engine(index)
	local factor = const.tier_multipliers[index]

	return meld(util.copy(locomotive), {
		-- Prototype Base
		name = const.locomotive_prefix .. index,

		-- EntityPrototype
		icon = meld.delete(),
		icon_size = meld.delete(),
		icons = {
			{
				icon = const:png('item/locomotive'),
				icon_size = 64,
				tint = const.tier_tint[index],
			},
		},
		minable = {
			result = const.locomotive_prefix .. index,
		},

		-- Vehicle Prototype
		stop_trigger = meld.overwrite {
			{
				type = 'play-sound',
				sound = sounds.train_brakes,
			},
			{
				type = 'play-sound',
				sound = sounds.train_brake_screech,
			},
		},

		-- EntityWithHealthPrototype
		max_health = locomotive.max_health * factor,

		-- VehiclePrototype
		braking_force = locomotive.braking_force * factor,
		friction_force = locomotive.friction_force / factor,

		-- RollingStockPrototype
		max_speed = locomotive.max_speed * factor,
		air_resistance = locomotive.air_resistance / factor,

		-- LocomotivePrototype
		max_power = (MAX_POWER * factor) .. 'kW',
		reversing_power_modifier = locomotive.reversing_power_modifier * factor,

		-- LocomotivePrototype
		energy_source = {
			fuel_inventory_size = 0,
			fuel_categories = meld.overwrite { 'et-electric-fuel' },
			smoke = meld.delete(),
			emissions_per_minute = nil,
		},
	})
end

-- at full acceleration, a type 1 loco pulls 600kW, which is 10kJ/tick
-- a power station should be able to support 20 type 1 locomotives
--
-- at tick rate 2, there must be 10kJ * 2 * 20 = 400kJ buffer capacity
-- to refill 200kJ in one tick, it must be able to pull 12000kW

---@type data.ElectricEnergyInterfacePrototype
local function make_control_station(index)
	local factor = const.tier_multipliers[index]

	-- consumption per loco, scaled for tiers. A base loco consumes 10kJ/tick
	local base_consumption = loco_consumption_per_tick * factor

	-- The amount of energy needed per tick to fully power all supported locos
	local buffer_capacity_per_tick = LOCOS_PER_TIER * base_consumption
	-- basic drain (nothing is free)
	local drain = 200 + 50 * factor
	-- input flow limit to fully load one tick worth of energy into the buffer
	local buffer_flow_limit = buffer_capacity_per_tick * 60

	return {
		-- Prototype Base
		type = 'electric-energy-interface',
		name = const.control_station_prefix .. index,

		-- ElectricEnergyInterfacePrototype
		energy_source = {
			type = 'electric',
			buffer_capacity = (buffer_capacity_per_tick * TICK_FACTOR) .. 'kJ',
			input_flow_limit = (buffer_flow_limit + drain) .. 'kW',
			output_flow_limit = '0W',
			usage_priority = 'secondary-input',
			drain = drain .. 'kW',
		},

		gui_mode = 'none',
		continuous_animation = true,

		animation = {
			layers = {
				{
					filename = const:png('entity/control-station-animation'),
					priority = 'high',
					width = 160,
					height = 290,
					frame_count = 20,
					line_length = 8,
					shift = util.by_pixel(0, -5),
					scale = 0.5,
				},
				{
					filename = const:png('entity/control-station-emission'),
					blend_mode = 'additive',
					priority = 'high',
					width = 160,
					height = 290,
					frame_count = 20,
					line_length = 8,
					shift = util.by_pixel(0, -5),
					draw_as_glow = true,
					scale = 0.5,
				},
				{
					filename = const:png('entity/control-station-shadow'),
					priority = 'high',
					width = 400,
					height = 350,
					line_length = 1,
					repeat_count = 20,
					shift = util.by_pixel(0, -5),
					draw_as_shadow = true,
					scale = 0.5,
				},
			},
		},

		-- EntityWithHealthPrototype
		max_health = 200 + 50 * factor,
		dying_explosion = 'medium-explosion',
		corpse = 'medium-remnants',

		-- EntityPrototype
		icon = const:png('item/control-station-' .. index),
		collision_box = { { -1.45, -1.95 }, { 1.45, 1.95 } },
		collision_mask = collision_mask_util.get_default_mask('simple-entity'),
		selection_box = { { -1.5, -2 }, { 1.5, 2 } },

		flags = {
			'placeable-neutral',
			'player-creation',
		},

		minable = {
			mining_time = 1,
			result = const.control_station_prefix .. index,
		},
	}
end

local function make_cargo_wagon(index)
	local factor = const.tier_multipliers[index]

	return meld(util.copy(cargo_wagon), {
		-- Prototype Base
		name = const.cargo_wagon_prefix .. index,

		-- EntityPrototype
		icon = meld.delete(),
		icon_size = meld.delete(),
		icons = {
			{
				icon = const:png('item/cargo-wagon'),
				icon_size = 64,
				tint = const.tier_tint[index],
			},
		},
		minable = {
			result = const.cargo_wagon_prefix .. index,
		},

		-- EntityWithHealthPrototype
		max_health = cargo_wagon.max_health * factor,

		-- VehiclePrototype
		braking_force = cargo_wagon.braking_force * factor,
		friction_force = cargo_wagon.friction_force / factor,

		-- RollingStockPrototype
		weight = cargo_wagon.weight * factor,
		max_speed = cargo_wagon.max_speed * factor,
		air_resistance = cargo_wagon.air_resistance / factor,

		-- CargoWagonPrototype
		inventory_size = cargo_wagon.inventory_size * factor,
		quality_affects_inventory_size = true,
	})
end

local function make_fluid_wagon(index)
	local factor = const.tier_multipliers[index]

	return meld(util.copy(fluid_wagon), {
		-- Prototype Base
		name = const.fluid_wagon_prefix .. index,

		-- EntityPrototype
		icon = meld.delete(),
		icon_size = meld.delete(),
		icons = {
			{
				icon = const:png('item/fluid-wagon'),
				icon_size = 64,
				tint = const.tier_tint[index],
			},
		},
		minable = {
			result = const.fluid_wagon_prefix .. index,
		},

		-- EntityWithHealthPrototype
		max_health = fluid_wagon.max_health * factor,

		-- VehiclePrototype
		braking_force = fluid_wagon.braking_force * factor,
		friction_force = fluid_wagon.friction_force / factor,

		-- RollingStockPrototype
		weight = fluid_wagon.weight * factor,
		max_speed = fluid_wagon.max_speed * factor,
		air_resistance = fluid_wagon.air_resistance / factor,

		-- FluidWagonPrototype
		capacity = fluid_wagon.capacity * factor,
		quality_affects_inventory_size = true,
	})
end

function Entity:defaultEntities()
	data:extend {
		make_engine(1),
		make_control_station(1),
	}
end

function Entity:makeAdvancedEngines()
	data:extend {
		make_engine(2),
		make_control_station(2),

		make_engine(3),
		make_control_station(3),
	}
end

function Entity:makeCargoWagons()
	data:extend {
		make_cargo_wagon(2),
		make_cargo_wagon(3),
	}
end

function Entity:makeFluidWagons()
	data:extend {
		make_fluid_wagon(2),
		make_fluid_wagon(3),
	}
end

return Entity

-- function format_number(number_string)
-- 	local number = number_string:match('%d+%.?%d+')
-- 	local append_suffix = number_string:match('%a+')

-- 	local pre = ""
-- 	local typ = ""

-- 	if append_suffix:len() == 2 then
-- 		pre =  append_suffix:sub(1, 1):upper()
-- 		typ =  append_suffix:sub(2):upper()
-- 	elseif append_suffix:len() == 1 then
-- 		typ = append_suffix:upper()
-- 	end


-- 	if pre == "K" then
-- 		number = number * 1000
-- 	elseif pre == "M" then
-- 		number = number * 1000000
-- 	end

-- 	if typ == "W" then
-- 		number = number / 60
-- 	end
-- 	return number
-- end

-- function CreateTrainInterface(train)	
-- 	local power = format_number(train.max_power)	
-- 	local energy = power * 1.1

-- 	data:extend(
-- 	{
-- 		{
-- 			type = "electric-energy-interface",
-- 			name = train.name .. "-power",
-- 			icon = train.icon,
-- 			icon_size = 32,
-- 			localised_name = {"entity-name." .. train.name},
-- 			collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
-- 			selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
-- 			collision_mask = {
-- 				layers = {
-- 					ground_tile = true
-- 				}
-- 			},
-- 			selectable_in_game = false,
-- 			energy_source =
-- 			{
-- 				type = "electric",
-- 				buffer_capacity = (energy * 2) .. "J",
-- 				usage_priority = "secondary-input",
-- 				input_flow_limit = energy .. "J" ,
-- 				drain = power / 10 .. "J" ,
-- 				render_no_network_icon = false,
-- 				render_no_power_icon = false
-- 			},
-- 			picture =
-- 			{
-- 				filename = "__core__/graphics/empty.png",
-- 				priority = "extra-high",
-- 				width = 1,
-- 				height = 1
-- 			},
-- 			order = "z"
-- 		}
-- 	})
-- end

-- CreateTrainInterface(data.raw['locomotive'][const.locomotive_prefix .. '1'])	
-- CreateTrainInterface(data.raw['locomotive'][const.locomotive_prefix .. '2'])
-- CreateTrainInterface(data.raw['locomotive'][const.locomotive_prefix .. '3'])

-- function InsertMUControl(name)
-- 	data:extend(
-- 	{
-- 		{
-- 			type = "electric-energy-interface",
-- 			name = name .. "-power",
-- 			icon = "__core__/graphics/empty.png",
-- 			icon_size = 32,
-- 			collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
-- 			selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
-- 			collision_mask = {
-- 				layers = {
-- 					ground_tile = true
-- 				}
-- 			},
-- 			selectable_in_game = false,
-- 			energy_source =
-- 			{
-- 				type = "void"
-- 			},
-- 			picture =
-- 			{
-- 				filename = "__core__/graphics/empty.png",
-- 				priority = "extra-high",
-- 				width = 1,
-- 				height = 1
-- 			},
-- 			order = "z"
-- 		}
-- 	})
-- end

-- if mods['MultipleUnitTrainControl'] then
-- 	InsertMUControl("const.locomotive_prefix .. '1'-mu")
-- 	InsertMUControl("et-electric-locomotive-2-mu")
-- 	InsertMUControl("et-electric-locomotive-3-mu")
-- end
