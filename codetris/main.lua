local SCREEN_WIDTH = 640
local SCREEN_HEIGHT = 480

local BLUE = "blue"
local RED = "red"
local YELLOW = "yellow"

local TO_RIGHT = 1
local TO_LEFT = -1

local CORRECT = "correct"
local WRONG = "wrong"

local CODES_IN_PROD_DISPLAY_SIZE = 5

local TILE_DIMENSION = 32
local PLAYER_BASELINE = SCREEN_HEIGHT - 170

local player1 = {
    specs = {},
    codes = {},
    codingDirection = TO_RIGHT
}

local player2 = {
    specs = {},
    codes = {},
    codingDirection = TO_LEFT
}

local codesInProd = {}

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
    drawProd(codesInProd, codeImages)

    drawThings(combineTables(player1.specs, player2.specs), specImages)
    drawThings(combineTables(player1.codes, player2.codes), codeImages)

    drawImage(playerImage, 10, PLAYER_BASELINE)
    drawImage(playerImage, SCREEN_WIDTH - 10, PLAYER_BASELINE, 0, -1)
end

function love.update(dt)
    moveSpecs(player1.specs, player2.codes, dt, TO_RIGHT)
    moveSpecs(player2.specs, player1.codes, dt, TO_LEFT)

    moveCodes(player1.codes, dt)
    moveCodes(player2.codes, dt)

    if spawnTimer > 0 then
        spawnTimer = spawnTimer - dt
    else
        table.insert(player1.specs, createSpec(10))
        table.insert(player2.specs, createSpec(SCREEN_WIDTH - TILE_DIMENSION - 10))
        spawnTimer = 1
    end
end

function love.keypressed(key)
    if key == "z" then
        handleCoding(BLUE, player1, player2)
    end

    if key == "x" then
        handleCoding(RED, player1, player2)
    end

    if key == "c" then
        handleCoding(YELLOW, player1, player2)
    end

    if key == "lshift" then
        handleReject(player1.codes)
    end

    if key == "b" then
        handleCoding(BLUE, player2, player1)
    end

    if key == "n" then
        handleCoding(RED, player2, player1)
    end

    if key == "m" then
        handleCoding(YELLOW, player2, player1)
    end

    if key == "rshift" then
        handleReject(player2.codes)
    end
end

function drawThings(things, thingImages)
    for _, thing in ipairs(things) do
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
            publishtoProd(code.image, codesInProd, scores)
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

function handleCoding(color, coder, reviewer)
    if table.getn(coder.specs) == 0 then
        return
    end

    if color == coder.specs[1].image then
        table.insert(reviewer.codes, createCode(true, coder.codingDirection))
    else
        table.insert(reviewer.codes, createCode(false, coder.codingDirection))
    end
    table.remove(coder.specs, 1)
end

function handleReject(codes)
    if #codes > 0 then
        table.remove(codes, 1)
    end
end

function combineTables(table1, table2)
    combined = {}
    for _, value in ipairs(table1) do
        table.insert(combined, value)
    end

    for _, value in ipairs(table2) do
        table.insert(combined, value)
    end

    return combined
end

function drawInstructions()
    local leftPadding = 200
    love.graphics.print('player 1', leftPadding, 20)
    love.graphics.print('z = blue, x = red, c = yellow', leftPadding, 40)
    love.graphics.print('lshift = reject', leftPadding, 60)

    love.graphics.print('player 2', leftPadding, 100)
    love.graphics.print('b = blue, n = red, m = yellow', leftPadding, 120)
    love.graphics.print('rshift = reject', leftPadding, 140)
end

function drawScoreboard(scores)
    love.graphics.print('Implemented ' .. scores.implemented, 200, 180)
    love.graphics.print('Bugs ' .. scores.bugs, 200, 200)
end

function publishtoProd(isCorrect, codesInProd, scores)
    if isCorrect == CORRECT then
        scores.implemented = scores.implemented + 1
    else
        scores.bugs = scores.bugs + 1
    end

    table.insert(codesInProd, isCorrect)
    if #codesInProd > CODES_IN_PROD_DISPLAY_SIZE then
        table.remove(codesInProd, 1)
    end
end

function drawProd(codesInProd, images)
     for i = #codesInProd, 1, -1 do
        xPos = 450 - i * (TILE_DIMENSION + 10)
        drawImage(images[codesInProd[i]], xPos, SCREEN_HEIGHT - 40)
     end
end
