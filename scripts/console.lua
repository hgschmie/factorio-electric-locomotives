--------------------------------------------------------------------------------
-- custom commands
--------------------------------------------------------------------------------
assert(script)

local Event = require('stdlib.event.event')

local const = require('lib.constants')

--------------------------------------------------------------------------------

---@class elok.Console
local Console = {}

---@param player LuaPlayer?
---@param force  LuaForce?
local function print_research(player, force)
    force = assert(force or (player and player.force or nil))
    local speed_tier = This.Locomotive:determineTier(force.index, const.technology_speed_prefix)
    local acceleration_tier = This.Locomotive:determineTier(force.index, const.technology_acceleration_prefix)

    local output = player and player or game

    ---@type PrintSettings
    local print_settings = {
        skip = defines.print_skip.if_visible,
        sound = player and defines.print_sound.use_player_settings or defines.print_sound.never,
    }

    output.print({ const:locale('command_show_levels_speed'), speed_tier, ('%.2f'):format(const.speed_progression[speed_tier]) }, print_settings)
    output.print({ const:locale('command_show_levels_acceleration'), acceleration_tier, ('%.2f'):format(const.acceleration_progression[acceleration_tier]) }, print_settings)
end

---@param data CustomCommandData
local function show_levels(data)
    local player = data.player_index and game.players[data.player_index]

    if player then
        print_research(player)
    else
        for name, force in pairs(game.forces) do
            if name ~= 'enemy' and name ~= 'neutral' then
                game.print { const:locale('command_show_levels_force'), name }
                print_research(player, force)
            end
        end
    end
end

function Console:register_commands()
    commands.add_command('electric-locomotives-show-levels', { const:locale('command_show_levels') }, show_levels)
end

--------------------------------------------------------------------------------
-- mod init/load code
--------------------------------------------------------------------------------

local function on_init()
    Console:register_commands()
end

local function on_load()
    Console:register_commands()
end

Event.on_init(on_init)
Event.on_load(on_load)

return Console
