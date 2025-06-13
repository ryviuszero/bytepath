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
    circle = {radius = 24}
    timer:tween(6, circle, {radius = 96}, 'in-out-cubic')
end

function love.update(dt)
    -- camera:shake(1, 60, 1)
    timer:update(dt)
end

function love.draw()
    love.graphics.circle('fill', gw / 2 , gh / 2, circle.radius)
end



local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
