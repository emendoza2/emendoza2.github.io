-- Bomberman
supportedOrientations(LANDSCAPE_ANY)
displayMode(FULLSCREEN_NO_BUTTONS)

-- Initial setup
function setup()
    -- Essential (ignore this)
    supportedOrientations(CurrentOrientation)
    local _=draw; draw=function() update() _() end
    -- touch
    touches = {}
    touchables = {}
    -- layering
    layers = {}
    -- put actual setup after this
    
    -- World info
    local w = world
    ww = #assert(w[1],"invalid world grid provided (error code 2)")
    wh = #assert(w,"invalid world grid provided (error code 1)")
    constant = math.min(WIDTH/ww,HEIGHT/wh)
    
    -- World/player setup
    _G.w = World(world)
    players = {Player(1,wh,world,"Planet Cute:Character Boy"),Player(ww,1,world,"Planet Cute:Character Pink Girl"),Player(ww,wh,world,"Planet Cute:Character Cat Girl"),Player(1,1,world,"Planet Cute:Character Boy")}
    
    -- Controls
    buttons = {
        -- Player 1
        Button(45,90,function() players[1]:move(1) end,drawLeft),
        Button(135,90,function() players[1]:move(3) end,drawRight),
        Button(90,135,function() players[1]:move(2) end,drawUp),
        Button(90,45,function() players[1]:move(4) end,drawDown),
        Button(90,90,function() players[1]:drop() end,drawDrop),
        
        -- Player 2
        Button(WIDTH-135,HEIGHT-90,function() players[2]:move(1) end,drawLeft),
        Button(WIDTH-45,HEIGHT-90,function() players[2]:move(3) end,drawRight),
        Button(WIDTH-90,HEIGHT-45,function() players[2]:move(2) end,drawUp),
        Button(WIDTH-90,HEIGHT-135,function() players[2]:move(4) end,drawDown),
        Button(WIDTH-90,HEIGHT-90,function() players[2]:drop() end,drawDrop),
    
        -- Player 3
        Button(WIDTH-135,90,function() players[3]:move(1) end,drawLeft),
        Button(WIDTH-45,90,function() players[3]:move(3) end,drawRight),
        Button(WIDTH-90,135,function() players[3]:move(2) end,drawUp),
        Button(WIDTH-90,45,function() players[3]:move(4) end,drawDown),
        Button(WIDTH-90,90,function() players[3]:drop() end,drawDrop),
    
        -- Player 4
        Button(45,HEIGHT-90,function() players[4]:move(1) end,drawLeft),
        Button(135,HEIGHT-90,function() players[4]:move(3) end,drawRight),
        Button(90,HEIGHT-45,function() players[4]:move(2) end,drawUp),
        Button(90,HEIGHT-135,function() players[4]:move(4) end,drawDown),
        Button(90,HEIGHT-90,function() players[4]:drop() end,drawDrop)
    }
    
    -- Bombs
    bombs = {}
    explosions = {}
    
    -- Frames
    frameCount = 0
    
end

-- Updating
function update()
    frameCount = frameCount + 1 
end

-- Drawing
function draw()
    -- This sets a dark background color 
    background(0, 0, 0, 255)

    -- This sets the line thickness
    strokeWidth(5)
    
    -- clear layers
    for i,v in ipairs(layers) do
        setContext(v)
        background(0,0,0,0)
        setContext()
    end
    w:draw()
    
    -- draw bombs, explosions
    for i,r in pairs(bombs) do
        for j,v in pairs(r) do
            if v[1] and v[1] > 0 then
                zLevel(i)
                fill(255)
                local x,y = mapToWorld(j,i,world)
                sprite("Tyrian Remastered:Orb 3",
                x+constant/2,y+constant/2,constant*0.4)
                setContext()
                v[1] = v[1] - 1 
            else
                -- spawn explosion
                table.insert(explosions,Explosion(j,i,world))
                bombs[i][j] = nil
                collectgarbage()
            end
        end
    end
    for i,v in ipairs(explosions) do
        v:draw()
        if v.dead then
            table.remove(explosions,i)
        end
    end
    
    -- Player drawing
    for i,p in ipairs(players) do
        p:draw()
    end
    
    -- layers
    for i,v in ipairs(layers) do
        pushStyle()
        spriteMode(CORNER)
        sprite(v)
        popStyle()
    end
    
    for i,v in ipairs(buttons) do
        fill(255)
        v:draw()
    end

end

-- Touching
function touched(t)
    if t.state == BEGAN or t.state == MOVING then
        touches[t.id] = t
    elseif t.state == ENDED or t.state == CANCELLED then
        touches[t.id] = nil
    end
    local allTriple = true
    local len = 0
    for i,v in pairs(touches) do
        if v.deltaY < 15 then
            allTriple = false
        end
        len = len+1
    end
    if len == 3 and allTriple then
        displayMode(FULLSCREEN)
    end
    for i,v in ipairs(touchables) do
        v:touched(t)
    end
end

function mapToWorld(cx,cy,w)
    local ww = #assert(w[1],"invalid world grid provided (error code 2)")
    local wh = #assert(w,"invalid world grid provided (error code 1)")
    local constant = math.min(WIDTH/ww,HEIGHT/wh)
    return (cx-1)*constant,HEIGHT-cy*constant
end
