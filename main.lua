if arg[2] == "debug" then
  require("lldebugger").start()
end

Object = require 'libraries/classic/classic'
Timer = require 'libraries/enhanced_timer/EnhancedTimer'
Input = require 'libraries/boipushy/Input'
fn = require 'libraries/moses/moses'
Camera = require 'libraries/hump/camera'
Physics = require 'libraries/windfield'



require 'objects.Shake'
require 'objects.GameObject'
require 'utils'




function love.load()
    timer = Timer()
    input = Input()
    camera = Camera()

    input:bind('a', function() print("enter a")end)
    input:bind('f3', function() 
        print("enter f3")
        camera:shake(4, 60, 1) end)
    print("hello world")
    -- camera:shake(100, 60, 100)
end

function love.update(dt)
    -- camera:shake(1, 60, 1)
    timer:update(dt)
    camera:update(dt)
end

function love.draw()
    camera:attach(0, 0, gw, gh)
    love.graphics.circle('line', gw/2, gh/2, 50)
        -- self.area:draw()
  	camera:detach()
    -- love.graphics.circle('fill', gw/2, gh/2, 50)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    -- love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end



local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
