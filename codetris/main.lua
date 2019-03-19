local screenWidth = 640
local screenHeight = 480

local BLUE = "blue"
local RED = "red"
local YELLOW = "yellow"

local TO_RIGHT = 1
local TO_LEFT = -1

local CORRECT = "correct"
local WRONG = "wrong"

local player1Specs = {}
local player2Specs = {}
local player1Codes = {}
local player2Codes = {}

local specImages = {}
local codeImages = {}

local spawnTimer = 0

local correctlyImplemented = 0
local bugsInProduction = 0

function love.load()
    math.randomseed(os.time())
    love.window.setMode(screenWidth, screenHeight)
    love.window.setTitle("ⓒⓞⓓⓔⓣⓡⓘⓢ")

    specImages[BLUE] = love.graphics.newImage("images/bleu.png")
    specImages[RED] = love.graphics.newImage("images/rod.png")
    specImages[YELLOW] = love.graphics.newImage("images/yello.png")

    codeImages[CORRECT] = love.graphics.newImage("images/bene.png")
    codeImages[WRONG] = love.graphics.newImage("images/antibene.png")

    guy = love.graphics.newImage("images/old-guy.png")
end

function love.draw()
    drawInstructions()
    drawScoreboard(correctlyImplemented, bugsInProduction)

    drawThings(combineTables(player1Specs, player2Specs), specImages)
    drawThings(combineTables(player1Codes, player2Codes), codeImages)

    drawImage(guy, 10, screenHeight - 30)
    drawImage(guy, screenWidth - 10, screenHeight - 30, 0, -1)
end

function love.update(dt)
    moveSpecs(player1Specs, player2Codes, dt, TO_RIGHT)
    moveSpecs(player2Specs, player1Codes, dt, TO_LEFT)

    moveCodes(player1Codes, dt)
    moveCodes(player2Codes, dt)

    if spawnTimer > 0 then
        spawnTimer = spawnTimer - dt
    else
        table.insert(player1Specs, createSpec(10))
        table.insert(player2Specs, createSpec(screenWidth - 40))
        spawnTimer = 1
    end
end

function love.keypressed(key)
    if key == "z" then
        handleCoding(BLUE, player1Specs, player2Codes, TO_RIGHT)
    end

    if key == "x" then
        handleCoding(RED, player1Specs, player2Codes, TO_RIGHT)
    end

    if key == "c" then
        handleCoding(YELLOW, player1Specs, player2Codes, TO_RIGHT)
    end

    if key == "a" then
        handleReject(player1Codes)
    end

    if key == "b" then
        handleCoding(BLUE, player2Specs, player1Codes, TO_LEFT)
    end

    if key == "n" then
        handleCoding(RED, player2Specs, player1Codes, TO_LEFT)
    end

    if key == "m" then
        handleCoding(YELLOW, player2Specs, player1Codes, TO_LEFT)
    end

    if key == "k" then
        handleReject(player2Codes)
    end
end

function drawThings(things, thingImages)
    for index, thing in ipairs(things) do
        drawImage(thingImages[thing.image], thing.xPos, thing.yPos)
    end
end

function drawImage(image, x, y, r, sx, sy)
    r = r or 0
    sx = sx or 1
    sy = sy or 1
    love.graphics.draw(image, x, y, r, sx, sy)
end

function moveSpecs(specs, resultCodes, dt, direction)
    for index, spec in ipairs(specs) do
        updateLocation(spec, dt)
         if isOutOfBounds(spec) then
            table.remove(specs, index)
            table.insert(resultCodes, createCode(false, direction))
        end
    end
end

function moveCodes(codes, dt)
    for index, code in ipairs(codes) do
        updateLocation(code, dt)
        if isOutOfBounds(code) then
            if code.image == CORRECT then
                correctlyImplemented = correctlyImplemented + 1
            else
                bugsInProduction = bugsInProduction + 1
            end

            table.remove(codes, index)
        end
    end
end

function updateLocation(thing, dt)
    thing.yPos = thing.yPos + dt * thing.speedY
    thing.xPos = thing.xPos + dt * thing.speedX
end

function createSpec(xPos)
    return {
        xPos = xPos,
        yPos = -10,
        speedY = 100,
        speedX = 0,
        image = getColorFromNumber(math.random(3)),
        width = 32,
        height = 32
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

function createCode(isCorrect, direction)
    local correctness = WRONG

    if isCorrect then
        correctness = CORRECT
    end

    if direction == TO_RIGHT then
        xPos = 10
    else
        xPos = screenWidth - 10
    end

    return {
        xPos = xPos,
        yPos = screenHeight - 32 - 10,
        speedY = 0,
        speedX = 100 * direction,
        image = correctness,
        width = 32,
        height = 32
    }
end

function isOutOfBounds(thing)
    return thing.yPos > screenHeight - thing.height or
            thing.xPos < 0 or
            thing.xPos > screenWidth
end

function handleCoding(color, specs, resultCodes, direction)
    for index, spec in ipairs(specs) do -- aargh!
        if color == spec.image then
            table.insert(resultCodes, createCode(true, direction))
        else
            table.insert(resultCodes, createCode(false, direction))
        end
        table.remove(specs, index)
        break
    end
end

function handleReject(codes)
    for index, code in ipairs(codes) do -- aargh!
        if WRONG == code.image then
            table.remove(codes, index)
        end
        break
    end
end

function combineTables(t1, t2)
    combined = {}
    for k, value in ipairs(t1) do
        table.insert(combined, value)
    end

    for k, value in ipairs(t2) do
        table.insert(combined, value)
    end

    return combined
end


function drawInstructions()
    love.graphics.print('player 1', 200, 20)
    love.graphics.print('z = blue, x = red, c = yellow', 200, 40)
    love.graphics.print('a = reject errornous', 200, 60)

    love.graphics.print('player 2', 200, 100)
    love.graphics.print('b = blue, n = red, m = yellow', 200, 120)
    love.graphics.print('k = reject errornous', 200, 140)
end

function drawScoreboard(eka, toka)
    love.graphics.print('Implemented ' .. eka, 200, 180)
    love.graphics.print('Bugs ' .. toka, 200, 200)
end
