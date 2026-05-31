------------------------------------------------------------------------
-- mod settings
------------------------------------------------------------------------

local const = require('lib.constants')

---@type table<FrameworkSettings.name, FrameworkSettingsGroup>
local Settings = {
    startup = {
        [const.settings_names.enable_train] = {
            key = const.settings.enable_train,
            value = true
        },
        [const.settings_names.enable_cargo] = {
            key = const.settings.enable_cargo,
            value = true
        },
        [const.settings_names.enable_fluid] = {
            key = const.settings.enable_fluid,
            value = true
        },
        [const.settings_names.show_icons] = {
            key = const.settings.show_icons,
            value = true
        },
        [const.settings_names.tick_interval] = {
            key = const.settings.tick_interval,
            value = 5
        },
        [const.settings_names.engines_per_control_station] = {
            key = const.settings.engines_per_control_station,
            value = 20
        },
    }
}

return Settings
