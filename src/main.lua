
-- in lua everything is global
num = 1

debug = true

screen_width = 640
screen_height = 480
-- plumber 17 28
plumber_x = 30
plumber_y = 30

---
max_time = 10
timer_bar_height = 300
timer = love.timer.getTime()

function love.load()
    plumber = love.graphics.newImage("images/plumber.png")
end

-- this is called all the time
function love.draw()
    if debug then
      love.graphics.print('w, a , s, d or arrwos you know the drill', 20, 40)
      -- catenate string and int with ..
      love.graphics.print('x,y ' .. plumber_x .. 'x' .. plumber_y, 20, 20)
    end
    love.graphics.draw(plumber, plumber_x, plumber_y)
    barFiller()
end


-- draw a bar on the side to measure time
function barFiller()
  local now = love.timer.getTime()
  local diff = now - timer
  
  if diff > max_time then
    diff = 0
    timer = love.timer.getTime()
  end
  
  filled = timer_bar_height * (diff / max_time)
  love.graphics.rectangle('line', 660, 30, 30, timer_bar_height, 3)
  love.graphics.rectangle('fill', 660, 30, 30, filled, 3)
end

function love.update(dt)
   if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      if plumber_x > 5 then
        plumber_x = plumber_x - 1
      end
   end
   if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      if plumber_x < screen_width then
        plumber_x = plumber_x + 1
      end
   end
   if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
      if plumber_y > 5 then
        plumber_y = plumber_y - 1
      end
   end
   if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
      if plumber_y < screen_height then
        plumber_y = plumber_y + 1
      end
   end
end
