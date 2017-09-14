function export(grid,mesh)
    if not firstExport then
        help:addMessage("Before export, resize with the zoom tool to make your image fit the screen")
        firstExport = true
        return
    end
    spriteimg = image(WIDTH,HEIGHT)
    setContext(spriteimg)
    pushMatrix()
    modelMatrix(zoomMatrix)
    mesh:draw()
    popMatrix()
    setContext()
    exportShowing = true
    advancedExport = false
end
function drawExport()
    if exportShowing then
        pushStyle()
        rectMode(CORNER)
        font("Arial-BoldMT")
        fill(40,40,50)
        rect(WIDTH/2-100,HEIGHT/2-130,200,230)
        fill(255)
        fontSize(15)
        textAlign(CENTER)
        if not advancedExport then
            text("Enter name",WIDTH/2,HEIGHT/2+75)
        else
            text("Special format:",WIDTH/2,HEIGHT/2+80)
            fontSize(10)
            text("<spritepack>:<sprite name>",WIDTH/2,HEIGHT/2+65)
        end
        fill(40)
        fontSize(20)
        spriteNameInput:draw()
        Better.fill(107, 227, 118, 255)
        Better.textFill(255,255,255)
        Better.anchorPoint(0,0)
        Better.button.text("Export",WIDTH/2-70,HEIGHT/2-60,140,40,function()
            if advancedExport then
                if string.match(spriteName,"%w+:%w+") then
                    saveImage(spriteName,spriteimg)
                    exportShowing = false
                    alert "Success!"
                else
                    alert "Please enter a valid sprite name"
                end
            else
                print(spriteName,spriteimg)
                saveImage("Project:"..spriteName,spriteimg)
                exportShowing = false
                alert "Success! The image was saved in your project folder."
            end
        end)
        fontSize(12)
        Better.fill(0,0,0,0)
        Better.textFill(255,255,255)
        Better.anchorPoint(0.5,0.5)
        local s = advancedExport and "Basic" or "Advanced"
        Better.button.text(s,WIDTH/2,HEIGHT/2-100,100,20,function()
            advancedExport = not advancedExport
        end)
        popStyle()
    end
end

function touchExport(touch)
    local lowerBound = HEIGHT/2-130
    if touch.x < WIDTH/2-100 or touch.y < lowerBound or touch.x > WIDTH/2+100 or touch.y > HEIGHT/2+100 and touch.state == ENDED then
        exportShowing = false
        return
    elseif exportShowing and touch.x > WIDTH/2-100 and touch.y > HEIGHT/2-100 and touch.x < WIDTH/2+100 and touch.y < HEIGHT/2+100 then
        spriteNameInput:touched(touch)
        return
    end
end
