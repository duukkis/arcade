local SCREEN_WIDTH = 640
local SCREEN_HEIGHT = 480

local BLUE = "blue"
local RED = "red"
local GREEN = "green"
local COLOR_COUNT = 3

local TO_RIGHT = 1
local TO_LEFT = -1

local CORRECT = "correct"
local WRONG = "wrong"

local CODES_IN_PROD_DISPLAY_SIZE = 5

local TILE_DIMENSION = 32
local MARGIN = 10
local PLAYER_BASELINE = SCREEN_HEIGHT - 170

local SPAWN_SEQUENCE_DELAY_SEC= 1

local player1 = {
    specs = {
        red = {},
        green = {},
        blue = {}
    },
    codes = {},
    codingDirection = TO_RIGHT,
    spawnTimer = 0
}

local player2 = {
    specs = {
        red = {},
        green = {},
        blue = {}
    },
    codes = {},
    codingDirection = TO_LEFT,
    spawnTimer = 0
}

local codesInProd = {}

local specImages = {}
local codeImages = {}

local scores = {
    implemented = 0,
    bugs = 0
}

function love.load()
    math.randomseed(os.time())
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle("ⓒⓞⓓⓔⓣⓡⓘⓢ")

    specImages[RED] = love.graphics.newImage("images/rosso.png")
    specImages[GREEN] = love.graphics.newImage("images/bene.png")
    specImages[BLUE] = love.graphics.newImage("images/azzurro.png")

    codeImages[CORRECT] = love.graphics.newImage("images/bene.png")
    codeImages[WRONG] = love.graphics.newImage("images/antibene.png")

    playerImage = love.graphics.newImage("images/sviluppatore.png")
end

function love.draw()
    drawInstructions()
    drawScoreboard(scores)
    drawProd(codesInProd, codeImages)

    drawThings(combineTables(player1.specs[RED], player1.specs[GREEN], player1.specs[BLUE],
                            player2.specs[RED], player2.specs[GREEN], player2.specs[BLUE]),
                            specImages)
    drawThings(combineTables(player1.codes, player2.codes), codeImages)

    drawImage(playerImage, 26, PLAYER_BASELINE)
    drawImage(playerImage, SCREEN_WIDTH - 26, PLAYER_BASELINE, 0, -1)
end

function love.update(dt)
    moveSpecs(player1, player2, dt)
    moveSpecs(player2, player1, dt)

    moveCodes(player1, dt)
    moveCodes(player2, dt)

    spawnSpecIfTimeIsRight(player1, MARGIN, dt)
    spawnSpecIfTimeIsRight(player2, SCREEN_WIDTH - (3 * TILE_DIMENSION) - MARGIN, dt)
end

function love.keypressed(key)
    if key == "z" then
        handleCoding(RED, player1, player2)
    end

    if key == "x" then
        handleCoding(GREEN, player1, player2)
    end

    if key == "c" then
        handleCoding(BLUE, player1, player2)
    end

    if key == "lshift" then
        handleReject(player1)
    end

    if key == "b" then
        handleCoding(RED, player2, player1)
    end

    if key == "n" then
        handleCoding(GREEN, player2, player1)
    end

    if key == "m" then
        handleCoding(BLUE, player2, player1)
    end

    if key == "rshift" then
        handleReject(player2)
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

function moveSpecs(coder, reviewer, dt)
    for key, coloredSpecs in pairs(coder.specs) do
        for index, spec in ipairs(coloredSpecs) do
            updateLocation(spec, dt)
            if isNoMoreCodable(spec) then
                table.remove(coloredSpecs, index)
                table.insert(reviewer.codes, createCode(false, coder.codingDirection))
            end
        end
    end

    -- for i=1, COLOR_COUNT, 1 do
    --     indexColor = getColorFromNumber(i)
    --     for index, spec in ipairs(coder.specs[indexColor]) do
    --         updateLocation(spec, dt)
    --         if isNoMoreCodable(spec) then
    --             table.remove(coder.specs[indexColor], index)
    --             table.insert(reviewer.codes, createCode(false, coder.codingDirection))
    --         end
    --     end
    -- end
end

function moveCodes(coder, dt)
    for index, code in ipairs(coder.codes) do
        updateLocation(code, dt)
        if isRejectable(code) then
            publishtoProd(code.image, codesInProd, scores)
            table.remove(coder.codes, index)
        end
    end
end

function spawnSpecIfTimeIsRight(player, location, dt)
    if player.spawnTimer > 0 then
        player.spawnTimer = player.spawnTimer - dt
    else
        createSpec(player, location)
        player.spawnTimer = SPAWN_SEQUENCE_DELAY_SEC
    end
end

function updateLocation(thing, dt)
    thing.yPos = thing.yPos + dt * thing.speedY
    thing.xPos = thing.xPos + dt * thing.speedX
end

function createSpec(player, xPos)
    colorIndex = math.random(COLOR_COUNT)
    color = getColorFromNumber(colorIndex)
    spec = {
        xPos = xPos + colorIndex * TILE_DIMENSION - TILE_DIMENSION,
        yPos = -10,
        speedY = 100,
        speedX = 0,
        image = color,
        width = TILE_DIMENSION,
        height = TILE_DIMENSION
    }

    table.insert(player.specs[color], spec)
end

function getColorFromNumber(num)
    if num == 1 then
        return RED
    elseif num == 2 then
        return GREEN
    else
        return BLUE
    end
end

function createCode(isCorrect, direction)
    local correctness = WRONG

    if isCorrect then
        correctness = CORRECT
    end

    if direction == TO_RIGHT then
        xPos = MARGIN + TILE_DIMENSION
        yPos = PLAYER_BASELINE
    else
        xPos = SCREEN_WIDTH - MARGIN - 2 * TILE_DIMENSION
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

function isRejectable(thing)
    return  thing.xPos < MARGIN + TILE_DIMENSION or
            thing.xPos > SCREEN_WIDTH - MARGIN - 2 * TILE_DIMENSION
end

function handleCoding(color, coder, reviewer)
    if noSpecsToCode(coder) then
        return
    end

    if table.getn(coder.specs[color]) > 0 and color == coder.specs[color][1].image then
        table.insert(reviewer.codes, createCode(true, coder.codingDirection))
    else
        table.insert(reviewer.codes, createCode(false, coder.codingDirection))
    end

    table.remove(coder.specs[color], 1)
    coder.spawnTimer = SPAWN_SEQUENCE_DELAY_SEC / 3
end

function noSpecsToCode(coder)
    return table.getn(coder.specs[BLUE]) == 0 and
            table.getn(coder.specs[RED]) == 0 and
            table.getn(coder.specs[GREEN]) == 0
end

function handleReject(player)
    if table.getn(player.codes) > 0 then
        table.remove(player.codes, 1)
    end
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

function drawInstructions()
    local leftPadding = 200
    love.graphics.print('player 1', leftPadding, 20)
    love.graphics.print('z = red, x = greeb, c = blue', leftPadding, 40)
    love.graphics.print('lshift = reject', leftPadding, 60)

    love.graphics.print('player 2', leftPadding, 100)
    love.graphics.print('b = red, n = green, m = blue', leftPadding, 120)
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
        xPos = 450 - i * (TILE_DIMENSION + MARGIN)
        drawImage(images[codesInProd[i]], xPos, SCREEN_HEIGHT - 40)
     end
end
