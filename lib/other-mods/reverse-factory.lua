--------------------------------------------------------------------------------
-- Reverse Factory support (untested)
--------------------------------------------------------------------------------

local const = require('lib.constants')

require('stdlib.utils.string')

local SUPPORTED_TYPES = {
    locomotive = const.locomotive_prefix,
    ['cargo-wagon'] = const.cargo_wagon_prefix,
    ['fluid-wagon'] = const.fluid_wagon_prefix,
}

return {
    data_updates = function()
        for _, item in pairs(data.raw['item-with-entity-data']) do
            for _, prefix in pairs(SUPPORTED_TYPES) do
                if item.name:starts_with(prefix) then
                    local recipe = data.raw['recipe'][item.name]
                    if recipe then
                        data:extend {
                            type = 'recipe',
                            name = 'rf-' .. item.name,
                            category = 'recycle',
                            hidden = true,
                            hidden_in_factoriopedia = true,
                            icon = item.icon,
                            subgroup = 'rf-multiple-outputs',
                            energy_required = 30,
                            ingredients = {
                                { name = item.name, type = 'item', amount = 1 },
                            },
                            results = recipe.ingredients,
                        }
                    end
                end
            end
        end
    end,
}
