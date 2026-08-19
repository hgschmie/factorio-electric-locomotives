----------------------------------------------------------------------------------------------------
--- Initialize this mod's globals
----------------------------------------------------------------------------------------------------

local const = require('lib.constants')

---@class elok.Mod
---@field other_mods table<string, string>
---@field remote_apis table<string, string>
---@field settings ff2.ModSettings
---@field Locomotive elok.LocomotiveControl
---@field ControlStation elok.ControlStation
---@field Console elok.Console
local This = {
    other_mods = {
        ['bobvehicleequipment'] = 'bobvehicleequipment',
        ['MultipleUnitTrainControl'] = 'multiple-unit-train-control',

    },
    remote_apis = {
        FuelTrainStop = 'exclude-from-refuel',
        ['logistic-train-network'] = 'exclude-from-refuel',
    },
    settings = require('lib.settings'),
}

function This.boot()
    This.Locomotive = require('scripts.locomotive')
    This.ControlStation = require('scripts.control-station')
    This.Console = require('scripts.console')
end

--------------------------------------------------------------------------------
-- Framework intializer
--------------------------------------------------------------------------------

---@return FrameworkConfig config
function This.framework_init()
    return {
        -- prefix is the internal mod prefix
        prefix = const.prefix,
        -- prefix for log messages
        log_prefix = const.log_prefix,
        -- name is a human readable name
        name = const.name,
        -- The filesystem root.
        root = const.root,
    }
end

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
