local screen_width = 640
local screen_height = 480

local BLUE = "blue"
local RED = "red"
local YELLOW = "yellow"

local specs = {}

function love.load()
    math.randomseed(os.time())
    love.window.setMode(screen_width, screen_height)

    specImages = {}
    specImages[BLUE] = love.graphics.newImage("images/bleu.png")
    specImages[RED] = love.graphics.newImage("images/rod.png")
    specImages[YELLOW] = love.graphics.newImage("images/yello.png")

    table.insert(specs, createSpec())
end

function love.draw()
    drawSpecs(specs, specImages)
end

function love.update(dt)
    updateSpecs(specs, dt)
end

function drawSpecs(specs, specImages)
    for index, spec in ipairs(specs) do
        love.graphics.draw(specImages[spec.specImage], spec.xPos, spec.yPos)
    end
end

function updateSpecs(specs, dt)
    spec.yPos = spec.yPos + dt * spec.speed
end

function createSpec()
    spec = {}
    spec.xPos = 10
    spec.yPos = -10
    spec.speed = 100
    spec.specImage = getColorFromNumber(math.random(3))
    return spec
end

function getColorFromNumber(num)
    if num == 1 then
        return BLUE
    elseif num == 2 then
        return RED
    else
        return YELLOW
    end
end
