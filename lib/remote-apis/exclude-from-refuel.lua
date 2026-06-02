--------------------------------------------------------------------------------
-- Exclude from refueling API call
--------------------------------------------------------------------------------

local const = require('lib.constants')

---@param api_name string
local function exclude_locos(api_name)
    if remote.interfaces[api_name]['exclude_from_fuel_schedule'] then
        for _, loco_name in pairs(const.getLocomotiveNames()) do
            remote.call(api_name, 'exclude_from_fuel_schedule', loco_name)
        end
    end
end

local FuelTrainStop = {
    on_configuration_changed = exclude_locos,
}

return FuelTrainStop
