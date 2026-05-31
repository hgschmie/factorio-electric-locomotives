---@meta
----------------------------------------------------------------------------------------------------
-- class definitions
----------------------------------------------------------------------------------------------------

---@class elok.Engine
---@field entity LuaEntity
---@field sprites LuaRenderObject[]

---@class elok.Surface
---@field engines table<integer, elok.Engine>
---@field power_sources table<integer, LuaEntity>

---@class elok.Storage
---@field total_engine_count integer
---@field total_control_station_count integer
---@field surfaces table<integer, elok.Surface>
