Room = Object:extend()

function Room:new()
    -- 似乎有循环引用的问题？
    self.area = Area(self)

end