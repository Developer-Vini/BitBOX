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

function love.load()
    love.window.setTitle("BitBOX")
    lineY = 500
    score = 0
    message = "Press SPACE"
    note = {
        x = 375,
        y = 0,
        width = 50,
        height = 50,
        velocity = 300
    }
end

function love.update(dt)
    note.y = note.y + note.velocity * dt

    if note.y > 600 then
        note.y = 0
        message = "Error you passed straight"
    end
end

function love.keypressed(key)
    if key == "space" then
        local centerNote = note.y + (note.height /2)
        local distance = math.abs(centerNote - lineY)

        if distance <= 40 then
            score = score + 1
            message = "GOT IT RIGHT"
            note.y = 0
        else
            message = "out of time"
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
