local SCREEN_WIDTH = 480
local SCREEN_HEIGHT = 640

local BLUE = "blue"
local RED = "red"
local GREEN = "green"
local YELLOW = "yellow"

local ON = "on"
local OFF = "off"


local BACKGROUND = "background"
local LANES = "lanes"

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
    initGates()
end

function love.draw()
    drawImage(images[BACKGROUND])
    drawImage(images[LANES])
    drawGates()
end

function love.update(dt)

end

function love.keypressed(key)
    if key == "1" then
        toggleGates(BLUE)
    elseif key == "2" then
        toggleGates(RED)
    elseif key == "3" then
        toggleGates(YELLOW)
    elseif key == "4" then
        toggleGates(GREEN)
    end
end

function initGates()
    gates[BLUE] = false
    images[ON][BLUE] = love.graphics.newImage("images/blue_on.png")
    images[OFF][BLUE] = love.graphics.newImage("images/blue_off.png")

    gates[RED] = false
    images[ON][RED] = love.graphics.newImage("images/red_on.png")
    images[OFF][RED] = love.graphics.newImage("images/red_off.png")

    gates[GREEN] = false
    images[ON][GREEN] = love.graphics.newImage("images/green_on.png")
    images[OFF][GREEN] = love.graphics.newImage("images/green_off.png")

    gates[YELLOW] = false
    images[ON][YELLOW] = love.graphics.newImage("images/yellow_on.png")
    images[OFF][YELLOW] = love.graphics.newImage("images/yellow_off.png")
end

function toggleGates(gate)
    if gates[gate] then
        gates[gate] = false
        return
    end
    gates[gate] = true
end

function drawGates()
    drawGate(BLUE, gates[BLUE])
    drawGate(RED, gates[RED])
    drawGate(YELLOW, gates[YELLOW])
    drawGate(GREEN, gates[GREEN])
end


function drawGate(color, isOn)
    if isOn then
        drawImage(images[ON][color])
    else
        drawImage(images[OFF][color])
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

--[[

TODO
arvo mistä tulee ukkeli
liikuttele sitä alas
tee lanejen päihin laskurit, jotka kertoo paljon meni eri päihin
logiikka joka teleporttaa tyypin jos lanesta on siirtymä toiseen

]]
