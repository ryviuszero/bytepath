if arg[2] == "debug" then
  require("lldebugger").start()
end

Object = require 'libraries.classic.classic'
Camera = require "libraries.hump.camera"
Input = require 'libraries.boipushy.Input'
Shake = require 'objects.Shake'

require 'objects.GameObject'
require 'utils'

input = Input()
camera = Camera()


function love.load()
    input:bind('f3', function() camera:shake(10, 60, 1) end)
    print("hello world")
end

function love.update(dt)

end

function love.draw()
    love.graphics.circle('fill', gw/2, gh/2, 50)
end



local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
