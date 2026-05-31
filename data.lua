------------------------------------------------------------------------
-- data phase 1
------------------------------------------------------------------------

require('lib.init')

require('prototypes.group')
-- entities must come before item because the loco consumption
-- is used by the fuel item definition
require('prototypes.entity')
require('prototypes.item')
local recipes = require('prototypes.recipe')
recipes:defaultRecipes()

local technology = require('prototypes.technology')
technology:defaultTechnology()


------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_data_stage()
