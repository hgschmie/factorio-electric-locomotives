------------------------------------------------------------------------
-- data phase 3
------------------------------------------------------------------------

require('lib.init')

local const = require('lib.constants')

------------------------------------------------------------------------

local WAGON_TYPES = {
    'cargo-wagon',
    'fluid-wagon',
    'artillery-wagon',
    'infinity-cargo-wagon',
}

local unlock_max_speed = Framework.settings:startup_setting(const.settings_names.unlock_max_speed)

if unlock_max_speed then
    -- scales any entity that can run behind a regular locomotive at full speed
    -- to be able to run after the fastest electric locomotive and not slow the train down.
    -- Entities that either can not run at full speed or run faster than the fastest electric
    -- locomotive are not touched
    local locomotive = data.raw['locomotive']['locomotive']
    local max_speed_factor = locomotive.max_speed

    for idx = 1, 3 do
        local loco_prototype = data.raw['locomotive'][const.locomotive_prefix .. idx]
        if loco_prototype then max_speed_factor = math.max(max_speed_factor, loco_prototype.max_speed) end
    end

    for _, entity_type in pairs(WAGON_TYPES) do
        for _, entity in pairs(data.raw[entity_type]) do
            -- there are some entities that are slower than a regular locomotive (e.g. cargo ships).
            -- don't touch those, they will not be connected to a "regular" train.
            if entity.max_speed >= locomotive.max_speed then
                entity.max_speed = math.max(max_speed_factor, entity.max_speed)
            end
        end
    end
end

------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_data_final_fixes_stage()
