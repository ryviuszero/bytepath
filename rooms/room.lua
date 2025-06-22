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

function Room:destroy()
    self.area:destroy()
    self.area = nil
end

Stage = Room:extend()

function Stage:new()
    Stage.super.new(self)
    -- 碰撞的分层？
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})


    self.player = self.area:addGameObject('Player', gw / 2, gh / 2)

    -- input:bind('p', function() self.area:addGameObject('Boost', 0, 0) end)
    -- input:bind('o', function() self.area:addGameObject('Shooter', 0, 0) end)

    self.font = fonts.m5x7_16
    self.director = Director(self)

    self.score = 0

end

function Stage:update(dt)
    self.director:update(dt)

    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw/2, gh/2)


    Stage.super.update(self, dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        camera:attach(0, 0, gw, gh)
        self.area:draw()
        camera:detach()

        love.graphics.setFont(self.font)

        -- Score
        love.graphics.setColor(default_color)
        love.graphics.print(self.score, gw - 20, 10, 0, 1, 1, math.floor(self.font:getWidth(self.score)/2), math.floor(self.font:getHeight()/2))
        love.graphics.setColor(1, 1, 1)

        -- Skill points
        love.graphics.setColor(skill_point_color)
        love.graphics.print(skill_points .. 'SP', 10, 10, 0, 1, 1, 0, math.floor(self.font:getHeight()/2))
        love.graphics.setColor(1, 1, 1)

        -- Ammo
        local r, g, b = unpack(ammo_color)
        local ammo, max_ammo = self.player.ammo, self.player.max_ammo
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2 - 52, 16, 48*(ammo/max_ammo), 4)
        love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
        love.graphics.rectangle('line', gw/2 - 52, 16, 48, 4)
        love.graphics.print('AMMO', gw/2 - 52 + 24, 26, 0, 1, 1, math.floor(self.font:getWidth('AMMO')/2), math.floor(self.font:getHeight()/2))
        love.graphics.print(ammo .. '/' .. max_ammo, gw/2 - 52 + 24, 8, 0, 1, 1, math.floor(self.font:getWidth(ammo .. '/' .. max_ammo)/2), math.floor(self.font:getHeight()/2))
        love.graphics.setColor(1, 1, 1)

        -- HP
        local r, g, b = unpack(hp_color)
        local hp, max_hp = self.player.hp, self.player.max_hp
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2 - 52, gh - 16, 48*(hp/max_hp), 4)
        love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
        love.graphics.rectangle('line', gw/2 - 52, gh - 16, 48, 4)
        love.graphics.print('HP', gw/2 - 52 + 24, gh - 24, 0, 1, 1, math.floor(self.font:getWidth('HP')/2), math.floor(self.font:getHeight()/2))
        love.graphics.print(hp .. '/' .. max_hp, gw/2 - 52 + 24, gh - 6, 0, 1, 1, math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2), math.floor(self.font:getHeight()/2))
        love.graphics.setColor(1, 1, 1)

        -- Boost 
        local r, g, b = unpack(boost_color)
        local boost, max_boost = self.player.boost, self.player.max_boost
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2 + 4, 16, 48*(boost/max_boost), 4)
        love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
        love.graphics.rectangle('line', gw/2 + 4, 16, 48, 4)
        love.graphics.print('BOOST', gw/2 + 4 + 24, 26, 0, 1, 1, math.floor(self.font:getWidth('AMMO')/2), math.floor(self.font:getHeight()/2))
        love.graphics.print(math.floor(boost) .. '/' .. math.floor(max_boost), gw/2 + 4 + 24, 8, 
        0, 1, 1, math.floor(self.font:getWidth(math.floor(boost) .. '/' .. math.floor(max_boost))/2), math.floor(self.font:getHeight()/2))
        love.graphics.setColor(1, 1, 1)

        -- Cycle
        local r, g, b = unpack(default_color)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2 + 4, gh - 16, 48*(self.player.tick_timer/self.player.tick_cooldown), 4)
        love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
        love.graphics.rectangle('line', gw/2 + 4, gh - 16, 48, 4)
        love.graphics.print('CYCLE', gw/2 + 4 + 24, gh - 24, 0, 1, 1, math.floor(self.font:getWidth('CYCLE')/2), math.floor(self.font:getHeight()/2))
        love.graphics.setColor(1, 1, 1)

    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')

end


function Stage:finish()
    timer:after(1, function()
        gotoRoom('Stage')
    end)
end