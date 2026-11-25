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
    note.y += note.velocity * dt

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
            score += 1
            message = "GOT IT RIGHT"
            note.y = 0
        else
            message = "out of time"
        end
    end
end

function love.draw()
   love.graphics.print('hello world!', 400, 300); 
end
