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
		name = const.settings.enable_train,
		setting_type = 'startup',
		default_value = true,
		order = 'aa',
	},
	{
		type = 'bool-setting',
		name = const.settings.enable_cargo,
		setting_type = 'startup',
		default_value = false,
		order = 'ab',
	},
	{
		type = 'bool-setting',
		name = const.settings.enable_fluid,
		setting_type = 'startup',
		default_value = false,
		order = 'ac',
	},
	{
		type = 'bool-setting',
		name = const.settings.show_icons,
		setting_type = 'startup',
		default_value = true,
		order = 'ad',
	},
	{
		type = 'int-setting',
		name = const.settings.tick_interval,
		setting_type = 'startup',
		default_value = 5,
		minimum_value = 2,
		maximum_value = 60,
		order = 'ae',
	},
	{
		type = 'int-setting',
		name = const.settings.engines_per_control_station,
		setting_type = 'startup',
		default_value = 20,
		minimum_value = 2,
		maximum_value = 1000,
		order = 'af',
	},
}

------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_settings_stage()
