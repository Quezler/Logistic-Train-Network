--[[ Copyright (c) 2017 Optera
 * Part of Logistics Train Network
 * Control stage utility functions
 *
 * See LICENSE.md in the project directory for license information.
--]]

--GetTrainCapacity(train)
local function getCargoWagonCapacity(entity)
  local capacity = entity.prototype.get_inventory_size(defines.inventory.cargo_wagon)
  -- log("(getCargoWagonCapacity) capacity for "..entity.name.." = "..capacity)
  global.WagonCapacity[entity.name] = capacity
  return capacity
end

local function getFluidWagonCapacity(entity)
  local capacity = 0
  for n=1, #entity.fluidbox do
    capacity = capacity + entity.fluidbox.get_capacity(n)
  end
  -- log("(getFluidWagonCapacity) capacity for "..entity.name.." = "..capacity)
  global.WagonCapacity[entity.name] = capacity
  return capacity
end

-- returns inventory and fluid capacity of a given train
function GetTrainCapacity(train)
  local inventorySize = 0
  local fluidCapacity = 0
  if train and train.valid then
    for _,wagon in pairs(train.cargo_wagons) do
      local capacity = global.WagonCapacity[wagon.name] or getCargoWagonCapacity(wagon)
      inventorySize = inventorySize + capacity
    end
    for _,wagon in pairs(train.fluid_wagons) do
      local capacity = global.WagonCapacity[wagon.name] or getFluidWagonCapacity(wagon)
      fluidCapacity = fluidCapacity + capacity
    end
  end
  return inventorySize, fluidCapacity
end

-- returns gps string from entity or just string if entity is invalid
function MakeGpsString(entity, name)
  if(message_rich_text_icons_only) then
    name = RichTextIconsOnly(name)
  end

  if message_include_gps and entity and entity.valid then
    return format("%s [gps=%s,%s,%s]", name, entity.position["x"], entity.position["y"], entity.surface.name)
  else
    return name
  end
end

-- removes the clickable green from rich text, only their icons stay
local rich_text_icons_only_cache = {}
function RichTextIconsOnly(name)
  local key = name -- name changes here, storing the original as key

  if rich_text_icons_only_cache[key] == nil then
    name = name:gsub("%[item="           , "[img=item/")
    name = name:gsub("%[entity="         , "[img=entity/")
    name = name:gsub("%[technology="     , "[img=technology/")
    name = name:gsub("%[recipe="         , "[img=recipe/")
    name = name:gsub("%[item%-group="    , "[img=item-group/")
    name = name:gsub("%[fluid="          , "[img=fluid/")
    name = name:gsub("%[tile="           , "[img=tile/")
    name = name:gsub("%[virtual%-signal=", "[img=virtual-signal/")
    name = name:gsub("%[achievement="    , "[img=achievement/")
    rich_text_icons_only_cache[key] = name
  end

  return rich_text_icons_only_cache[key]
end