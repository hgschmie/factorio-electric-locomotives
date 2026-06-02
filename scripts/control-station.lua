------------------------------------------------------------------------
-- Control Station related code
------------------------------------------------------------------------

assert(script)

---@class elok.ControlStation
local ControlStation = {}

---@param control_station LuaEntity
function ControlStation:createControlStation(control_station)
    local surface, storage = This:locateSurface(control_station.surface_index)

    if surface.power_sources[control_station.unit_number] then return end

    surface.power_sources[control_station.unit_number] = control_station
    storage.total_control_station_count = storage.total_control_station_count + 1

    -- power stations already existed
    if table_size(surface.power_sources) > 1 then return end

    for _, engine in pairs(surface.engines) do
        This.Locomotive:refuel(engine)
    end
end

---@param control_station LuaEntity
function ControlStation:destroyControlStation(control_station)
    local surface, storage = This:locateSurface(control_station.surface_index)

    if not surface.power_sources[control_station.unit_number] then return end

    surface.power_sources[control_station.unit_number] = nil
    storage.total_control_station_count = storage.total_control_station_count - 1

    if table_size(surface.power_sources) > 0 then return end

    for _, engine in pairs(surface.engines) do
        This.Locomotive:deplete(engine)
    end
end

return ControlStation
