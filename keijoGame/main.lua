local SCREEN_WIDTH = 640
local SCREEN_HEIGHT = 480
local PIPE_X_OFFSET = 20
local PIPE_Y_OFFSET = 200
local BLUE = "blue"
local RED = "red"
local GREEN = "green"
local PIPE = "pipe"
local PLAYER_1 = "player1"
local PLAYER_2 = "player2"
local BACKGROUND = "background"
local COLOR_COUNT = 3

local images = {}
local lanes = {}
local players = {}

function love.load()
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  love.window.setTitle("K E I J O G A M E")
  images[PIPE] = love.graphics.newImage("images/blue.png")
  images[BACKGROUND] = love.graphics.newImage("images/shakki.png")
  players[PLAYER_1] = {sprite = love.graphics.newImage("images/player1.png"), logic = Player:new(0)}
  players[PLAYER_2] = {sprite = love.graphics.newImage("images/player2.png"), logic = Player:new(4)}
end

function love.draw()
  love.graphics.draw(images[BACKGROUND], 0, 0)
  drawPipes()
  drawPlayers()
end

function love.update(dt)

end

function love.keypressed(key)
  if key == "x" then
    players[PLAYER_1].logic:move(1)
  end
end

Player = {}
Player.__index = Player

function Player:new(position)
  o = {}
  setmetatable(o, Player)
  o.position = position
  return o
end

function Player:move(movement)
  print(self.position)
  local futurePos = self.position + movement
  if futurePos >= 0 or futurePos <= 4 then
    self.position = futurePos
    return true
  else
    return false
  end
end

function drawPlayers()
  for _, player in pairs(players) do
    love.graphics.draw(player.sprite, PIPE_X_OFFSET + (140 * player.logic.position), 400)
  end
  
end

function drawPipes()
  local localOffset = 140
  for i = 0,4 do
    love.graphics.draw(images[PIPE], PIPE_X_OFFSET + (i * localOffset), PIPE_Y_OFFSET)
  end
end
