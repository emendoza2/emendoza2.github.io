function drawZoom() 
    zoom:draw()
    zoomMatrix = modelMatrix()
end

function drawColorPicker()
    if pickerShowing then
        fill(40,40,50)
        rectMode(CORNER)
        rect(0,HEIGHT-300,400,300)
        picker:draw()
        pickerColor = picker:getColor()
    else
        local c = pickerColor
        Better.fill(c.r,c.g,c.b,c.a>50 and c.a or 50)
        Better.anchorPoint(0,0)
        if c.r+c.g+c.b>375 then
            Better.textFill(0,0,0)
        else
            Better.textFill(255,255,255)
        end
        fontSize(14)
        Better.button.segmented(10,HEIGHT-60,200,50,
        {text="Picker",callback=function() 
            pickerShowing = true 
            eyedropper:deactivate()
            zoomOn = false
        end,exclusive = true},
        {text="Eyedropper",callback=function() 
            eyedropper:toggle(CurrentTouch) 
        end,exclusive = true})
        
        Better.button.text("Eraser",WIDTH/2-50,HEIGHT-60,100,50,function() 
            pickerColor = color(0,0,0,0) 
            eyedropper:deactivate()
            zoomOn = false
        end,true)
    end
end

function drawBrushSize()
    if brushShowing then
        fill(40,40,50)
        rectMode(CORNER)
        rect(WIDTH-280,HEIGHT-100,280,100)
        fill(255)
        rectMode(CENTER)
        local o15 = 50/11
        local new = (brush.pos*90+10)/100*o15
        for i = 1, 11 do
            for j = 1, 11 do
                local d2 = (6-i)*(6-i)+(6-j)*(6-j)
                if d2 < new*new then -- check if pixel is in bounds
                    rect((i-6)*o15+WIDTH-220,(j-6)*o15+HEIGHT-50,o15,o15)
                end
            end
        end
        brush:draw()
    else
        Better.fill(255,255,255)
        Better.textFill(0,0,0)
        Better.button.text("Brush Size",WIDTH-110,HEIGHT-60,100,50,function() 
            brushShowing = true 
            zoomOn = false
            eyedropper:deactivate()
        end)
    end
end

function drawExportUI()
    Better.button.segmented(10,10,200,50,
    {text="↩︎",callback=function(t) close();saveLocalData("firstRun",true) end,exclusive = true},
    {text="Export",callback=function() 
        export(grid,gridMesh) 
        eyedropper:deactivate()
    end,exclusive = true})
end

function drawZoomUI()
    local zoomT = zoomOn and "︎✏️" or "Zoom"
    Better.button.segmented(WIDTH-210,10,200,50,{text="Grid lines",callback=function() hideGridLines=not hideGridLines end,exclusive=true},{text=zoomT,callback=function()
        if not firstZoomPress then
            help:addMessage("Press on the zoom button to toggle zoom mode")
            firstZoomPress = true
        end
        zoom.touches = {}
        zoomOn = not zoomOn
    end,exclusive = true})
end

function drawUI()
    -- Color picker
    drawColorPicker()

    -- Brush size
    drawBrushSize()
    
    -- Export
    drawExportUI()
    
    -- Zoom
    drawZoomUI()
    
    -- Help
    help:draw()
    
    -- Export
    drawExport()
    
    -- Eyedropper 
    eyedropper:draw()
end

function drawCanvas()
    pushMatrix()
        -- Zoom
        drawZoom()
        
        -- Checkered transparent background
        checkerboard:draw()
        
        -- Global image used for eyedropper
        if eyedropper.on then
            setContext(globalImage)
            background(0,0,0,0)
        end
        
        -- Mesh (pixels)
        gridMesh:draw()
        
        -- Grid lines
        if not (eyedropper.on or hideGridLines) then
            gridLines:draw()
        end
        
        -- End of global picker
        if eyedropper.on then
            setContext()
        end
    popMatrix()
end
