# Electric Locomotives

Adds electric locomotives to Factorio. It started out as an attempt to fix the various electric train mods that exist but became a full rewrite.

Electric locomotives are an alternative to the regular Factorio Locomotives. They do not need to be refueled but are powered and controlled by central control stations. These must be placed on the same surface to provide energy. Control stations connect to the electric distribution network and send power directly to the locomotives.

Electric Locomotives come in three tiers: __Standard__, __MK2__ and __MK3__. By default, all locomotive tiers can be researched but improved wagons are disabled. This can be changed in the startup settings (see below).

## Tier overview

|                       |    applies to   | Standard  | MK2       | MK3       |
|-----------------------|-----------------|-----------|-----------|-----------|
| Tier Factor           | all             | 1         | 1.5       | 2         |
| Power Consumption     | Locomotives     | 600kW     | 900 kW    | 1.2MW     |
| Maximum Speed         | Locomotives     | 259.2 kph | 338.8 kph | 518.4 kph |
| Charge Capacity       | Control Station | 1000kJ    | 1500kJ    | 2000kJ    |
| Power Consumption     | Control Station | 12.25MW   | 18.275MW  | 24.3MW    |
| Capacity              | Cargo Wagons    | -         | 60 slots  | 80 slots  |
| Capacity              | Fluid Wagons    | -         | 75,000    | 100,000   |

## Locomotives

Each locomotive receives power from a control station. A locomotive can only receive power from a control station on the same surface.

An electric locomotive must be constantly supplied. By default, it has enough power onboard to last 20 ticks (about 1/3 of a second) if using full power before running out of power.

Each locomotive displays its type (and the fact that it is electric) with overlay icons.

## Control Stations

A control stations provides locomotives on the same surface with power. There is no range limit, one control station per surface is sufficient for a few locomotives. If needed, multiple control stations can be placed to support larger number of locomotives.

By default, a control station can support 20 locomotives matching its tier: a standard control station can support 20 locomotives at full load.

Locomotives only consume energy when they are accelerating or moving; it is possible to "oversubscribe" a control station. If a locomotive can not be supplied fully, its energy bar will start dropping. Locomotives that get no power will decelerate and stop while displaying the "out of fuel" icon.

Control stations are not tied to a specific tier, a standard control station can supply a MK3 locomotive, however due to the larger power drain, it will only be able to support fewer locomotives.

## Wagons

Standard Factorio wagons are clamped to the maximum speed that a Factorio locomotive can achieve and would slow down a train that is moved by a MK2 or MK3 locomotive. When enabled, the higher technology tiers will also enable matching cargo and fluid wagons.

## Settings

### Improved Locomotives (startup, default is `true`)

Enables additional MK2 and MK3 tiers for electric locomotives. When researching additional technology tiers, more powerful locomotives and control stations become available.

### Improved Cargo Wagons (startup, default is `false`)

Enables additional MK2 and MK3 tiers for cargo wagons. When researching additional technology tiers, cargo wagons that run faster and have higher capacity become available.

### Improved Fluid Wagons (startup, default is `false`)

Enables additional MK2 and MK3 tiers for fluid wagons. When researching additional technology tiers, fluid wagons that run faster and have higher capacity become available.

### Always add icons (startup, default is `true`)

Mark any electric locomotive using hovering icons. The default is to always show the icons. When this setting is turned off, the icons are only displayed in 'Alt mode'.

### Unlock max speed for all wagons (startup, default is `true`)

When enabled, all wagons in the game (base wagons and wagons contributed by other mods) will be modified to run at least at the speed of the fastest electric locomotive. This ensures that trains are not slowed down by any wagon (and unless the higher capacity for cargo and fluid wagons is wanted, there is no need to enable improved cargo wagons and fluid wagons).

### Electric energy update interval (startup, default is `5`)

Number of ticks between updates for any locomotive. For very large bases, it may make sense to increase this number so that fewer locomotives are updated per tick which helps with FPS/UPS. The total power capacity of a locomotive is 4x this value.

### Locomotives per Control Station (startup, default is `20`)

The number of locomotives that a control station can support (for locomotives matching the control station tier). Increase this number if you run many trains and don't want to place many control stations.

## Mod support and compatibility

- [Automatic Train Refueler](https://mods.factorio.com/mod/auto-train-refuel) and any other mod that exposes a [Automatic Train Fuel Stop](https://mods.factorio.com/mod/FuelTrainStop) compatible API: All known locomotive types are registered to skip refueling.
- [LTN - Logistic Train Network](https://mods.factorio.com/mod/LogisticTrainNetwork): All known locomotive types are registered to skip refueling.
- [Bob's Logistics](https://mods.factorio.com/mod/boblogistics): When 'Trains' are enabled, cargo wagons and fluid wagons are disabled, even if the startup setting would enable them. The wagons added by Bob's Logistics are a fit for the electric locomotive tiers.
- [Bob's Vehicle Equipment](https://mods.factorio.com/mod/bobvehicleequipment): If 'Enable Vehicle Grids' is active, Electric locomotives and cargo wagons have equipment grids.
- [Multiple Unit Train Control](https://mods.factorio.com/mod/MultipleUnitTrainControl): Add support for "multiple-unit consist" with two electric locomotives. This doubles the acceleration force compared to a single locomotive and makes a train run at maximum speed in both directions.

Electric Locomotives is incompatible with [ElectricTrain](https://mods.factorio.com/mod/ElectricTrain2), [Electric Train 2.0 Fix](https://mods.factorio.com/mod/ElectricTrainFix) and [Electric Train 2.0 Fix2](https://mods.factorio.com/mod/ElectricTrainFix2). However, all entities have the same names (which all carry over from the original [ElectricTrain](https://mods.factorio.com/mod/ElectricTrain) mod), so deactivating any of those mods and activating Electric Locomotives will take over the existing entities.

## How Electric Locomotives work (Warning, math ahead)

If you have seen the factorio pages about [Energy](https://lua-api.factorio.com/latest/types/Energy.html), [Power](https://wiki.factorio.com/Units#Power) and [Work](https://wiki.factorio.com/Units#Work), your eyes may have glazed over about "math in a video game".

Actually, it is pretty nifty (and it can help you configure and tweak the electric locomotive setup for your base):

- A [base locomotive](https://wiki.factorio.com/Locomotive) can consume `600kW`. The same applies for a standard electric locomotive, except that it is `600kW (consumption of a base locomotive) * 1 (factor, see table above) = 600kW`. MK2 and MK3 locomotives have a factor higher than 1, so they consume more energy. `600kW` should be read as `600kW per second`.
- `600 kW/second` is power and means that the locomotive consumes energy to do `10kJ/tick` work (because `600kW/60 =  10 kJ/tick` with the game running at 60 ticks per second). At every tick, the locomotive will take this much energy out of its internal burner to do work (move the train).
- An electric locomotive has a "fuel" source that stores energy. The amount of energy is defined as `10kJ (locomotive consumption) * 5 (tick interval) * 4 (safety factor)`. For a standard electric locomotive, the fuel source has `200kJ` capacity. Fully charged, it allows the locomotive to continue for 20 ticks (1/3 of a second) before running out of power.
- To recharge 20 standard locomotives, a standard control station must be able to provide `20 (number of locomotives) * 10 kJ = 200kJ` per tick. This allows it to keep all locomotives fully charged even if they are at peak consumption. A control station has only a single tick capacity and needs to be recharged constantly from the electrical network.
- To recharge it, energy must flow into the control station. For 60 ticks (one second), this is `60 (number of ticks) * 200kJ (total charge required per tick) = 12,000kW`. There is also an additional drain (power needed by the control station itself) which is `200kW + 50kW * factor (see table above)`. For a standard control stations, the drain is `250kW` which is added to the consumption for a maximum power draw for a standard control station of `12,000kW + 250kW = 12.25MW`.

All of those numbers can be adjusted:

- The power draw of a locomotive is the base draw (`600kW`) multiplied by the tier factor (see above). A MK3 locomotive draws `600kW * 2 = 1.2MW`.
- The tick interval is a startup setting. Increasing it from `5` to a higher value will increase the energy capacity of an locomotive (and its ability to keep going without being recharged). Every locomotive is recharged in this interval, so a higher number leads to a longer interval. When having e.g. 2,000 electric locomotives, a tick interval of 5 means that 400 locomotives must be recharged at every tick. A tick interval of 50 means that only 40 locomotives must be recharged.
- The number of locomotives per control station is a startup setting. Changing it from `20` will increase or decrease the maximum power draw of a control station. For 2,000 electric locomotives, 100 control stations are needed. When increasing this number to 200, only 10 stations are required.

## How you can help

This mod would benefit from actual electric locomotive graphics. A "real" electric locomotive body would go a long way to make this mod more immersive. Same applies for the control station (but [Hurricane046](https://mods.factorio.com/user/hurricane046)'s Radio Tower does a good job here).

## Legal & Credits

The Control station graphic is the "Radio Tower" entity from [Hurricane046](https://mods.factorio.com/user/hurricane046)'s [Figma page](https://www.figma.com/proto/y1IQG08ZG2jIeJ5sTyF4MP/Factorio-Buildings?node-id=14934-304). Distributed under [CC BY](https://creativecommons.org/licenses/by/4.0/). Thank you for putting such high quality entities under a permissive license. I poked a tiny bit at it to create slighly different icons for the three item tiers.

The transformer icon on the technology image and the item for the et-fuel items was taken from [Malcolm Riley](malcolmriley)'s [Github Repository of unused renders](https://github.com/malcolmriley/unused-renders). Distributed under [CC BY](https://creativecommons.org/licenses/by/4.0/). Thank you for sharing these graphics with the wider Factorio community.

The thumbnail was created by Google Gemini.

This mod was inspired by [Electric Train](https://mods.factorio.com/mod/ElectricTrain) and [Electric Train 2](https://mods.factorio.com/mod/ElectricTrain2). While it started out as a fork, no code or graphics remain.

The code was reviewed by AI coding agents. If you are fundamentally opposed to using AI tools to improve software quality, you are free to not install it.

----
(C) 2026 Henning Schmiedehausen (hgschmie). Released under [GPLv3](https://github.com/hgschmie/factorio-electric-locomotives/blob/main/LICENSE).
