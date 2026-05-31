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


-- if mods['Vehicle Wagon'] and settings.startup['mk-train'].value then
-- 	for _,wagon in pairs(data.raw['cargo-wagon']) do
-- 		if wagon.name:match("vehicle%-wagon") then	
-- 			wagon.max_speed = 2.4
-- 		end
-- 	end
-- end


-- if mods['FactorioExtended-Trains'] and settings.startup['mk-train'].value then
-- 	data.raw['cargo-wagon']['cargo-wagon-2'].max_speed = 1.8
-- 	data.raw['cargo-wagon']['cargo-wagon-3'].max_speed = 2.4
-- 	data.raw['fluid-wagon']['fluid-wagon-2'].max_speed = 1.8
-- 	data.raw['fluid-wagon']['fluid-wagon-3'].max_speed = 2.4
-- end


-- if mods['EvenMoreLight'] then
-- 	for _,train in pairs(data.raw['locomotive']) do
-- 		if train.name:match("^et%-electric%-locomotive%-%d$") then
-- 			train.front_light =
-- 				{
-- 					{
-- 						minimum_darkness = 0.3,
-- 						intensity = 0.9,
-- 						size = 60,
-- 					},
-- 					{
-- 						minimum_darkness = 0.3,
-- 						intensity = 0.9,
-- 						size = 60,
-- 					}
-- 				}
-- 			train.stand_by_light =
-- 				{
-- 					{
-- 						minimum_darkness = 0.3,
-- 						color = {b=1},
-- 						shift = {-0.6, -3.5},
-- 						size = 2,
-- 						intensity = 0.5
-- 					},
-- 					{
-- 						minimum_darkness = 0.3,
-- 						color = {b=1},
-- 						shift = {0.6, -3.5},
-- 						size = 2,
-- 						intensity = 0.5
-- 					},
-- 					{
-- 						minimum_darkness = 0.3,
-- 						intensity = 0.9,
-- 						size = 60,
-- 					},
-- 					{
-- 						minimum_darkness = 0.3,
-- 						intensity = 0.9,
-- 						size = 60,
-- 					}
-- 				}
-- 		end				
-- 	end
-- end



-- if mods['bobvehicleequipment'] then
-- 	if settings.startup['bobmods-vehicleequipment-enablevehiclegrids'].value then
-- 		data.raw['locomotive']['et-electric-locomotive-1'].equipment_grid = "bob-locomotive"
-- 		if settings.startup['mk-train'] then
-- 			data.raw['locomotive']['et-electric-locomotive-2'].equipment_grid = "bob-locomotive-2"
-- 			data.raw['locomotive']['et-electric-locomotive-3'].equipment_grid = "bob-locomotive-3"
-- 		end
-- 		if settings.startup['mk-cargo'].value then
-- 			data.raw['cargo-wagon']['et-cargo-wagon-2'].equipment_grid = "bob-cargo-wagon-2"
-- 			data.raw['cargo-wagon']['et-cargo-wagon-3'].equipment_grid = "bob-cargo-wagon-3"
-- 		end
-- 	end
-- end

------------------------------------------------------------------------

---@diagnostic disable-next-line: undefined-field
Framework.post_data_updates_stage()
