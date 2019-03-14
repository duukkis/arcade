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

function love.load()
    math.randomseed(os.time())
    love.window.setMode(screen_width, screen_height)

    specImages[BLUE] = love.graphics.newImage("images/bleu.png")
    specImages[RED] = love.graphics.newImage("images/rod.png")
    specImages[YELLOW] = love.graphics.newImage("images/yello.png")

    codeImages[CORRECT] = love.graphics.newImage("images/bene.png")
    codeImages[WRONG] = love.graphics.newImage("images/male.png")

    table.insert(specs, createSpec())
    table.insert(codes, createCode(true))
end

function love.draw()
    love.graphics.print('z = blue, x = red, c = yellow', 200, 40)
    drawSpecs(specs, specImages)
    drawCodes(codes, codeImages)
end

function love.update(dt)
    for index, spec in ipairs(specs) do
        updateLocation(spec, dt)
    end

    for index, code in ipairs(codes) do
        updateLocation(code, dt)
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
    spec = {}
    spec.xPos = 10
    spec.yPos = -10
    spec.speedY = 100
    spec.speedX = 0
    spec.image = getColorFromNumber(math.random(3))
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

function createCode(isCorrect)
    code = {}
    code.xPos = 10
    code.yPos = screen_height - 32 - 10
    code.speedY = 0
    code.speedX = 100

    if isCorrect then
        code.image = CORRECT
    else
        code.image = WRONG
    end

    return code
end
