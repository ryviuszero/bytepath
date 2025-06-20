EnemyProjectile = GameObject:extend()

function EnemyProjectile:new(area, x, y, opts)
    EnemyProjectile.super.new(self, area, x, y, opts)

    self.s = opts.s or 2.5
    self.v = opts.v or 200

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setCollisionClass('EnemyProjectile')
    self.collider:setLinearVelocity(
        self.v * math.cos(self.r),
        self.v * math.sin(self.r)
    )

    self.damage = 10
end

