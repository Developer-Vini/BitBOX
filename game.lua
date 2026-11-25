local game = require("main")

local state = "menu"
local fonts = {}

local function centerText(text, y, font)
    love.graphics.setFont(font)
    love.graphics.printf(text, 0, y, 800, "center")
end