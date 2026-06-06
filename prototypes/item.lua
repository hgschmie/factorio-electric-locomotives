------------------------------------------------------------------------
-- items
------------------------------------------------------------------------

local util = require('util')
local meld = require('meld')

local const = require('lib.constants')

local locomotive = data.raw['item-with-entity-data']['locomotive']
local cargo_wagon = data.raw['item-with-entity-data']['cargo-wagon']
local fluid_wagon = data.raw['item-with-entity-data']['fluid-wagon']

-- how many ticks must a control station support
local TICK_FACTOR = Framework.settings:startup_setting(const.settings_names.tick_interval)

-- At full acceleration, a type 1 loco burns 10kJ per tick
-- a fuel item lasts ~ 20 ticks before refuel, so if it runs out of
-- fuel, it will decelerate and stop within 1/3 of a second.
local TICKS_PER_FUEL = 4 * TICK_FACTOR

local function make_engine(index)
    return meld(util.copy(locomotive), {
        name = const.locomotive_prefix .. index,
        icon = meld.delete(),
        icon_size = meld.delete(),
        icons = {
            {
                icon = const:png('item/locomotive'),
                icon_size = 64,
                tint = const.tier_tint[index],
            },
        },
        subgroup = 'train-transport',
        order = 'c[rolling-stock]-a[locomotive]-' .. index,
        place_result = const.locomotive_prefix .. index,
    })
end

local function make_cargo_wagon(index)
    return meld(util.copy(cargo_wagon), {
        name = const.cargo_wagon_prefix .. index,
        icon = meld.delete(),
        icon_size = meld.delete(),
        icons = {
            {
                icon = const:png('item/cargo-wagon'),
                icon_size = 64,
                tint = const.tier_tint[index],
            },
        },
        subgroup = 'train-transport',
        order = 'c[rolling-stock]-b[cargo-wagon]-' .. index,
        place_result = const.cargo_wagon_prefix .. index,
    })
end

local function make_fluid_wagon(index)
    return meld(util.copy(fluid_wagon), {
        name = const.fluid_wagon_prefix .. index,
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
        place_result = const.fluid_wagon_prefix .. index,
    })
end

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
    icon_size = 64,
    subgroup = 'electric-railway',
    order = 'a[electric-railway]-b[et-current-collector]-1',
    stack_size = 50,
}

---@param index integer
---@param speed_tier integer
---@param acceleration_tier integer
local function make_fuel(index, speed_tier, acceleration_tier)
    local factor = const.tier_multipliers[index]

    local speed_factor = speed_tier and const.speed_progression[speed_tier]
    local acceleration_factor = acceleration_tier and const.acceleration_progression[acceleration_tier]

    local name = const:fuel_name {
        tier = index,
        speed_tier = speed_tier,
        acceleration_tier = acceleration_tier,
    }

    ---@type data.ItemPrototype
    return {
        --- PrototypeBase
        type = 'item',
        name = name,
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
        fuel_value = (loco_consumption_per_tick * factor * TICKS_PER_FUEL) .. 'kJ',
        fuel_top_speed_multiplier = speed_factor,
        fuel_acceleration_multiplier = acceleration_factor,
    }
end

local function make_control_station(index)
    return meld(util.copy(data.raw['item']['small-lamp']), {
        --- PrototypeBase
        type = 'item',
        name = const.control_station_prefix .. index,

        --- ItemPrototype
        stack_size = 10,
        icon = const:png('item/control-station-' .. index),
        icon_size = 64,
        subgroup = 'electric-railway',
        order = 'a[electric-railway]-a[et-control-station]-' .. index,
        place_result = const.control_station_prefix .. index,
    })
end

local Item = {}

function Item:defaultEntities()
    data:extend {
        et_fuel_category,
        current_collector,

        make_engine(1),
        make_control_station(1),
    }

    local fuel = {}

    for speed_tier = 0, #const.speed_progression do
        for acceleration_tier = 0, #const.acceleration_progression do
            fuel[#fuel + 1] = make_fuel(1, speed_tier, acceleration_tier)
        end
    end
    data:extend(fuel)
end

function Item:makeAdvancedEngines()
    for idx = 2, 3 do
        data:extend {
            make_engine(idx),
            make_control_station(idx),
        }

        local fuel = {}
        for speed_tier = 0, #const.speed_progression do
            for acceleration_tier = 0, #const.acceleration_progression do
                fuel[#fuel + 1] = make_fuel(idx, speed_tier, acceleration_tier)
            end
        end
        data:extend(fuel)
    end
end

function Item:makeCargoWagons()
    data:extend {
        make_cargo_wagon(2),
        make_cargo_wagon(3),
    }
end

function Item:makeFluidWagons()
    data:extend {
        make_fluid_wagon(2),
        make_fluid_wagon(3),
    }
end

return Item
