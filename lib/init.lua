----------------------------------------------------------------------------------------------------
--- Global definitions included in all phases
----------------------------------------------------------------------------------------------------

-- mod code
local this = require('lib.this')

-- Framework core
local framework = require('framework.init')
framework:init(this.framework_init)

if this.settings then
    framework.settings:add_defaults(this.settings)
end

---@diagnostic disable-next-line: unnecessary-if
if script then
    this.boot()
end

return function()
    return this, framework
end
