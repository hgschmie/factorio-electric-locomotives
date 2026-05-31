--------------------------------------------------------------------------------
-- Exclude from refueling API call
--------------------------------------------------------------------------------

local const = require('lib.constants')

---@param api_name string
local function exclude_locos(api_name)
    for _, loco_name in pairs(const.locomotive_names) do
        if remote.interfaces[api_name]['exclude_from_fuel_schedule'] then
            remote.call(api_name, 'exclude_from_fuel_schedule', loco_name)
        end
    end
end

local FuelTrainStop = {
    on_configuration_changed = exclude_locos,
}

return FuelTrainStop
