--     Fruit Ninja, but with geese.
--     Copyright (C) 2018  Dane Johnson

--     This program is free software: you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation, either version 3 of the License, or
--     (at your option) any later version.

--     This program is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.

--     You should have received a copy of the GNU General Public License
--     along with this program.  If not, see <http://www.gnu.org/licenses/>.

GOOSE_SCALE = 0.25
BASE_SPEED = 100
SWIPE_TTL = 0.25

function add_goose()
   local direction = love.math.random(math.pi)
   local start = love.math.random(right)
   local speed = BASE_SPEED + love.math.random(BASE_SPEED)
   local goose = {}
   goose['y'] = bottom
   goose['x'] = start
   goose['r'] = 0
   goose['vx'] = speed * math.cos(direction)
   goose['vy'] = speed * math.sin(direction) * -1
   table.insert(geese, goose)
end

function inRectangle(rx, ry, rw, rh, x, y)
   return x > rx and x < rx + rw and y > ry and y < ry + rh
end

function killsGoose(swipe, goose)
   local goose_top = goose['y']-29*game_scale
   local goose_height = 214*game_scale
   local goose_right = goose['x']-172*game_scale
   local goose_width = 340*game_scale
   -- Check if either point is in the goose
   if inRectangle(goose_right, goose_top, goose_width, goose_height, swipe['x1'], swipe['y1']) then
      return true
   end
   if inRectangle(goose_right, goose_top, goose_width, goose_height, swipe['x2'], swipe['y2']) then
      return true
   end

   return false
end
    
function love.load()
   top = 0
   bottom = love.graphics.getHeight()
   left = 0
   right = love.graphics.getWidth()
   game_scale = (love.graphics.getWidth() / 1024) * GOOSE_SCALE
   goose_img = love.graphics.newImage("goose.png")
   geese = {}
   swipes = {}
   level = 1
   points = 0
end

function love.update(dt)
   if #geese < level then
      add_goose()
   end
   for i, goose in ipairs(geese) do
      goose["x"] = goose["x"] + goose["vx"] * dt
      goose["y"] = goose["y"] + goose["vy"] * dt
      if goose['y'] < top or goose['x'] < left or goose['x'] > right then
         table.remove(geese, i)
      end
   end
   for i, swipe in ipairs(swipes) do
      swipe['ttl'] = swipe['ttl'] - dt
      if swipe['ttl'] <= 0 then
         table.remove(swipes, i)
      end
   end
end

function love.draw()
   love.graphics.setBackgroundColor(135, 206, 235)
   for _, goose in ipairs(geese) do
      love.graphics.draw(goose_img, goose["x"], goose["y"], goose["r"], game_scale, game_scale, 172*game_scale, 29*game_scale)
   end
   for _, swipe in ipairs(swipes) do
      love.graphics.line(swipe['x1'], swipe['y1'], swipe['x2'], swipe['y2'])
   end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
   local swipe = {}
   swipe['x1'] = x
   swipe['y1'] = y
   swipe['x2'] = x + dx
   swipe['y2'] = y + dy
   swipe['ttl'] = SWIPE_TTL
   table.insert(swipes, swipe)

   for i, goose in ipairs(geese) do
      if killsGoose(swipe, goose) then
         table.remove(geese, i)
         points = points + 100
         if points / 200 > level then
            level = level + 1
         end
      end
   end
end
   
