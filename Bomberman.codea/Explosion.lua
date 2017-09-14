Explosion = class()

function Explosion:init(x,y,world)
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
    self.range = math.random(5,7)
    self.lengths = {}
    self.affectedCells = {}
    for i = 1, 4 do
        self.lengths[i] = 0
    end
    -- Explode out (this should be simpler)
    sound(SOUND_EXPLODE, 35875)
    for i = 1, self.range do
        local x,y = self.x-i, self.y
        local r = (self.world[y] or {})
        local v = r[x]
        if v and Blocks[v].breakable then
            r[x] = 1
        end
        if (not v) or (Blocks[v].impassable) then
            break
        end
        self.lengths[1] = i
        self.affectedCells[y] = self.affectedCells[y] or {}
        self.affectedCells[y][x] = {self.range-i+1}
    end
    for i = 1, self.range do
        local x,y = self.x, self.y-i
        local r = (self.world[y] or {})
        local v = r[x]
        if v and Blocks[v].breakable then
            r[x] = 1
        end
        if (not v) or (Blocks[v].impassable) then
            break
        end
        self.lengths[2] = i
        self.affectedCells[y] = self.affectedCells[y] or {}
        self.affectedCells[y][x] = {self.range-i+1}
    end
    for i = 1, self.range do
        local x,y = self.x+i, self.y
        local r = (self.world[y] or {})
        local v = r[x]
        if v and Blocks[v].breakable then
            r[x] = 1
        end
        if (not v) or (Blocks[v].impassable) then
            break
        end
        self.lengths[3] = i
        self.affectedCells[y] = self.affectedCells[y] or {}
        self.affectedCells[y][x] = {self.range-i+1}
    end
    for i = 1, self.range do
        local x,y = self.x, self.y+i
        local r = (self.world[y] or {})
        local v = r[x]
        if v and Blocks[v].breakable then
            r[x] = 1
        end
        if (not v) or (Blocks[v].impassable) then
            break
        end
        self.lengths[4] = i
        self.affectedCells[y] = self.affectedCells[y] or {}
        self.affectedCells[y][x] = {self.range-i+1}
    end
    self.affectedCells[self.y] = self.affectedCells[self.y] or {}
    self.affectedCells[self.y][self.x] = {self.range+1}
end

function Explosion:update()
    
end

function Explosion:draw()
    self:update()
    -- Draw explosions
    pushStyle()
    for y,r in pairs(self.affectedCells) do
        for x,v in pairs(r) do
            local gx,gy = mapToWorld(x,y,world)
            zLevel(y)
            tint(255,255/(self.range+1)*v[1])
            sprite("Tyrian Remastered:Explosion Huge",gx+self.constant/2,gy+self.constant/2,self.constant)
            setContext()
            v[1] = v[1] - 0.3
            if v[1] < 0 then
                self.affectedCells[y][x] = nil
                if self.affectedCells[self.x] == nil or self.affectedCells[self.x][self.y] == nil then
                    self.dead = true
                end
            end
        end
    end
    popStyle()
end

function Explosion:touched(touch)
    -- Codea does not automatically call this method
end
