------------------------------------------------------------------------
-- data phase 1
------------------------------------------------------------------------

require('lib.init')

require("prototypes.entity")
require("prototypes.group")
require("prototypes.recipe")
require("prototypes.item")
require("prototypes.technology")

------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_data_stage()
