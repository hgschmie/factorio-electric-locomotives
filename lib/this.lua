----------------------------------------------------------------------------------------------------
--- Initialize this mod's globals
----------------------------------------------------------------------------------------------------

---@class lse.Mod
---@field other_mods table<string, string>
---@field Lse lse.Lse?
---@field Elevator lse.SpaceElevator?
---@field Gui lse.Gui?
local This = {
    other_mods = {
        LogisticTrainNetwork = 'ltn',
        ['space-exploration'] = 'se',
    },
}

if (script) then
    This.Lse = require('scripts.lse')
    This.Elevator = require('scripts.elevator')
    This.Gui = require('scripts.gui')
end

----------------------------------------------------------------------------------------------------

------------------------------------------------------------------------
-- init setup
------------------------------------------------------------------------

--- Setup the global data structures
function This:init()
    if storage.lse_data then return end

    ---@type lse.Storage
    storage.lse_data = {
        known_stops = {},
        elevators = {},
    }
end

------------------------------------------------------------------------
-- Storage Management
------------------------------------------------------------------------

---@return lse.Storage
function This:storage()
    return assert(storage.lse_data)
end

Framework.settings:add_defaults(require('lib.settings'))

return This
