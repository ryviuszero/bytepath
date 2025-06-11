Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super:new(area, x, y, opts)

    self.w, self.h = 12, 12
    self.collider = self.area.world

end