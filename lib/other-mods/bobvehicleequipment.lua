--------------------------------------------------------------------------------
-- Bob's Vehicle Equipment support (untested)
--------------------------------------------------------------------------------

local const = require('lib.constants')

require('stdlib.utils.string')

return {
    data_updates = function()
        if not settings.startup['bobmods-vehicleequipment-enablevehiclegrids'].value then return end

        for idx = 1, 3 do
            local postfix = (idx > 1) and ('-' .. idx) or ''
            local loco_prototype = data.raw['locomotive'][const.locomotive_prefix .. idx]
            if loco_prototype then loco_prototype.equipment_grid = 'bob-locomotive' .. postfix end

            local cargo_prototype = data.raw['cargo-wagon'][const.cargo_wagon_prefix .. idx]
            if cargo_prototype then cargo_prototype.equipment_grid = 'bob-cargo-wagon' .. postfix end
        end
    end,
}
