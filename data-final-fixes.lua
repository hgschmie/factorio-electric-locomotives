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

-- function UpdateMUControl(train,mu_power)	
-- 	local power = format_number(train.max_power)	
-- 	local energy = power * 1.1

-- 	mu_power.icon = train.icon
-- 	mu_power.localised_name = {"entity-name." .. train.name}
-- 	mu_power.energy_source =
-- 	{
-- 		type = "electric",
-- 		buffer_capacity = (energy * 2) .. "J",
-- 		usage_priority = "secondary-input",
-- 		input_flow_limit = energy .. "J" ,
-- 		drain = power / 10 .. "J" ,
-- 		render_no_network_icon = false,
-- 		render_no_power_icon = false
-- 	}
-- end

-- if mods['MultipleUnitTrainControl'] then
-- 	UpdateMUControl(data.raw['locomotive']['et-electric-locomotive-1-mu'],data.raw['electric-energy-interface']['et-electric-locomotive-1-mu-power'])	
-- 	UpdateMUControl(data.raw['locomotive']['et-electric-locomotive-2-mu'],data.raw['electric-energy-interface']['et-electric-locomotive-2-mu-power'])
-- 	UpdateMUControl(data.raw['locomotive']['et-electric-locomotive-3-mu'],data.raw['electric-energy-interface']['et-electric-locomotive-3-mu-power'])
-- end

------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_data_final_fixes_stage()
