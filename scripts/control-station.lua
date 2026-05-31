------------------------------------------------------------------------
-- Control Station related code
------------------------------------------------------------------------

assert(script)

---@class elok.ControlStation
local ControlStation = {}

---@param control_station LuaEntity
function ControlStation:createControlStation(control_station)
    local surface = This:locateSurface(control_station.surface_index)

    local power_source_count = table_size(surface.power_sources)

    surface.power_sources[control_station.unit_number] = control_station

    -- power stations already existed
    if power_source_count > 0 then return end

    for _, engine in pairs(surface.engines) do
        This.Locomotive:refuel(engine)
    end
end

---@param control_station LuaEntity
function ControlStation:destroyControlStation(control_station)
    local surface = This:locateSurface(control_station.surface_index)
    surface.power_sources[control_station.unit_number] = nil
    if table_size(surface.power_sources) > 0 then return end

    for _, engine in pairs(surface.engines) do
        This.Locomotive:deplete(engine)
    end
end



return ControlStation
