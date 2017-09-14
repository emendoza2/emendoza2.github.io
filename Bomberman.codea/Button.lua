Button = class()

function Button:init(x,y,c,d)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.c = c
    self.d = d
    -- make this touchable
    table.insert(touchables,self)
end

function Button:draw()
    -- Codea does not automatically call this method
    self:d()
end

function Button:touched(t)
    -- Codea does not automatically call this method
    local s = self
    if t.state==BEGAN and t.x > s.x - 20 and t.x < s.x + 20 and t.y > s.y - 20 and t.y < s.y + 20 then
        self.c()
        return true
    end
end

function drawDown(self)
    pushStyle()
    fontSize(40)
    text("🔽",self.x,self.y)
    popMatrix()
end

function drawUp(self)
    pushStyle()
    fontSize(40)
    text("🔼",self.x,self.y)
    popMatrix()
end

function drawRight(self)
    pushStyle()
    fontSize(40)
    text("▶️",self.x,self.y)
    popMatrix()
end

function drawLeft(self)
    pushStyle()
    fontSize(40)
    text("◀️",self.x,self.y)
    popMatrix()
end

function drawDrop(self)
    pushStyle()
    fontSize(40)
    text("⏹",self.x,self.y)
    popMatrix()
end