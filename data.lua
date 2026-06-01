------------------------------------------------------------------------
-- data phase 1
------------------------------------------------------------------------

require('lib.init')

local const = require('lib.constants')

require('prototypes.group')
-- entities must come before item because the loco consumption
-- is used by the fuel item definition
local entity = require('prototypes.entity')
local item = require('prototypes.item')
local recipes = require('prototypes.recipe')
local technology = require('prototypes.technology')

entity:defaultEntities()
item:defaultEntities()
recipes:defaultRecipes()
technology:defaultTechnology()

local mk_engines = Framework.settings:startup_setting(const.settings_names.enable_train)
local mk_cargo = Framework.settings:startup_setting(const.settings_names.enable_cargo)
local mk_fluid = Framework.settings:startup_setting(const.settings_names.enable_fluid)

if mk_engines then
    entity:makeAdvancedEngines()
    item:makeAdvancedEngines()
    recipes:unlockAdvancedEngines()
end

if mk_cargo then
    entity:makeCargoWagons()
    item:makeCargoWagons()
    recipes:unlockCargoWagons()
end

if mk_fluid then
    entity:makeFluidWagons()
    item:makeFluidWagons()
    recipes:unlockFluidWagons()
end

technology:unlockAdvancedTiers(mk_engines, mk_cargo, mk_fluid)

------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_data_stage()
