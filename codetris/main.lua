local SCREEN_WIDTH = 640
local SCREEN_HEIGHT = 480

local BLUE = "blue"
local RED = "red"
local YELLOW = "yellow"

local TO_RIGHT = 1
local TO_LEFT = -1

local CORRECT = "correct"
local WRONG = "wrong"

local TILE_DIMENSION = 32
local PLAYER_BASELINE = SCREEN_HEIGHT - 150

local player1Specs = {}
local player2Specs = {}
local player1Codes = {}
local player2Codes = {}

local specImages = {}
local codeImages = {}

local spawnTimer = 0

local scores = {
    implemented = 0,
    bugs = 0
}

function love.load()
    math.randomseed(os.time())
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle("ⓒⓞⓓⓔⓣⓡⓘⓢ")

    specImages[BLUE] = love.graphics.newImage("images/azzurro.png")
    specImages[RED] = love.graphics.newImage("images/rosso.png")
    specImages[YELLOW] = love.graphics.newImage("images/giallo.png")

    codeImages[CORRECT] = love.graphics.newImage("images/bene.png")
    codeImages[WRONG] = love.graphics.newImage("images/antibene.png")

    playerImage = love.graphics.newImage("images/sviluppatore.png")
end

function love.draw()
    drawInstructions()
    drawScoreboard(scores)

    drawThings(combineTables(player1Specs, player2Specs), specImages)
    drawThings(combineTables(player1Codes, player2Codes), codeImages)

    drawImage(playerImage, 10, PLAYER_BASELINE)
    drawImage(playerImage, SCREEN_WIDTH - 10, PLAYER_BASELINE, 0, -1)
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
        table.insert(player2Specs, createSpec(SCREEN_WIDTH - 40))
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

    if key == "lshift" then
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

    if key == "rshift" then
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
         if isNoMoreCodable(spec) then
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
                scores.implemented = scores.implemented + 1
            else
                scores.bugs = scores.bugs + 1
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
        width = TILE_DIMENSION,
        height = TILE_DIMENSION
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
        yPos = PLAYER_BASELINE
    else
        xPos = SCREEN_WIDTH - 10
        yPos = PLAYER_BASELINE + TILE_DIMENSION
    end

    return {
        xPos = xPos,
        yPos = yPos,
        speedY = 0,
        speedX = 100 * direction,
        image = correctness,
        width = TILE_DIMENSION,
        height = TILE_DIMENSION
    }
end

function isNoMoreCodable(thing)
    return thing.yPos > PLAYER_BASELINE
end


function isOutOfBounds(thing)
    return  thing.xPos < 0 or
            thing.xPos > SCREEN_WIDTH
end

function handleCoding(color, specs, resultCodes, direction)
    if #specs == 0 then
        return
    end
    if color == specs[1].image then
        table.insert(resultCodes, createCode(true, direction))
    else
        table.insert(resultCodes, createCode(false, direction))
    end
    table.remove(specs, 1)
end

function handleReject(codes)
    if #codes > 0 then
        table.remove(codes, 1)
    end
end

function combineTables(table1, table2)
    combined = {}
    for k, value in ipairs(table1) do
        table.insert(combined, value)
    end

    for k, value in ipairs(table2) do
        table.insert(combined, value)
    end

    return combined
end

function drawInstructions()
    love.graphics.print('player 1', 200, 20)
    love.graphics.print('z = blue, x = red, c = yellow', 200, 40)
    love.graphics.print('lshift = reject', 200, 60)

    love.graphics.print('player 2', 200, 100)
    love.graphics.print('b = blue, n = red, m = yellow', 200, 120)
    love.graphics.print('rshift = reject', 200, 140)
end

function drawScoreboard(scores)
    love.graphics.print('Implemented ' .. scores.implemented, 200, 180)
    love.graphics.print('Bugs ' .. scores.bugs, 200, 200)
end
