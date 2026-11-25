function love.load()
    love.window.setTitle("BitBOX")
    lineY = 500
    score = 0
    mensage = "Press SPACE"
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


function love.draw()
   love.graphics.print('hello world!', 400, 300); 
end
