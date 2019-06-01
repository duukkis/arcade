local SCREEN_WIDTH = 480
local SCREEN_HEIGHT = 640
local MARGIN_X = 16
local MARGIN_Y = 16
local SPRITE_DIMENSION = 32
local LANES_COUNT = 5

local MOVEMENT_DELAY_SEC = 0.5
local SPAWN_DELAY_SEC = 5 * MOVEMENT_DELAY_SEC

local BLUE = "blue"
local RED = "red"
local GREEN = "green"
local YELLOW = "yellow"

local BACKGROUND = "background"
local LANES = "lanes"
local GATES_SPRITE = "gatesSprite"
local UKKELI = "ukkeli"

local images = {}
local gates = {}
local ukkelis = {}
local movementTimer = MOVEMENT_DELAY_SEC
local spawnTimer = 0

function love.load()
    math.randomseed(os.time())
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle("M Ö ⓣ K Ä L ⓔ")
    images[BACKGROUND] = love.graphics.newImage("images/bg_margin.png")
    images[LANES] = love.graphics.newImage("images/lanes.png")
    images[GATES_SPRITE] = love.graphics.newImage("images/gates.png")
    images[UKKELI] = love.graphics.newImage("images/ukkeli.png")
    initGates()
end

function love.draw()
    drawImage(images[BACKGROUND])
    drawImage(images[LANES])

    drawGates(BLUE)
    drawGates(RED)
    drawGates(YELLOW)
    drawGates(GREEN)

    drawUkkelis()
end

function love.update(dt)
    if spawnTimer > 0 then
        spawnTimer = spawnTimer - dt
    else
        spawnUkkeli()
        spawnTimer = SPAWN_DELAY_SEC
    end

    if movementTimer > 0 then
        movementTimer = movementTimer - dt
    else
        moveUkkelis()
        movementTimer = MOVEMENT_DELAY_SEC
    end

end

function love.keypressed(key)
    if key == "1" then
        gates[BLUE]:toggle()
    elseif key == "2" then
        gates[RED]:toggle()
    elseif key == "3" then
        gates[YELLOW]:toggle()
    elseif key == "4" then
        gates[GREEN]:toggle()
    end
end

GateSet = {}
GateSet.__index = GateSet

function GateSet:new(openImage, closedImage, gatePositions)
    o = {}
    setmetatable(o, GateSet)
    o.isOpen = false
    o.openImage = openImage
    o.closedImage = closedImage
    o.gatePositions = gatePositions
    return o
end

function GateSet:toggle()
    self.isOpen = not self.isOpen
end

function initGates()
    local gatesConfig = love.filesystem.load("gates.lua")()

    gates[BLUE] = GateSet:new(
        getGateImageFromSprite(SPRITE_DIMENSION * 2, 0, images[GATES_SPRITE]),
        getGateImageFromSprite(0, SPRITE_DIMENSION, images[GATES_SPRITE]),
        gatesConfig[BLUE])

    gates[RED] = GateSet:new(
        getGateImageFromSprite(SPRITE_DIMENSION, SPRITE_DIMENSION, images[GATES_SPRITE]),
        getGateImageFromSprite(2 * SPRITE_DIMENSION, SPRITE_DIMENSION, images[GATES_SPRITE]),
        gatesConfig[RED])

    gates[YELLOW] = GateSet:new(
        getGateImageFromSprite(0, 0, images[GATES_SPRITE]),
        getGateImageFromSprite(SPRITE_DIMENSION, 0, images[GATES_SPRITE]),
        gatesConfig[YELLOW])

    gates[GREEN] = GateSet:new(
        getGateImageFromSprite(0, 2 * SPRITE_DIMENSION, images[GATES_SPRITE]),
        getGateImageFromSprite(SPRITE_DIMENSION, 2 * SPRITE_DIMENSION, images[GATES_SPRITE]),
        gatesConfig[GREEN])
end

function drawGates(color)
    for _, position in pairs(gates[color].gatePositions) do
        if (position.to > position.from) then
            xPos = MARGIN_X + 2 * position.from * SPRITE_DIMENSION + SPRITE_DIMENSION
        else
            xPos = MARGIN_X + 2 * position.from * SPRITE_DIMENSION - SPRITE_DIMENSION
        end
        yPos = MARGIN_Y + position.row * SPRITE_DIMENSION

        if gates[color].isOpen then
            drawGate(gates[color].openImage, xPos, yPos)
        else
            drawGate(gates[color].closedImage, xPos, yPos)
        end
    end
end

function getOpenGates()
    openGates = {}
    if (gates[BLUE].isOpen) then
        openGates = combineTables(openGates, gates[BLUE].gatePositions)
    end
    if (gates[RED].isOpen) then
        openGates = combineTables(openGates, gates[RED].gatePositions)
    end
    if (gates[YELLOW].isOpen) then
        openGates = combineTables(openGates, gates[YELLOW].gatePositions)
    end
    if (gates[GREEN].isOpen) then
        openGates = combineTables(openGates, gates[GREEN].gatePositions)
    end
    return openGates
end

function drawGate(gateQuad, x, y)
    love.graphics.draw(images[GATES_SPRITE], gateQuad, x, y)
end

function getGateImageFromSprite(x, y, imageFile)
    return love.graphics.newQuad(x, y, SPRITE_DIMENSION, SPRITE_DIMENSION, imageFile:getDimensions())
end

Ukkeli = {}
Ukkeli.__index = Ukkeli

function Ukkeli:new(lane)
    o = {}
    setmetatable(o, ukkelit)
    o.lane = lane
    o.row = 1
    return o
end

function spawnUkkeli()
    local laneNumber = math.random(LANES_COUNT)
    table.insert(ukkelis, 1, Ukkeli:new(laneNumber))
end

function drawUkkelis()
    for _, ukkeli in ipairs(ukkelis) do
        local x = MARGIN_X + 2 * ukkeli.lane * SPRITE_DIMENSION
        local y = MARGIN_Y + (ukkeli.row - 1) * SPRITE_DIMENSION
        drawImage(images[UKKELI], x, y)
    end
end

function moveUkkelis()
    local openGates = getOpenGates()
    for _, ukkeli in ipairs(ukkelis) do
        move(ukkeli, openGates)
    end
end


function move(ukkeli, openGates)

    for _, openGate in ipairs(openGates) do
        if openGate.row == ukkeli.row and openGate.from == ukkeli.lane then
            ukkeli.lane = openGate.to
        end
    end

    ukkeli.row = ukkeli.row + 1

end

function drawImage(image, x, y, r, sx, sy)
    x = x or 0
    y = y or 0
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    love.graphics.draw(image, x, y, r, sx, sy)
end

function combineTables(...)
    combined = {}

    for i, t in pairs{...} do
        for _, value in ipairs(t) do
            table.insert(combined, value)
        end
    end

    return combined
end

--[[

TODO
liikuttele sitä alas
logiikka joka teleporttaa tyypin jos lanesta on siirtymä toiseen
tee lanejen päihin laskurit, jotka kertoo paljon meni eri päihin

]]
