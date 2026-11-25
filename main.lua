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
    game.songTime = game.songTime + * dt

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

function love.draw()
--    love.graphics.print('hello world!', 400, 300); 
   love.graphics.setColor(1, 1, 1)
   love.graphics.line(100, lineY, 700, lineY)

   love.graphics.setColor(0, 0, 1)
   love.graphics.rectangle("fill", note.x, note.y, note.width, note.height)

   love.graphics.setColor(1, 1, 1)
   love.graphics.print("score: " .. score, 20, 20)
   love.graphics.print(message, 20, 50)
end
