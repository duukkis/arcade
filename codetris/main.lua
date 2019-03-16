local screen_width = 640
local screen_height = 480

local BLUE = "blue"
local RED = "red"
local YELLOW = "yellow"

local CORRECT = "correct"
local WRONG = "wrong"

local specs = {}
local codes = {}

local specImages = {}
local codeImages = {}

local spawnTimer = 0

function love.load()
    math.randomseed(os.time())
    love.window.setMode(screen_width, screen_height)

    specImages[BLUE] = love.graphics.newImage("images/bleu.png")
    specImages[RED] = love.graphics.newImage("images/rod.png")
    specImages[YELLOW] = love.graphics.newImage("images/yello.png")

    codeImages[CORRECT] = love.graphics.newImage("images/bene.png")
    codeImages[WRONG] = love.graphics.newImage("images/male.png")
end

function love.draw()
    love.graphics.print('z = blue, x = red, c = yellow', 200, 40)
    drawSpecs(specs, specImages)
    drawCodes(codes, codeImages)
end

function love.update(dt)
    for index, spec in ipairs(specs) do
        updateLocation(spec, dt)
        if isOutOfBounds(spec) then
            table.remove(specs, index)
        end
    end

    for index, code in ipairs(codes) do
        updateLocation(code, dt)

    end

    if spawnTimer > 0 then
        spawnTimer = spawnTimer - dt
    else
        table.insert(specs, createSpec())
        spawnTimer = 1
    end
end

function drawSpecs(specs, specImages)
    for index, spec in ipairs(specs) do
        drawImage(specImages[spec.image], spec.xPos, spec.yPos)
    end
end

function drawCodes(codes, codeImages)
    for index, code in ipairs(codes) do
        drawImage(codeImages[code.image], code.xPos, code.yPos)
    end
end

function drawImage(image, x, y)
    love.graphics.draw(image, x, y)
end

function updateLocation(thing, dt)
    thing.yPos = thing.yPos + dt * thing.speedY
    thing.xPos = thing.xPos + dt * thing.speedX
end

function createSpec()
    return {
        xPos = 10,
        yPos = -10,
        speedY = 100,
        speedX = 0,
        image = getColorFromNumber(math.random(3))
    }
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

function createCode(isCorrect)
    code = {
        xPos = 10,
        yPos = screen_height - 32 - 10,
        speedY = 0,
        speedX = 100
    }
    if isCorrect then
        code.image = CORRECT
    else
        code.image = WRONG
    end

    return code
end

function isOutOfBounds(spec)
    return spec.yPos > screen_height - 32
end
