--------------------------------------------------------------------------------
-- custom commands
--------------------------------------------------------------------------------
assert(script)

local Event = require('stdlib.event.event')

local const = require('lib.constants')

--------------------------------------------------------------------------------

---@class elok.Console
local Console = {}

---@param data CustomCommandData
---@param force LuaForce
local function print_research(data, force)
    local speed_tier = This.Locomotive:determineTier(force.index, const.technology_speed_prefix)
    local acceleration_tier = This.Locomotive:determineTier(force.index, const.technology_acceleration_prefix)

    Framework.logger.console(function()
        return { const:locale('command_show_levels_speed'), speed_tier, ('%.2f'):format(const.speed_progression[speed_tier]) }
    end, data)
    Framework.logger.console(function()
        return { const:locale('command_show_levels_acceleration'), acceleration_tier, ('%.2f'):format(const.acceleration_progression[acceleration_tier]) }
    end, data)
end

---@param data CustomCommandData
local function show_levels(data)
    if data.player_index then
        local player = game.get_player(data.player_index)
        if not player then return end
        print_research(data, player.force)
    else
        for name, force in pairs(game.forces) do
            if name ~= 'enemy' and name ~= 'neutral' then
                Framework.logger.console(function()
                    return { const:locale('command_show_levels_force'), name }
                end, data)
                print_research(data, force)
            end
        end
    end
end

function Console.register_commands()
    commands.add_command('electric-locomotives-show-levels', { const:locale('command_show_levels') }, show_levels)
end

--------------------------------------------------------------------------------
-- mod init/load code
--------------------------------------------------------------------------------

local function on_init()
    Console.register_commands()
end

local function on_load()
    Console.register_commands()
end

Event.on_init(on_init)
Event.on_load(on_load)

return Console
