------------------------------------------------------------------------
-- mod constant definitions.
--
-- can be loaded into scripts and data
------------------------------------------------------------------------

local util = require('util')
local table = require('stdlib.utils.table')

--------------------------------------------------------------------------------
-- main constants
--------------------------------------------------------------------------------

local Constants = {
    prefix = 'hps__elok-',
    name = 'electric-locomotives',
    root = '__electric-locomotives__',
}

Constants.gfx_location = Constants.root .. '/graphics/'

--------------------------------------------------------------------------------
-- Framework intializer
--------------------------------------------------------------------------------

---@return FrameworkConfig config
function Constants.framework_init()
    return {
        -- prefix is the internal mod prefix
        prefix = Constants.prefix,
        -- name is a human readable name
        name = Constants.name,
        -- The filesystem root.
        root = Constants.root,
    }
end

--------------------------------------------------------------------------------
-- Path and name helpers
--------------------------------------------------------------------------------

---@param value string
---@return string result
function Constants:with_prefix(value)
    return self.prefix .. value
end

---@param path string
---@return string result
function Constants:png(path)
    return self.gfx_location .. path .. '.png'
end

---@param id string
---@return string result
function Constants:locale(id)
    return Constants:with_prefix('locale.') .. id
end

--------------------------------------------------------------------------------
-- settings
--------------------------------------------------------------------------------

Constants.settings_keys = {
    'enable_train',
    'enable_cargo',
    'enable_fluid',
    'show_icons',
    'tick_interval',
    'engines_per_control_station',
    'unlock_max_speed',
}

Constants.settings_names = {}
Constants.settings = {}

for _, key in pairs(Constants.settings_keys) do
    Constants.settings_names[key] = key
    Constants.settings[key] = Constants:with_prefix(key)
end

--------------------------------------------------------------------------------
-- entity names and maps
--------------------------------------------------------------------------------

-- Base name
Constants.elok_name = Constants:with_prefix(Constants.name)

Constants.locomotive_prefix = 'et-electric-locomotive-'
Constants.cargo_wagon_prefix = 'et-cargo-wagon-'
Constants.fluid_wagon_prefix = 'et-fluid-wagon-'
Constants.control_station_prefix = 'et-control-station-'
Constants.fuel_prefix = 'et-electric-fuel-'
Constants.technology_prefix = 'et-electric-railway-'

local cache = {}

---@class elok.MakeNamesArgs
---@field name string
---@field enable_advanced fun(): boolean

---@param args elok.MakeNamesArgs
local function make_names(args)
    ---@type table<string, elok.Names>
    local mod_data = assert(prototypes.mod_data[Constants.name]).data
    local data = assert(mod_data[args.name])

    return function()
        if cache[args.name] then return cache[args.name] end

        local names = util.copy(data.base)

        if args.enable_advanced() then
            names = table.array_combine(names, data.advanced)
        end

        cache[args.name] = names
        return names
    end
end

if script then
    -- methods are only available at runtime as the values are
    -- controlled by enabled technologies etc.

    Constants.getLocomotiveNames = make_names {
        name = 'locomotive',
        enable_advanced = function() return Framework.settings:startup_setting(Constants.settings_names.enable_train) end,
    }

    Constants.getControlStationNames = make_names {
        name = 'control_station',
        enable_advanced = function() return Framework.settings:startup_setting(Constants.settings_names.enable_train) end,
    }

    Constants.getCargoWagonNames = make_names {
        name = 'cargo_wagon',
        enable_advanced = function() return Framework.settings:startup_setting(Constants.settings_names.enable_cargo) end,
    }

    Constants.getFluidWagonNames = make_names {
        name = 'fluid_wagon',
        enable_advanced = function() return Framework.settings:startup_setting(Constants.settings_names.enable_fluid) end,
    }

    Constants.getTechnologyNames = make_names {
        name = 'technology',
        enable_advanced = function()
            return Framework.settings:startup_setting(Constants.settings_names.enable_train)
                or Framework.settings:startup_setting(Constants.settings_names.enable_cargo)
                or Framework.settings:startup_setting(Constants.settings_names.enable_fluid)
        end,
    }
end

Constants.tier_multipliers = {
    1, 1.5, 2,
}

Constants.tier_tint = {
    { 0.7, 0.3, 0.3, 1 },
    { 0.7, 0.7, 0.3, 1 },
    { 0.3, 0.7, 0.3, 1 },
}

return Constants
