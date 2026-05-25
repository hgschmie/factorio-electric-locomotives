data:extend(
{
    {
        type = "recipe",
        name = "et-electric-locomotive-1",
        enabled = false,
        ingredients = {
            {type = "item", name = "locomotive", amount = 1},
            {type = "item", name = "et-current-collector", amount = 2},
            {type = "item", name = "battery", amount = 10},
            {type = "item", name = "electric-engine-unit", amount = 10}
        },
        results = {
            {type = "item", name = "et-electric-locomotive-1", amount = 1}
        }
    },

    {
        type = "recipe",
        name = "et-control-station-1",
        enabled = false,
        ingredients = {
            {type = "item", name = "electronic-circuit", amount = 20},
            {type = "item", name = "advanced-circuit", amount = 20},
            {type = "item", name = "steel-plate", amount = 10},
            {type = "item", name = "copper-cable", amount = 10}
        },
        results = {
            {type = "item", name = "et-control-station-1", amount = 1}
        }
    },

    {
        type = "recipe",
        name = "et-current-collector",
        enabled = false,
        ingredients = {
            {type = "item", name = "low-density-structure", amount = 10},
            {type = "item", name = "copper-cable", amount = 5},
            {type = "item", name = "iron-plate", amount = 2}
        },
        results = {
            {type = "item", name = "et-current-collector", amount = 1}
        }
    }
})

function UnlockTrainRecipe()
    data:extend(
    {
        {
            type = "recipe",
            name = "et-electric-locomotive-2",
            enabled = false,
            ingredients = {
                {type = "item", name = "et-electric-locomotive-1", amount = 1},
                {type = "item", name = "low-density-structure", amount = 10},
                {type = "item", name = "electric-engine-unit", amount = 10},
                {type = "item", name = "advanced-circuit", amount = 10}
            },
            results = {
                {type = "item", name = "et-electric-locomotive-2", amount = 1}
            }
        },

        {
            type = "recipe",
            name = "et-electric-locomotive-3",
            enabled = false,
            ingredients = {
                {type = "item", name = "et-electric-locomotive-2", amount = 1},
                {type = "item", name = "low-density-structure", amount = 10},
                {type = "item", name = "electric-engine-unit", amount = 10},
                {type = "item", name = "processing-unit", amount = 10}
            },
            results = {
                {type = "item", name = "et-electric-locomotive-3", amount = 1}
            }
        }
    })
end

function UnlockCargoRecipe()
    data:extend(
    {
        {
            type = "recipe",
            name = "et-cargo-wagon-2",
            enabled = false,
            ingredients = {
                {type = "item", name = "cargo-wagon", amount = 1},
                {type = "item", name = "iron-gear-wheel", amount = 20},
                {type = "item", name = "steel-plate", amount = 20},
                {type = "item", name = "low-density-structure", amount = 10}
            },
            results = {
                {type = "item", name = "et-cargo-wagon-2", amount = 1}
            }
        },

        {
            type = "recipe",
            name = "et-cargo-wagon-3",
            enabled = false,
            ingredients = {
                {type = "item", name = "et-cargo-wagon-2", amount = 1},
                {type = "item", name = "iron-gear-wheel", amount = 20},
                {type = "item", name = "steel-plate", amount = 20},
                {type = "item", name = "low-density-structure", amount = 10}
            },
            results = {
                {type = "item", name = "et-cargo-wagon-3", amount = 1}
            }
        }
    })
end

function UnlockFluidRecipe()
    data:extend(
    {
        {
            type = "recipe",
            name = "et-fluid-wagon-2",
            enabled = false,
            ingredients = {
                {type = "item", name = "fluid-wagon", amount = 1},
                {type = "item", name = "iron-gear-wheel", amount = 10},
                {type = "item", name = "steel-plate", amount = 16},
                {type = "item", name = "pipe", amount = 8},
                {type = "item", name = "storage-tank", amount = 1},
                {type = "item", name = "low-density-structure", amount = 10}
            },
            results = {
                {type = "item", name = "et-fluid-wagon-2", amount = 1}
            }
        },

        {
            type = "recipe",
            name = "et-fluid-wagon-3",
            enabled = false,
            ingredients = {
                {type = "item", name = "et-fluid-wagon-2", amount = 1},
                {type = "item", name = "iron-gear-wheel", amount = 10},
                {type = "item", name = "steel-plate", amount = 16},
                {type = "item", name = "pipe", amount = 8},
                {type = "item", name = "storage-tank", amount = 1},
                {type = "item", name = "low-density-structure", amount = 10}
            },
            results = {
                {type = "item", name = "et-fluid-wagon-3", amount = 1}
            }
        }
    })
end