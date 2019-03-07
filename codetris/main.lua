local screen_width = 640
local screen_height = 480

local max_time = 10
local timer_bar_height = 300
local timer = love.timer.getTime()

function love.load()
    love.window.setMode(screen_width, screen_height)
end

function love.draw()
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
    love.graphics.rectangle('line', 600, 30, 30, timer_bar_height, 3)
    love.graphics.rectangle('fill', 600, 30, 30, filled, 3)
end
