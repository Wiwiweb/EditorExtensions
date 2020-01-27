-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CONTROL STAGE UTILITIES

local math2d = require('__core__/lualib/math2d')
local util = table.deepcopy(require('__core__/lualib/util'))

-- GENERAL

util.constants = {
  -- commonly-used set of events for when an entity is built
  entity_built_events = {
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive
  },
  -- commonly-used set of events for when an entity is destroyed
  entity_destroyed_events = {
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity,
    defines.events.on_entity_died,
    defines.events.script_raised_destroy
  },
  -- close button for frames, as defined in the titlebar submodule
  close_button_def = {
    name = 'close',
    sprite = 'utility/close_white',
    hovered_sprite = 'utility/close_black',
    clicked_sprite = 'utility/close_black'
  }
}

util.direction = {}
util.direction.opposite = util.oppositedirection

-- borrowed from STDLIB: returns the next or previous direction
function util.direction.next(direction, reverse, eight_way)
  return (direction + (eight_way and ((reverse and -1) or 1) or ((reverse and -2) or 2))) % 8
end

-- gets a vector based on a cardinal direction
function util.direction.to_vector(direction, longitudinal, orthogonal)
  orthogonal = orthogonal or 0
  if direction == defines.direction.north then
    return {x=orthogonal, y=-longitudinal}
  elseif direction == defines.direction.south then
    return {x=-orthogonal, y=longitudinal}
  elseif direction == defines.direction.east then
    return {x=longitudinal, y=orthogonal}
  elseif direction == defines.direction.west then
    return {x=-longitudinal, y=-orthogonal}
  end
end

util.gui = {}

function util.gui.add_pusher(parent, name, vertical)
  if vertical then
    return parent.add{type='empty-widget', name=name, style='ee_invisible_vertical_pusher'}
  else
    return parent.add{type='empty-widget', name=name, style='ee_invisible_horizontal_pusher'}
  end
end

util.position = math2d.position

-- creates an area that is the tile the position is contained in
function util.position.to_tile_area(pos)
  return {
    left_top = {x=math.floor(pos.x), y=math.floor(pos.y)},
    right_bottom = {x=math.ceil(pos.x), y=math.ceil(pos.y)}
  }
end

util.textfield = {}

-- clamps numeric textfields to between two values, and sets the textfield style if it is invalid
function util.textfield.clamp_number_input(element, clamps, last_value)
  local text = element.text
  if text == ''
  or (clamps[1] and tonumber(text) < clamps[1])
  or (clamps[2] and tonumber(text) > clamps[2]) then
    element.style = 'ee_invalid_slider_textfield'
  else
    element.style = 'ee_slider_textfield'
    last_value = text
  end
  return last_value
end

-- sets the numeric textfield to the last valid value and resets the style
function util.textfield.set_last_valid_value(element, last_value)
  if element.text ~= last_value then
    element.text = last_value
    element.style = 'ee_slider_textfield'
  end
  return element.text
end

return util