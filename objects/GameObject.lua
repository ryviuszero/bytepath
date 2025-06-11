GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    self.area = area
    self.x, self.y = x, y
    self.id = UUID()
    self.creation_time = love.timer.getTime()
    -- 为什么一个GameObject需要一个Timer？
    -- 可能是为了处理定时事件或动画？看起来是的，每个timer都需要调用update
    -- 以便更新定时器状态.
    self.timer = Timer()
    self.dead = false
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
    -- 在当前的代码中似乎没有出现 Collider的运用
    -- if self.collider then self.x, self.y = self.collider:getPosition() end ?
end

function GameObject:draw()
end

function GameObject:destroy()
    if self.timer then self.timer:clear() end
    -- if self.collider then self.collider:destroy() end
    self.collider = nil
end
