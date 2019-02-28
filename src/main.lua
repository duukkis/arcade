
-- in lua everything is global
num = 1

-- this is called all the time
function love.draw()
    love.graphics.print('press "a" to increase number', 200, 300)
    love.graphics.print('press "b" to decrease number', 200, 350)
  -- catenate string and int with ..
    love.graphics.print('number ' .. num, 200, 400)
end



function love.update(dt)
   if love.keyboard.isDown("a") then
      num = num + 1
   end
   if love.keyboard.isDown("b") then
      num = num - 1
   end
end
