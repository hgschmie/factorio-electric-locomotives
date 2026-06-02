----------------------------------------------------------------------------------------------------
--- Initialize this mod's globals
----------------------------------------------------------------------------------------------------

-- must be before any other code
Framework.settings:add_defaults(require('lib.settings'))

---@class elok.Mod
---@field other_mods table<string, string>
---@field remote_apis table<string, string>
---@field Locomotive elok.LocomotiveControl
---@field ControlStation elok.ControlStation
local This = {
    other_mods = {
        ['bobvehicleequipment'] = 'bobvehicleequipment',
        ['MultipleUnitTrainControl'] = 'multiple-unit-train-control',

    },
    remote_apis = {
        FuelTrainStop = 'exclude-from-refuel',
        ['logistic-train-network'] = 'exclude-from-refuel',
    },
}

if (script) then
    This.Locomotive = require('scripts.locomotive')
    This.ControlStation = require('scripts.control-station')
end

----------------------------------------------------------------------------------------------------

------------------------------------------------------------------------
-- init setup
------------------------------------------------------------------------

--- Setup the global data structures
function This:init()
    assert(script)

    if storage.elok_data then return end

    ---@type elok.Storage
    storage.elok_data = {
        total_engine_count = 0,
        total_control_station_count = 0,
        surfaces = {},
    }
end

------------------------------------------------------------------------
-- Storage Management
------------------------------------------------------------------------

---@return elok.Storage
function This:storage()
    return assert(storage.elok_data)
end

---@param surface_index integer
---@return elok.Surface surface
---@return elok.Storage storage
function This:locateSurface(surface_index)
    local elok_storage = self:storage()

    elok_storage.surfaces[surface_index] = elok_storage.surfaces[surface_index] or {
        engines = {},
        power_sources = {},
    }

    return elok_storage.surfaces[surface_index], elok_storage
end

return This
