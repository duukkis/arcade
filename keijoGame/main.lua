local SCREEN_WIDTH = 640
local SCREEN_HEIGHT = 480
local MARGIN_X = 16
local MARGIN_Y = 16
local SPRITE_DIMENSION = 32

local BLUE = "blue"
local RED = "red"
local GREEN = "green"
local PIPE = "pipe"
local PLAYER_1 = "player1"
local PLAYER_2 = "player2"
local BACKGROUND = "background"
local PIPE_COUNT = 5

local images = {}
local players = {}

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle("K ⓔ ⓘ J ⓞ G A M ⓔ")
    images[PIPE] = love.graphics.newImage("images/pipe.png")
    images[BACKGROUND] = love.graphics.newImage("images/bg_margin.png")
    players[PLAYER_1] = {sprite = love.graphics.newImage("images/player1.png"), logic = Player:new(0)}
    players[PLAYER_2] = {sprite = love.graphics.newImage("images/player2.png"), logic = Player:new(4)}
end

function love.draw()
    drawImage(images[BACKGROUND], 0, 0)
    drawPipes()
    drawPlayers()
end

function love.update(dt)

end

function love.keypressed(key)
    if key == "a" then
        players[PLAYER_1].logic:move(-1, players[PLAYER_2].logic)
    elseif key == "d" then
        players[PLAYER_1].logic:move(1, players[PLAYER_2].logic)
    elseif key == "j" then
        players[PLAYER_2].logic:move(-1, players[PLAYER_1].logic)
    elseif key == "l" then
        players[PLAYER_2].logic:move(1, players[PLAYER_1].logic)
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

function Player:move(movement, otherPlayer)
    print(self.position)
    local futurePos = self.position + movement
    if futurePos >= 0 and futurePos <= PIPE_COUNT - 1 and futurePos ~= otherPlayer.position then
        self.position = futurePos
    end
end

function drawPlayers()
    local yOffset = MARGIN_Y + 13 * SPRITE_DIMENSION
    for _, player in pairs(players) do
        local xOffset = MARGIN_X + (4 * player.logic.position + 1) * SPRITE_DIMENSION
        drawImage(player.sprite, xOffset, yOffset)
    end
end

function drawPipes()
    local yOffset = MARGIN_Y + 7 * SPRITE_DIMENSION
    for i = 0, PIPE_COUNT - 1 do
        local xOffset = MARGIN_X + (4 * i + 1) * SPRITE_DIMENSION
        drawImage(images[PIPE], xOffset, yOffset)
    end
end

function drawImage(image, x, y, r, sx, sy)
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    love.graphics.draw(image, x, y, r, sx, sy)
end
