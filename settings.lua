------------------------------------------------------------------------
-- settings phase
------------------------------------------------------------------------

require('lib.init')

local const = require('lib.constants')

data:extend {
	{
		-- Debug mode (framework dependency)
		type = 'bool-setting',
		name = Framework.PREFIX .. 'debug-mode',
		order = 'az',
		setting_type = 'startup',
		default_value = false,
	},
	{
		type = 'bool-setting',
		name = const.settings.mk_train,
		setting_type = 'startup',
		default_value = true,
		order = 'a',
	},
	{
		type = 'bool-setting',
		name = const.settings.mk_cargo,
		setting_type = 'startup',
		default_value = true,
		order = 'b',
	},
	{
		type = 'bool-setting',
		name = const.settings.mk_fluid,
		setting_type = 'startup',
		default_value = true,
		order = 'c',
	},
}

------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_settings_stage()
