local game = require("main")

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
    fonts.big = love.graphics.newFont(56)
    fonts.graphics.setBackgroundColor(0.06, 0.05, 0.10)
    game.load()
end
