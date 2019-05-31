local SCREEN_WIDTH = 640
local SCREEN_HEIGHT = 480
local MARGIN_X = 16
local MARGIN_Y = 16
local SPRITE_DIMENSION = 32

local BLUE = "blue"
local RED = "red"
local GREEN = "green"
local PIPE = "pipe"
local COLOR_COUNT = 3
local PLAYER_1 = "player1"
local PLAYER_2 = "player2"
local BACKGROUND = "background"
local PIPE_COUNT = 5
local SPAWN_SEQUENCE_DELAY_SEC = 2
local SPEC_MOVEMENT_DELAY_SEC = 2
local LANE_BUFFER_SIZE = 5

local images = {}
local players = {}
local lanes = {}
local timeToSpawnSpec = 0
local fails = 0

function love.load()
    math.randomseed(os.time())
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle("K ⓔ ⓘ J ⓞ G A M ⓔ")
    images[PIPE] = love.graphics.newImage("images/pipe.png")
    images[BACKGROUND] = love.graphics.newImage("images/bg_margin.png")
    images[BLUE] = love.graphics.newImage("images/blue.png")
    images[GREEN] = love.graphics.newImage("images/green.png")
    images[RED] = love.graphics.newImage("images/red.png")
    players[PLAYER_1] = {sprite = love.graphics.newImage("images/player1.png"), logic = Player:new(1)}
    players[PLAYER_2] = {sprite = love.graphics.newImage("images/player2.png"), logic = Player:new(5)}
    initTwoDimTable(lanes, PIPE_COUNT)
end

function love.draw()
    drawImage(images[BACKGROUND], 0, 0)
    drawPipes()
    drawPlayers()
    drawSpecs()
end

function love.update(dt)
    spawnSpecIfTimerIsRight(dt)
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
    elseif key == "z" then
        attemptToRemoveSpec(RED, players[PLAYER_1].logic.position)
    elseif key == "x" then
        attemptToRemoveSpec(GREEN, players[PLAYER_1].logic.position)
    elseif key == "c" then
        attemptToRemoveSpec(BLUE, players[PLAYER_1].logic.position)
    elseif key == "b" then
        attemptToRemoveSpec(RED, players[PLAYER_2].logic.position)
    elseif key == "n" then
        attemptToRemoveSpec(GREEN, players[PLAYER_2].logic.position)
    elseif key == "m" then
        attemptToRemoveSpec(BLUE, players[PLAYER_2].logic.position)
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
    local futurePos = self.position + movement
    if futurePos >= 1 and futurePos <= PIPE_COUNT and futurePos ~= otherPlayer.position then
        self.position = futurePos
    end
end

function attemptToRemoveSpec(color, lane)
    local laneTable = lanes[lane]
    local tableLength = table.getn(laneTable)
    if tableLength > 0 then
        local lastSpec = laneTable[tableLength]
        if lastSpec.color == color then
            removeSpec(laneTable)
            return true
        end
    end
    fails = fails + 1
    return false
end

function removeSpec(lane)
    table.remove(lane)
end

function spawnSpecIfTimerIsRight(dt)
    if timeToSpawnSpec > 0 then
        timeToSpawnSpec = timeToSpawnSpec - dt
    else
        spawnSpec()
        timeToSpawnSpec = SPAWN_SEQUENCE_DELAY_SEC
    end
end

function initTwoDimTable(table, n)
    for i = 1, n do
        table[i] = {}
    end
end

function spawnSpec()
    local pipeNumber = math.random(PIPE_COUNT)
    local colorNumber = math.random(COLOR_COUNT)
    local spec = createSpec(colorNumber)
    local specWasAdded = addNewSpecToLane(spec, pipeNumber)
    if not specAddedSuccess then
        fails = fails + 1
    end
end

function createSpec(colorNumber)
    return {
        color = colorNumberToString(colorNumber)
    }
end

function addNewSpecToLane(spec, laneNumber)
    local laneTable = lanes[laneNumber]
    local laneSize = table.getn(laneTable)
    if laneSize < LANE_BUFFER_SIZE then
        spec.location = laneSize
        table.insert(laneTable, 1, spec)
        return true
    else
        return false
    end
end

function colorNumberToString(number)
    if number == 1 then
        return BLUE
    elseif number == 2 then
        return RED
    elseif number == 3 then
        return GREEN
    end
end

function drawPlayers()
    local yOffset = MARGIN_Y + 13 * SPRITE_DIMENSION
    for _, player in pairs(players) do
        local xOffset = MARGIN_X + (4 * (player.logic.position - 1) + 1) * SPRITE_DIMENSION
        drawImage(player.sprite, xOffset, yOffset)
    end
end

function drawPipes()
    local yOffset = MARGIN_Y + 7 * SPRITE_DIMENSION
    for i = 1, PIPE_COUNT do
        local xOffset = MARGIN_X + (4 * (i - 1) + 1) * SPRITE_DIMENSION
        drawImage(images[PIPE], xOffset, yOffset)
    end
end

function drawSpecs()
    local initialYPos = MARGIN_Y + 8 * SPRITE_DIMENSION
    for laneNumber, lane in ipairs(lanes) do
        for specPos, spec in ipairs(lane) do
            local xPos = MARGIN_X + (4 * (laneNumber - 1) + 1) * SPRITE_DIMENSION
            local yPos = initialYPos + (specPos - 1) * SPRITE_DIMENSION
            drawImage(images[spec.color], xPos, yPos)
        end
    end
end

function drawImage(image, x, y, r, sx, sy)
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    love.graphics.draw(image, x, y, r, sx, sy)
end