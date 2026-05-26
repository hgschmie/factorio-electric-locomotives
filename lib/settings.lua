------------------------------------------------------------------------
-- mod settings
------------------------------------------------------------------------

local const = require('lib.constants')

---@type table<FrameworkSettings.name, FrameworkSettingsGroup>
local Settings = {
    startup = {
        [const.settings_names.mk_train] = {
            key = const.settings.mk_train,
            value = true
        },
        [const.settings_names.mk_cargo] = {
            key = const.settings.mk_cargo,
            value = true
        },
        [const.settings_names.mk_fluid] = {
            key = const.settings.mk_fluid,
            value = true
        },
    }
}

return Settings
