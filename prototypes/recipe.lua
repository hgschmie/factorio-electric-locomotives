------------------------------------------------------------------------
-- recipes
------------------------------------------------------------------------

local const = require('lib.constants')

local Recipes = {}

function Recipes:defaultRecipes()
    local electric_locomotive_1 = {
        type = 'recipe',
        name = const.locomotive_prefix .. '1',
        enabled = false,
        ingredients = {
            { type = 'item', name = 'locomotive', amount = 1 },
            { type = 'item', name = 'et-current-collector', amount = 2 },
            { type = 'item', name = 'battery', amount = 10 },
            { type = 'item', name = 'electric-engine-unit', amount = 10 },
        },
        results = {
            { type = 'item', name = const.locomotive_prefix .. '1', amount = 1 },
        },
    }

    local control_station_1 = {
        type = 'recipe',
        name = const.control_station_prefix .. '1',
        enabled = false,
        ingredients = {
            { type = 'item', name = 'electronic-circuit', amount = 20 },
            { type = 'item', name = 'advanced-circuit', amount = 20 },
            { type = 'item', name = 'steel-plate', amount = 10 },
            { type = 'item', name = 'copper-cable', amount = 10 },
        },
        results = {
            { type = 'item', name = const.control_station_prefix .. '1', amount = 1 },
        },
    }

    local current_collector = {
        type = 'recipe',
        name = 'et-current-collector',
        enabled = false,
        ingredients = {
            { type = 'item', name = 'low-density-structure', amount = 10 },
            { type = 'item', name = 'copper-cable', amount = 5 },
            { type = 'item', name = 'iron-plate', amount = 2 },
        },
        results = {
            { type = 'item', name = 'et-current-collector', amount = 1 },
        },
    }

    data:extend {
        electric_locomotive_1,
        control_station_1,
        current_collector,
    }
end

function Recipes:unlockAdvancedEngines()
    local electric_locomotive_2 = {
        type = 'recipe',
        name = const.locomotive_prefix .. '2',
        enabled = false,
        ingredients = {
            { type = 'item', name = const.locomotive_prefix .. '1', amount = 1 },
            { type = 'item', name = 'low-density-structure', amount = 10 },
            { type = 'item', name = 'electric-engine-unit', amount = 10 },
            { type = 'item', name = 'advanced-circuit', amount = 10 },
        },
        results = {
            { type = 'item', name = const.locomotive_prefix .. '2', amount = 1 },
        },
    }

    local control_station_2 = {
        type = 'recipe',
        name = const.control_station_prefix .. '2',
        enabled = false,
        ingredients = {
            { type = 'item', name = const.control_station_prefix .. '1', amount = 2 },
            { type = 'item', name = 'electronic-circuit', amount = 20 },
            { type = 'item', name = 'advanced-circuit', amount = 20 },
            { type = 'item', name = 'steel-plate', amount = 10 },
            { type = 'item', name = 'copper-cable', amount = 10 },
        },
        results = {
            { type = 'item', name = const.control_station_prefix .. '2', amount = 1 },
        },
    }

    local electric_locomotive_3 = {
        type = 'recipe',
        name = const.locomotive_prefix .. '3',
        enabled = false,
        ingredients = {
            { type = 'item', name = const.locomotive_prefix .. '2', amount = 1 },
            { type = 'item', name = 'low-density-structure', amount = 10 },
            { type = 'item', name = 'electric-engine-unit', amount = 10 },
            { type = 'item', name = 'processing-unit', amount = 10 },
        },
        results = {
            { type = 'item', name = const.locomotive_prefix .. '3', amount = 1 },
        },
    }

    local control_station_3 = {
        type = 'recipe',
        name = const.control_station_prefix .. '3',
        enabled = false,
        ingredients = {
            { type = 'item', name = const.control_station_prefix .. '2', amount = 2 },
            { type = 'item', name = 'processing-unit', amount = 20 },
            { type = 'item', name = 'steel-plate', amount = 10 },
            { type = 'item', name = 'copper-cable', amount = 10 },
        },
        results = {
            { type = 'item', name = const.control_station_prefix .. '3', amount = 1 },
        },
    }



    data:extend {
        electric_locomotive_2,
        control_station_2,

        electric_locomotive_3,
        control_station_3,
    }
end

function Recipes:unlockCargoWagons()
    local cargo_wagon_2 = {
        type = 'recipe',
        name = const.cargo_wagon_prefix .. '2',
        enabled = false,
        ingredients = {
            { type = 'item', name = 'cargo-wagon', amount = 1 },
            { type = 'item', name = 'iron-gear-wheel', amount = 20 },
            { type = 'item', name = 'steel-plate', amount = 20 },
            { type = 'item', name = 'low-density-structure', amount = 10 },
        },
        results = {
            { type = 'item', name = const.cargo_wagon_prefix .. '2', amount = 1 },
        },
    }

    local cargo_wagon_3 = {
        type = 'recipe',
        name = const.cargo_wagon_prefix .. '3',
        enabled = false,
        ingredients = {
            { type = 'item', name = const.cargo_wagon_prefix .. '2', amount = 1 },
            { type = 'item', name = 'iron-gear-wheel', amount = 20 },
            { type = 'item', name = 'steel-plate', amount = 20 },
            { type = 'item', name = 'low-density-structure', amount = 10 },
        },
        results = {
            { type = 'item', name = const.cargo_wagon_prefix .. '3', amount = 1 },
        },
    }

    data:extend {
        cargo_wagon_2,
        cargo_wagon_3,
    }
end

function Recipes:unlockFluidWagons()
    local fluid_wagon_2 = {
        type = 'recipe',
        name = const.fluid_wagon_prefix .. '2',
        enabled = false,
        ingredients = {
            { type = 'item', name = 'fluid-wagon', amount = 1 },
            { type = 'item', name = 'iron-gear-wheel', amount = 10 },
            { type = 'item', name = 'steel-plate', amount = 16 },
            { type = 'item', name = 'pipe', amount = 8 },
            { type = 'item', name = 'storage-tank', amount = 1 },
            { type = 'item', name = 'low-density-structure', amount = 10 },
        },
        results = {
            { type = 'item', name = const.fluid_wagon_prefix .. '2', amount = 1 },
        },
    }

    local fluid_wagon_3 = {
        type = 'recipe',
        name = const.fluid_wagon_prefix .. '3',
        enabled = false,
        ingredients = {
            { type = 'item', name = const.fluid_wagon_prefix .. '2', amount = 1 },
            { type = 'item', name = 'iron-gear-wheel', amount = 10 },
            { type = 'item', name = 'steel-plate', amount = 16 },
            { type = 'item', name = 'pipe', amount = 8 },
            { type = 'item', name = 'storage-tank', amount = 1 },
            { type = 'item', name = 'low-density-structure', amount = 10 },
        },
        results = {
            { type = 'item', name = const.fluid_wagon_prefix .. '3', amount = 1 },
        },
    }

    data:extend {
        fluid_wagon_2,
        fluid_wagon_3,
    }
end

return Recipes
