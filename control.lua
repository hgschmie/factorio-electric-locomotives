------------------------------------------------------------------------
-- runtime code
------------------------------------------------------------------------

This, Framework = require('lib.init')()

local Event = require('stdlib.event.event')
local Matchers = require('framework.matchers')
local Ticker = require('framework.ticker')

local const = require('lib.constants')

--------------------------------------------------------------------------------
-- entity create / delete
--------------------------------------------------------------------------------

---@param event EventData.on_built_entity | EventData.on_robot_built_entity | EventData.on_space_platform_built_entity | EventData.script_raised_revive | EventData.script_raised_built
local function on_locomotive_created(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    This.Locomotive:createLocomotive(event.entity)
end

---@param event EventData.on_built_entity | EventData.on_robot_built_entity | EventData.on_space_platform_built_entity | EventData.script_raised_revive | EventData.script_raised_built
local function on_control_station_created(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    This.ControlStation:createControlStation(event.entity)
end

---@param event EventData.on_player_mined_entity | EventData.on_robot_mined_entity | EventData.on_space_platform_mined_entity | EventData.script_raised_destroy
local function on_locomotive_removed(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    This.Locomotive:destroyLocomotive(event.entity.surface_index, event.entity.unit_number)
end

---@param event EventData.on_player_mined_entity | EventData.on_robot_mined_entity | EventData.on_space_platform_mined_entity | EventData.script_raised_destroy
local function on_control_station_removed(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    This.ControlStation:destroyControlStation(event.entity)
end

local function resync_state()
    -- resync the state of the world
    local elok_storage = This:storage()

    -- fully reset state
    elok_storage.surfaces = {}
    elok_storage.total_engine_count = 0
    elok_storage.total_control_station_count = 0

    for _, surface in pairs(game.surfaces) do
        local control_stations = surface.find_entities_filtered {
            type = 'electric-energy-interface',
            name = const.getControlStationNames(),
        }

        -- register the control stations
        for _, control_station in pairs(control_stations) do
            This.ControlStation:createControlStation(control_station)
        end

        local engines = surface.find_entities_filtered {
            type = 'locomotive',
            name = const.getLocomotiveNames(),
        }

        -- load up the locomotive
        for _, engine in pairs(engines) do
            This.Locomotive:createLocomotive(engine)
        end
    end
end

--------------------------------------------------------------------------------
-- Research ended
--------------------------------------------------------------------------------

---@param event EventData.on_research_finished
local function on_research_finished(event)
    -- refuel all locomotives
    local elok_storage = This:storage()

    for _, locomotives in pairs(elok_storage.surfaces) do
        for _, engine in pairs(locomotives.engines) do
            This.Locomotive:refuel(engine)
        end
    end
end


--------------------------------------------------------------------------------
-- Surface changes
--------------------------------------------------------------------------------

---@param event EventData.on_surface_cleared|EventData.on_surface_deleted
local function on_surface_cleared(event)
    local elok_storage = This:storage()

    local surface = elok_storage.surfaces[event.surface_index]
    if surface then
        elok_storage.total_engine_count = elok_storage.total_engine_count - table_size(surface.engines)
        elok_storage.total_control_station_count = elok_storage.total_control_station_count - table_size(surface.power_sources)
        elok_storage.surfaces[event.surface_index] = nil
    end
end

--------------------------------------------------------------------------------
-- Configuration changes (startup)
--------------------------------------------------------------------------------

local function on_configuration_changed()
    This:init()

    Ticker.resetTicker(const.locomotive_ticker_name, {
        const.locomotive_ticker_context_field,
    })

    -- unlock recipes for all known / relevant technologies
    for _, force in pairs(game.forces) do
        for _, technology_name in pairs(const.getTechnologyNames()) do
            local technology = force.technologies[technology_name]
            if (technology and technology.enabled and technology.researched) then
                for _, modifier in pairs(technology.prototype.effects) do
                    if modifier.type == 'unlock-recipe' then
                        local recipe = force.recipes[modifier.recipe]
                        if recipe then recipe.enabled = true end
                    end
                end
            end
        end
    end

    resync_state()
end

--------------------------------------------------------------------------------
-- ticker
--------------------------------------------------------------------------------

local function on_tick()
    This.Locomotive:tick()
end

--------------------------------------------------------------------------------
-- event registration and management
--------------------------------------------------------------------------------

---@param event  EventData.on_research_finished
local function extract_research_name(event)
    return event.research.name
end

local function register_events()
    -- Configuration changes (startup)
    Event.on_configuration_changed(on_configuration_changed)

    Event.register(Matchers.CREATION_EVENTS, on_locomotive_created, Matchers:matchEventEntityName(const.getLocomotiveNames()))
    Event.register(Matchers.CREATION_EVENTS, on_control_station_created, Matchers:matchEventEntityName(const.getControlStationNames()))

    Event.register(Matchers.DELETION_EVENTS, on_locomotive_removed, Matchers:matchEventEntityName(const.getLocomotiveNames()))
    Event.register(Matchers.DELETION_EVENTS, on_control_station_removed, Matchers:matchEventEntityName(const.getControlStationNames()))

    Event.register({ defines.events.on_surface_cleared, defines.events.on_surface_deleted }, on_surface_cleared)

    Event.register({ defines.events.on_research_finished }, on_research_finished, Matchers:matchEventByAttribute(extract_research_name, const.research_technology))

    -- ticker code
    Event.on_nth_tick(1, on_tick)
end

--------------------------------------------------------------------------------
-- mod init/load code
--------------------------------------------------------------------------------

local function on_init()
    This:init()

    register_events()
end

local function on_load()
    register_events()
end

Event.on_init(on_init)
Event.on_load(on_load)

------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_runtime_stage()
