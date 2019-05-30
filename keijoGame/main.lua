local SCREEN_WIDTH = 640
local SCREEN_HEIGHT = 480
local PIPE_X_OFFSET = 20
local PIPE_Y_OFFSET = 430

local BLUE = "blue"
local RED = "red"
local GREEN = "green"
local PIPE = "pipe"
local COLOR_COUNT = 3
local lanes = {}
local images = {}

function love.load()
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  love.window.setTitle("K E I J O G A M E")
  images[PIPE] = love.graphics.newImage("images/rosso.png")
end

function love.draw()
  drawPipes()
end

function love.update(dt)

end

function drawPipes()
  local localOffset = 140
  for i = 0,4 do
    love.graphics.draw(images[PIPE], PIPE_X_OFFSET + (i * localOffset), PIPE_Y_OFFSET)
  end
end
