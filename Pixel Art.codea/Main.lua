-- Pixel Art
-- Project created by @em2 (unless otherwise stated)
-- Project info (DO NOT EDIT!)
VERSION = "1.0.5" 
PROJECTNAME = "Pixel Art"
DESCRIPTION = "A pixel sprite creator for your projects"
AUTHOR = "Elijah Mendoza"

-- Display settings
displayMode(FULLSCREEN)
supportedOrientations(LANDSCAPE_ANY)
supportedOrientations(CurrentOrientation)

function setup()
    setupUtil()
    setupDrawboard()
    setupTools()
    setupHelp()
    setupExport()
    setupProjectImages()
    --[DELETE]--
    setupAutoGist()
    --[/DELETE]--
end

function draw() 
    background(40,40,50)
    
    -- Draw the canvas (drawing area)
    drawCanvas()
    
    -- Global image needs to be drawn when eyedropper is on
    if eyedropper.on then
        sprite(globalImage,WIDTH*0.5,HEIGHT*0.5)
    end
    
    -- Draw the UI (buttons, sliders, etc.)
    drawUI()
    
    -- Remove unused variables
    collectgarbage()
end

function touched(touch)
    -- Initial break out variables (disable normal touch behavior)
    if #help.messages > 0 then return end
    if eyedropper:touched(touch) then return end
    
    -- Multitouch handling
    if touch.state == BEGAN or touch.state == MOVING then
        touches[touch.id] = touch
    else
        touches[touch.id] = nil
    end
    touchExport(touch)
    if pickerShowing then
        picker:touched(touch)
        local x,y,w,h = picker.x, picker.y, picker.img.width+50, picker.img.height+50
        if touch.x < x-w/2 or touch.x > x+w/2 or touch.y < y-h/2 or touch.y > y+h/2 and touch.state == ENDED then
            pickerShowing = false
            return
        end
        return
    end
    if brushShowing then
        local x,y,w,h = WIDTH-130, HEIGHT-50, 280, 100
        if touch.x < x-w/2 or touch.x > x+w/2 or touch.y < y-h/2 or touch.y > y+h/2 and touch.state == ENDED then
            brushShowing = false
            return
        else
            brush:touched(touch)
            return
        end
    end
    if zoomOn then
        zoom:touched(touch)
        return
    end
    if touch.state == ENDED or touch.state == MOVING then
        local t = worldToLocal(touch,zoomMatrix)
        local cc = cellSize
        local hcc = cellSize*0.5
        local brushSize = brush.pos*90+10
        local brushSize2 = brushSize*brushSize
        for i,r in ipairs(grid) do
            for j,index in ipairs(r) do
                local i,j = (i-1),j-1
                local x,y = i*cc, j*cc
                -- Deprecated
                --[[if t.x > i*cc-hcc and t.x < i*cc+hcc and t.y > j*cc-hcc and t.y < j*cc+hcc then
                    gridMesh:setRectColor(index,picker:getColor())
                end
                --]]
                -- New version w/ brush size
                local dist2 = (t.x - x)*(t.x - x) + (t.y - y)*(t.y - y)
                -- No square root for optimization
                if dist2 < brushSize2 then
                    gridMesh:setRectColor(index,pickerColor)
                    grid.colors[i][j] = pickerColor
                end
            end
        end
    end
    --statusBar:touched(touch)
end

function keyboard(key)
    Input._put(key)
end