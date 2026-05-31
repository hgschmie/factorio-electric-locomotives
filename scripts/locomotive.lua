------------------------------------------------------------------------
-- Locomotive related code
------------------------------------------------------------------------

local util = require('util')

local ticker = require('framework.ticker')

local const = require('lib.constants')

assert(script)

---@class elok.LocomotiveControl
---@field show_icons boolean
local Locomotive = {
    show_icons = Framework.settings:startup_setting(const.settings_names.show_icons),
}

---@param engine elok.Engine
---@param x number
---@param y number
---@param sprite SpritePath
local function render_sprite(engine, x, y, sprite)
    engine.sprites[#engine.sprites + 1] = rendering.draw_sprite {
        sprite = 'utility.entity_info_dark_background',
        surface = engine.entity.surface,
        target = {
            entity = engine.entity,
            offset = util.by_pixel(x, y),
        },
        x_scale = 0.75,
        y_scale = 0.75,
        only_in_alt_mode = not Locomotive.show_icons,
    }

    engine.sprites[#engine.sprites + 1] = rendering.draw_sprite {
        sprite = sprite,
        target = {
            entity = engine.entity,
            offset = util.by_pixel(x, y),
        },
        surface = engine.entity.surface,
        x_scale = 0.80,
        y_scale = 0.80,
        only_in_alt_mode = not Locomotive.show_icons,
    }
end

---@param entity LuaEntity
function Locomotive:createLocomotive(entity)
    local surface = This:locateSurface(entity.surface_index)

    local engine_tier = tonumber(entity.name:sub(entity.name:find('%d')))

    -- assign the right fuel
    entity.burner.currently_burning = assert(prototypes.item[const.fuel_names[engine_tier]])

    ---@type elok.Engine
    local engine = {
        entity = entity,
        sprites = {},
    }

    surface.engines[entity.unit_number] = engine

    render_sprite(engine, -12, -56, 'virtual-signal/signal-lightning')
    render_sprite(engine, 12, -56, 'virtual-signal/signal-' .. engine_tier)

    self:refuel(engine)
end

---@param engine LuaEntity
function Locomotive:destroyLocomotive(engine)
    local surface = This:locateSurface(engine.surface_index)

    for _, sprite in pairs(surface.engines[engine.unit_number].sprites) do
        sprite.destroy()
    end

    surface.engines[engine.unit_number] = nil
end

---@param engine elok.Engine
function Locomotive:refuel(engine)
    if not (engine and engine.entity and engine.entity.valid) then return end

    local surface = This:locateSurface(engine.entity.surface_index)
    if table_size(surface.power_sources) > 0 then
        engine.entity.burner.remaining_burning_fuel = engine.entity.burner.currently_burning.name.fuel_value
    end
end

---@param engine elok.Engine
function Locomotive:deplete(engine)
    if not (engine and engine.entity and engine.entity.valid) then return end

    local surface = This:locateSurface(engine.entity.surface_index)
    if not next(surface.power_sources) then
        engine.entity.burner.remaining_burning_fuel = 0
    end
end

---@param context ff2.ticker.TickerContext
---@param values ff2.ticker.TickerContext
local function ticker_unit_of_work(context, values)
    local engine = values.engine
    if not (engine and engine.entity and engine.entity.valid) then return end

    local burner = assert(engine.entity.burner)
    assert(burner.currently_burning)


    local power_source = context.power_idx and context.power_sources[context.power_idx] or nil

    repeat
        if power_source and power_source.energy > 0.1 then
            local required_power = burner.currently_burning.name.fuel_value - burner.remaining_burning_fuel
            local available_power = math.min(power_source.energy, required_power)

            if available_power > 0.1 then
                power_source.energy = power_source.energy - available_power
                burner.remaining_burning_fuel = burner.remaining_burning_fuel + available_power

                required_power = burner.currently_burning.name.fuel_value - burner.remaining_burning_fuel
            end

            if required_power < 0.1 then return end
        end

        context.power_idx, power_source = next(context.power_sources, context.power_idx)
    until not (power_source and power_source.energy > 0.1)

    if burner.remaining_burning_fuel < 0.1 then
        burner.remaining_burning_fuel = 0
    end
end

local tick_interval = Framework.settings:startup_setting(const.settings_names.tick_interval) or 2

function Locomotive:tick()
    local ticker_info = ticker.getTicker('locomotive_refresh')

    local elok_storage = This:storage()
    if elok_storage.total_engine_count == 0 then return end

    local entities_per_tick = math.max(1, math.ceil(elok_storage.total_engine_count / tick_interval)) -- at least one

    local context = ticker_info.last_tick_context or {}

    local iterator = ticker.createWorkIterator {
        context = context,
        -- creates the surface_index (keys of elok_storage.surfaces) as 'surface_index'
        -- stores the value of elok_storage.surfaces[<current index>] as value
        field_name = 'surface_index',
        iterable = elok_storage.surfaces,
        sub_iterator = ticker.createWorkIterator {
            context = context,
            -- iterates over the parent element. In this case, the iterable is in an
            -- attribute ('engines') which is extracted with the process_iterable function below
            field_name = 'engine',

            -- extract engines as the next iterable element and
            -- add power_sources to the context
            process_iterable = function(iterable, iterable_context)
                iterable_context.power_sources = iterable.power_sources

                return iterable.engines
            end,
        },
    }

    while entities_per_tick > 0 do
        iterator.process(ticker_unit_of_work)

        entities_per_tick = entities_per_tick - 1
    end

    -- restart from first power station for the next loop
    context.power_idx = nil
    context.power_sources = nil

    ticker_info.last_tick_context = context
    ticker_info.last_tick = game.tick
end

return Locomotive
