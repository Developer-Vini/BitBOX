local config = require("config")
local chart = require("chart")

local game = {}
local music = nil

function game.load()
    if love.filesystem.getInfo("music.ogg") then
        music = love.audio.newSource("music.ogg", "stream")
    end
end

function game.stop()
    if music then msuic:stop() end
end

function game.start()
    game.stop()
    game.notes = chart.createNotes()
    game.songTime = -config.startDelay
    game.paused = false
    game.score = 0
    game.maxCombo = 0
    game.musicStarted = false
    game.finished = false
    game.message = "Prepare!"
    game.counts = {
        perfect = 0,
        good = 0,
        miss = 0
    }
end
function game.togglePause()
    game.paused = not game.paused
    if music and game.musicStarted then
        if game.paused then
            music:pause()
        elseif game.songTime < music:getDuration() then
            music:play()
        end
    end
end

local function updateClock(dt)
    game.songTime = game.songTime + dt

    if music and not game.musicStarted and game.songTime >= 0 then
        music:play()
        game.musicStarted =  true
        game.songTime = 0
    end
    if music and music:isPlaying() then
        game.songTime = music:tell()
    end
end
function game.update(dt)
    if game.paused then return end

    updateClock(dt)

    local pending = 0

    for _, note in ipairs(game.notes) do
        if not note.done then
            if game.songTime - note.time > config.goodWindow then
                judge(note, "miss")
            else 
                pending = pending + 1
            end
        end
    end

    local last = game.notes[#game.notes]
    if pending == 0 and game.songTime > last.time + 2 then
        game.finished = true
        game.stop()
    end
end

local function judge(note, result)
    note.done = true
    game.counts[result] = game.counts[result] + 1

    if result == "miss" then
        game.combo = 0
    else
        game.combo = game.combo + 1
        game.maxCombo = math(game.maxCombo, game.combo)
        game.score = game.score + config[result .. "Points"]
    end

    game.message = string.upper(result)
end

function game.keypressed(key)
    if game.paused then return end

    for laneIndex, lane in ipairs(config.lanes) do
        if key == lane.key then
            for _, note in ipairs(game.notes) do
                if not note.done and note.lane == laneIndex then
                    local diff = math.abs(game.songTime - note.time)
                    if diff <= config.perfectWindow then
                        judge(note, "perfect")
                    elseif diff <= config.goodWindow then
                        judge(note, "good")
                    end
                    break
                end
            end
        end
    end
end

function game.draw()

    local width = config.laneWidht

    for i, lane in ipairs(config.lanes) do
        local x = config.laneX + (i - 1) * width
        local r, g, b = lane.color[1], lane.color[2], lane.color[3]
        local alpha = love.keyboard.isDown(lane.key) and 0.30 or 0.07
        
        love.graphics.setColor(r, g, b, alpha)
        love.graphics.rectangle("fill", x + 2, 0, width - 4, 600)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(string.upper(lane.key), x, config.lineY + 35, width, "center")
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.line(config.laneX, config.lineY, config.laneX + 4 * width, config.lineY)

    for _, note in ipairs(game.notes) do
        local y = config.lineY - (note.time - game.songTime) * config.speed

        if not note.done and y > -config.noteHeight and y < 600 + config.noteHeight then 
            local x = config.laneX + (note.lane - 1) * width
            love.graphics.setColor(config.lanes[note.lane].color)
            love.graphics.rectangle("fill", x + 8, y - config.noteHeight / 2, width - 16, config.noteHeight, 6, 6)
        end
    end

   love.graphics.setColor(0, 0, 1)
   love.graphics.print("Score: " .. game.score, 20, 20)
   love.graphics.print("Combo: " .. game.combo, 20, 45)
   love.graphics.print("Space: break", 20, 550)
   love.graphics.print("Esc: menu", 20, 570)
   love.graphics.print(game.message, config.laneX, 250, 4 * width, "center")
   
    if game.paused then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Stoped",0, 290, 800, "center")
    end
end
