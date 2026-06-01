------------------------------------------------------------------------
-- mod-data
------------------------------------------------------------------------

local const = require('lib.constants')

data:extend {
    {
        type = 'mod-data',
        name = const.name,
        data_type = const.name,
        ---@type table<string, elok.Names>
        data = {
            locomotive = {
                base = {},
                advanced = {},
            },
            control_station = {
                base = {},
                advanced = {},
            },
            cargo_wagon = {
                base = {},
                advanced = {},
            },
            fluid_wagon = {
                base = {},
                advanced = {},
            },
            technology = {
                base = {},
                advanced = {},
            },
        },
    },
}
