World = class()

Blocks = {{},{image="Planet Cute:Wall Block", height=0.8, impassable=true},{image="Planet Cute:Wood Block", height=0.8, impassable=true, breakable = true}}

function World:init(grid)
    -- you can accept and set parameters here
    self.world = grid
end

function World:draw()
    local w = self.world
    local ww = #assert(w[1],"invalid world grid provided (error code 2)")
    local wh = #assert(w,"invalid world grid provided (error code 1)")
    
    -- Iterate over world blocks
    -- Styling
    pushStyle()
    spriteMode(CORNER)
    for i,r in ipairs(w) do
        for j,v in ipairs(r) do
            -- set x and y (invert y)
            local constant = math.min(WIDTH/ww,HEIGHT/wh)
            local x,y = (j-1)*constant,HEIGHT-i*constant
            local block = Blocks[v]
            
            pushMatrix()
            zLevel(i)
            sprite("Planet Cute:Plain Block",
            x,y-constant/2,
            constant,constant*2.1)
            
            if block.image then
                sprite(block.image,
                x,y-constant/2+(block.height or 0)*constant/2.1,
                constant,constant*2.1)
            end
            setContext()
            popMatrix()
        end
    end
    popStyle()
end

function World:touched(touch)
    -- Codea does not automatically call this method
end

world = {
{1,1,3,3,3,3,3,3,3,1,1},
{1,2,3,2,3,2,3,2,3,2,1},
{3,3,3,3,3,3,3,3,3,3,3},
{3,2,3,2,3,2,3,2,3,2,3},
{3,3,3,3,3,3,3,3,3,3,3},
{3,2,3,2,3,2,3,2,3,2,3},
{3,3,3,3,3,3,3,3,3,3,3},
{1,2,3,2,3,2,3,2,3,2,1},
{1,1,3,3,3,3,3,3,3,1,1},
}