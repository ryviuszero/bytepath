Room = Object:extend()

function Room:new()
    -- 似乎有循环引用的问题？
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.main_canvas = love.graphics.newCanvas(gw, gh)
end

function Room:update(dt)
    self.area:update(dt)
end

function Room:draw()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

end

function Room:destory()
    self.area:destory()
    self.area = nil
end

Stage = Room:extend()

function Stage:new()
    Stage.super:new()
    self.area:addGameObject('Player', gw / 2, gh / 2)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
        self.area:draw()
    camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')

end
