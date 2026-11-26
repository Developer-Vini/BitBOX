local game = require("game")

local state = "menu"
local fonts = {}

local function centerText(text, y, font)
    love.graphics.setFont(font)
    love.graphics.printf(text, 0, y, 800, "center")
end
function love.update(dt)
    if state == "playing" then
        game.update(dt)
        if game.finished then
            state = "results"
        end
    end
end

function love.load()
    fonts.big = love.graphics.newFont(40)
    fonts.normal = love.graphics.newFont(16)
    love.graphics.setBackgroundColor(0.06, 0.05, 0.10)
    game.load()
end

function love.keypressed(key)
    if state == "menu" then
        if key == "return" then
            game.start()
            state = "playing"
        elseif key == "escape" then
            love.event.quit()
        end
    elseif state == "playing" then
        if key == "escape" then
            game.stop()
            state = "menu"
        elseif key == "space" then
            game.togglePause()
        else
            game.keypressed(key)
        end
    elseif state == "results" then
        if key == "return" then
            game.start()
            state ="playing"
        elseif key == "escape" then
            state = "menu"
        end
    end
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(fonts.normal)

    if state == "menu" then
        centerText("BitBOX", 150, fonts.big)
        centerText("Enter: Play    Esc: quit", 360, fonts.normal)
    elseif state == "playing" then
        game.draw()
    elseif state == "results" then
        centerText("Finished", 80, fonts.big)
        centerText("Score:" .. game.score, 200, 220)
        centerText("Perfect: " .. game.counts.perfect, 300, fonts.normal)
        centerText("Combo: " .. game.maxCombo, 240, fonts.normal)
        centerText("Good: " ..game.counts.good, 330, fonts.normal)
        centerText("Miss: " .. game.counts.miss, 360, fonts.normal)
        centerText("Enter: play again   Esc: menu", 460, fonts.normal)
    end
end