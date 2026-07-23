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

-- how many locos should a control station support at full load
local LOCOS_PER_TIER = Framework.settings:startup_setting(const.settings_names.engines_per_control_station)

-- at full acceleration, a base loco pulls 600kW, which is 10kJ/tick
loco_consumption_per_tick = MAX_POWER / 60 -- global to use in items

local mod_data = assert(data.raw['mod-data'][const.name])

local Entity = {}

---@param factor number
---@return fun(value: number?): number?
local function mult_factor(factor)
    return function(value)
        if not value then return nil end
        return value * factor
    end
end

---@param factor number
---@return fun(value: number?): number?
local function div_factor(factor)
    return function(value)
        if not value then return nil end
        return value / factor
    end
end

---@param index integer
---@param tier string
---@return data.LocomotivePrototype
local function make_engine(index, tier)
    local factor = const.tier_multipliers[index]
    local factor_mult = mult_factor(factor)
    local factor_div = div_factor(factor)

    local name = const.locomotive_prefix .. index

    local names = mod_data.data.locomotive[tier]
    names[#names + 1] = name

    return meld(util.copy(locomotive), {
        -- Prototype Base
        name = name,

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
            result = name,
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
        max_health = factor_mult(locomotive.max_health),

        -- VehiclePrototype
        braking_force = factor_mult(locomotive.braking_force),
        friction_force = factor_div(locomotive.friction_force),

        -- RollingStockPrototype
        max_speed = factor_mult(locomotive.max_speed),
        air_resistance = factor_div(locomotive.air_resistance),

        -- LocomotivePrototype
        max_power = (MAX_POWER * factor) .. 'kW',

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
-- there must be 10kJ * 20 = 200kJ buffer capacity, as the buffer refills
-- automatically through the buffer_flow_limit.
-- to refill 200kJ in one tick, it must be able to pull 12000kW

---@param index integer
---@param tier string
---@return data.ElectricEnergyInterfacePrototype
local function make_control_station(index, tier)
    local factor = const.tier_multipliers[index]
    local name = const.control_station_prefix .. index

    local names = mod_data.data.control_station[tier]
    names[#names + 1] = name

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
        name = name,

        -- ElectricEnergyInterfacePrototype
        energy_source = {
            type = 'electric',
            buffer_capacity = buffer_capacity_per_tick .. 'kJ',
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
            result = name,
        },
    }
end

---@param index integer
---@param tier string
---@return CargoWagonPrototype
local function make_cargo_wagon(index, tier)
    local factor = const.tier_multipliers[index]
    local factor_mult = mult_factor(factor)
    local factor_div = div_factor(factor)

    local name = const.cargo_wagon_prefix .. index

    local names = mod_data.data.cargo_wagon[tier]
    names[#names + 1] = name


    return meld(util.copy(cargo_wagon), {
        -- Prototype Base
        name = name,

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
            result = name,
        },

        -- EntityWithHealthPrototype
        max_health = factor_mult(cargo_wagon.max_health),

        -- VehiclePrototype
        braking_force = factor_mult(cargo_wagon.braking_force),
        friction_force = factor_div(cargo_wagon.friction_force),

        -- RollingStockPrototype
        weight = factor_mult(cargo_wagon.weight),
        max_speed = factor_mult(cargo_wagon.max_speed),
        air_resistance = factor_div(cargo_wagon.air_resistance),

        -- CargoWagonPrototype
        inventory_size = factor_mult(cargo_wagon.inventory_size),
        quality_affects_inventory_size = true,
    })
end

---@param index integer
---@param tier string
---@return data.FluidWagonPrototype
local function make_fluid_wagon(index, tier)
    local factor = const.tier_multipliers[index]
    local factor_mult = mult_factor(factor)
    local factor_div = div_factor(factor)

    local name = const.fluid_wagon_prefix .. index

    local names = mod_data.data.fluid_wagon[tier]
    names[#names + 1] = name

    return meld(util.copy(fluid_wagon), {
        -- Prototype Base
        name = name,

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
            result = name,
        },

        -- EntityWithHealthPrototype
        max_health = factor_mult(fluid_wagon.max_health),

        -- VehiclePrototype
        braking_force = factor_mult(fluid_wagon.braking_force),
        friction_force = factor_div(fluid_wagon.friction_force),

        -- RollingStockPrototype
        weight = factor_mult(fluid_wagon.weight),
        max_speed = factor_mult(fluid_wagon.max_speed),
        air_resistance = factor_div(fluid_wagon.air_resistance),

        -- FluidWagonPrototype
        capacity = factor_mult(fluid_wagon.capacity),
        quality_affects_capacity = true,
    })
end

function Entity:defaultEntities()
    data:extend {
        make_engine(1, 'base'),
        make_control_station(1, 'base'),
    }
end

function Entity:makeAdvancedEngines()
    data:extend {
        make_engine(2, 'advanced'),
        make_control_station(2, 'advanced'),

        make_engine(3, 'advanced'),
        make_control_station(3, 'advanced'),
    }
end

function Entity:makeCargoWagons()
    data:extend {
        make_cargo_wagon(2, 'advanced'),
        make_cargo_wagon(3, 'advanced'),
    }
end

function Entity:makeFluidWagons()
    data:extend {
        make_fluid_wagon(2, 'advanced'),
        make_fluid_wagon(3, 'advanced'),
    }
end

return Entity
