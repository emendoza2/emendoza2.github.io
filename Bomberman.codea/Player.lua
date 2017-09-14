Player = class()

function Player:init(x,y,world,avatar)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.world = world
    self.w = self.world
    self.ww = #assert(self.w[1],"invalid world grid provided (error code 2)")
    self.wh = #assert(self.w,"invalid world grid provided (error code 1)")
    self.constant = math.min(WIDTH/self.ww,HEIGHT/self.wh)
    self.gx = (self.x-1)*self.constant
    self.gy = HEIGHT-self.y*self.constant
    self.avatar = avatar or "Planet Cute:Character Boy"
end

function Player:draw()
    
    -- Check if hit by explosion
    for i,e in ipairs(explosions) do
        local ac = e.affectedCells
        for y,r in pairs(ac) do
            for x,v in pairs(r) do
                if self.x == x and self.y == y then self:die() end
            end
        end
    end
    pushStyle()
    zLevel(self.y)
    if self.dead then
        tint(73, 48, 42, 255)
    end
    sprite(self.avatar,self.gx+self.constant/2,self.gy+self.constant*0.7,self.constant)
    setContext()
    popStyle()
    if self.dead and false then
        zLevel(self.wh)
        pushMatrix()
        pushStyle()
        fill(255, 60, 0, 255)
        translate(WIDTH/2,HEIGHT/2)
        rotate(math.random(0,30))
        fontSize(100)
        font("GillSans-Bold")
        text("DEAD",0,0)
        popStyle()
        popMatrix()
        setContext()
    end
end

function Player:move(dir)
    if self.canMove == nil or self.canMove then
        if dir == 1 and self.world[self.y][self.x-1] and not Blocks[self.world[self.y][self.x-1]].impassable then
            self.x = self.x - 1
            self.canMove = false
            tween(0.2,self,{gx = (self.x-1)*self.constant},tween.easing.cubicOut,
            function() 
                self.canMove = true
            end)
        end
        if dir == 2 and self.world[self.y-1] and not Blocks[self.world[self.y-1][self.x]].impassable then
            self.canMove = false
            tween(0.2,self,{gy = HEIGHT-(self.y-1)*self.constant},tween.easing.cubicOut,
            function() 
                self.y = self.y - 1
                self.canMove = true
            end)
        end
        if dir == 3 and self.world[self.y][self.x+1] and not Blocks[self.world[self.y][self.x+1]].impassable then
            self.x = self.x + 1
            self.canMove = false
            tween(0.2,self,{gx = (self.x-1)*self.constant},tween.easing.cubicOut,
            function() 
                self.canMove = true
            end)
        end
        if dir == 4 and self.world[self.y+1] and not Blocks[self.world[self.y+1][self.x]].impassable then
            self.y = self.y + 1
            self.canMove = false
            tween(0.2,self,{gy = HEIGHT-(self.y)*self.constant},tween.easing.cubicOut,
            function() 
                self.canMove = true
            end)
        end
    end
end

function Player:die()
    self.dead = true
    self.drop = function()end
    self.move = function()end
end

function Player:drop()
    -- Drop a bomb if there is no bomb in the space already
    if not (bombs[self.y] and bombs[self.y][self.x]) then
        print("Bomb dropped")
        local t = math.random(100,200)
        bombs[self.y] = bombs[self.y] or {}
        bombs[self.y][self.x] = {t,t}
    end
end

function Player:touched(touch)
    -- Codea does not automatically call this method
end
