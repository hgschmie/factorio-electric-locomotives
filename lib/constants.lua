------------------------------------------------------------------------
-- mod constant definitions.
--
-- can be loaded into scripts and data
------------------------------------------------------------------------

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
        -- remote API
        remote_name = Constants.lse_name,
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
-- entity names and maps
--------------------------------------------------------------------------------

-- Base name
Constants.elok_name = Constants:with_prefix(Constants.name)

Constants.locomotive_names = {
    'et-electric-locomotive-1',
    'et-electric-locomotive-2',
    'et-electric-locomotive-3',
}

Constants.cargo_wagon_names = {
    'et-cargo-wagon-1',
    'et-cargo-wagon-2',
    'et-cargo-wagon-3',
}

Constants.fluid_wagon_names = {
    'et-fluid-wagon-1',
    'et-fluid-wagon-2',
    'et-fluid-wagon-3',
}

Constants.tier_multipliers = {
    1, 1.5, 2
}

Constants.tier_tint = {
    { 0.7, 0.3, 0.3, 1},
    { 0.7, 0.7, 0.3, 1},
    { 0.3, 0.7, 0.3, 1},
}

Constants.fuel_names = {
    'et-electric-fuel-1',
    'et-electric-fuel-2',
    'et-electric-fuel-3',
}

Constants.technology_names = {
    'et-electric-railway-1',
    'et-electric-railway-2',
    'et-electric-railway-3',
    'et-cargo-wagon-2',
    'et-cargo-wagon-3',
    'et-fluid-wagon-2',
    'et-fluid-wagon-3',
}

Constants.control_station_names = {
    'et-control-station-1',
    'et-control-station-2',
    'et-control-station-3',
}

--------------------------------------------------------------------------------
-- settings
--------------------------------------------------------------------------------

Constants.settings_keys = {
    'enable_train',
    'enable_cargo',
    'enable_fluid',
    'show_icons',
    'tick_interval',
}

Constants.settings_names = {}
Constants.settings = {}

for _, key in pairs(Constants.settings_keys) do
    Constants.settings_names[key] = key
    Constants.settings[key] = Constants:with_prefix(key)
end

return Constants
