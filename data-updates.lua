------------------------------------------------------------------------
-- data phase 2
------------------------------------------------------------------------

require('lib.init')

-- if settings.startup['mk-train'].value then
-- 	UnlockTrainRecipe()
-- 	UnlockTrainTechnology()
-- end


-- if not (mods['boblogistics'] or mods['FactorioExtended-Trains']) then
-- 	if settings.startup['mk-cargo'].value then
-- 		UnlockCargoRecipe()
-- 		UnlockCargoTechnology()
-- 	end
-- 	if settings.startup['mk-fluid'].value then
-- 		UnlockFluidRecipe()
-- 		UnlockFluidTechnology()
-- 	end
-- 	if settings.startup['mk-train'].value then
-- 		data.raw['artillery-wagon']['artillery-wagon'].max_speed = 2.4
-- 		if not settings.startup['mk-cargo'].value then
-- 			data.raw['cargo-wagon']['cargo-wagon'].max_speed = 2.4
-- 		end
-- 		if not settings.startup['mk-fluid'].value then
-- 			data.raw['fluid-wagon']['fluid-wagon'].max_speed = 2.4
-- 		end
-- 	end	
-- end



------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_data_updates_stage()
