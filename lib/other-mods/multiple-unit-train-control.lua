--------------------------------------------------------------------------------
-- Multiple Unit Train Control (untested)
--------------------------------------------------------------------------------

local const = require('lib.constants')

require('stdlib.utils.string')
local table = require('stdlib.utils.table')

return {
    data_final_fixes = function()
        -- add a '-mu' variant for each electric locomotive to the
        -- set of known locomotives. This will ensure that they get
        -- continously refueled by the control stations. The actual
        -- entities are added by the MultipleUnitTrainControl mod.

        local mod_data = assert(data.raw['mod-data'][const.name])
        ---@type elok.Names
        local loco_data = assert(mod_data.data.locomotive)

        for type_name, types in pairs(loco_data) do
            local mu_names = {}
            for _, name in pairs(types) do
                if not name:ends_with('-mu') then
                    mu_names[#mu_names + 1] = name .. '-mu'
                end
            end
            loco_data[type_name] = table.array_combine(types, mu_names)
        end
    end,
}
