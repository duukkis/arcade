local SCREEN_WIDTH = 480
local SCREEN_HEIGHT = 640
local MARGIN_X = 16
local MARGIN_Y = 16
local SPRITE_DIMENSION = 32

local BLUE = "blue"
local RED = "red"
local GREEN = "green"
local YELLOW = "yellow"

local ON = "on"
local OFF = "off"

local BACKGROUND = "background"
local LANES = "lanes"
local GATES_SPRITE = "gatesSprite"

local images = {}
images[ON] = {}
images[OFF] = {}
local gates = {}

function love.load()
    math.randomseed(os.time())
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle("M Ö T K Ä L E")
    images[BACKGROUND] = love.graphics.newImage("images/bg_margin.png")
    images[LANES] = love.graphics.newImage("images/lanes.png")
    images[GATES_SPRITE] = love.graphics.newImage("images/gates.png")
    initGates()
end

function love.draw()
    drawImage(images[BACKGROUND])
    drawImage(images[LANES])
    drawGates(BLUE)
end

function love.update(dt)

end

function love.keypressed(key)
    if key == "1" then
        gates[BLUE]:toggle()
    elseif key == "2" then
--        gates[RED]:toggle()
    elseif key == "3" then
--        gates[YELLOW]:toggle()
    elseif key == "4" then
--       gates[GREEN]:toggle()
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

end

function drawGates(color)
    for _, position in pairs(gates[color].gatePositions) do
        xPos = MARGIN_X + 2 * position.from * SPRITE_DIMENSION + SPRITE_DIMENSION
        yPos = MARGIN_Y + position.row * SPRITE_DIMENSION

        if gates[color].isOpen then
            drawGate(gates[color].openImage, xPos, yPos)
        else
            drawGate(gates[color].closedImage, xPos, yPos)
        end
    end
end

function drawImage(image, x, y, r, sx, sy)
    x = x or 0
    y = y or 0
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    love.graphics.draw(image, x, y, r, sx, sy)
end

function drawGate(gateQuad, x, y)
    love.graphics.draw(images[GATES_SPRITE], gateQuad, x, y)
end

function getGateImageFromSprite(x, y, imageFile)
    return love.graphics.newQuad(x, y, SPRITE_DIMENSION, SPRITE_DIMENSION, imageFile:getDimensions())
end

--[[

TODO
arvo mistä tulee ukkeli
liikuttele sitä alas
tee lanejen päihin laskurit, jotka kertoo paljon meni eri päihin
logiikka joka teleporttaa tyypin jos lanesta on siirtymä toiseen

]]
