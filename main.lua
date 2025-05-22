if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
   image = love.graphics.newImage("assets/demo.jpg")
end

function love.update(dt)
    
end

function  love.draw()
    love.graphics.draw(image, love.math.random(0, 800), love.math.random(0, 600))

    -- love.graphics.draw(image,0, 0)
end
