function setupUtil()
    touches = {}
    zoom=Zoom()
    zoomMatrix=modelMatrix()
    Better.activate()
    -- Profiling (requires StatusBar from wiki)
    -- statusBar = StatusBar()
    zoomOn = false
end

function setupGrid()
    cellSize = 20
    
    gridMesh = mesh()
    grid = {}
    previousStates = {}
    grid.colors = {}
    local hcc = cellSize*0.5
    local cc = cellSize
    
    for i = 1, 100 do
        grid[i] = {}
        grid.colors[i] = {}
        for j = 1, 100 do
            local index = gridMesh:addRect((i-1)*cc,(j-1)*cc,cc,cc)
            grid[i][j] = index
            grid.colors[i][j] = color(0,0,0,0)
            gridMesh:setRectColor(index,color(0,0,0,0))
        end
    end
    
    local gh = #grid*cc
    local gw = #(grid[1] or {})*cc
    gridLines = mesh()
    local m = gridLines
    for i,r in ipairs(grid) do
        -- Lines are old and slow
        --line(i*cc-hcc,-hcc,i*cc-hcc,gh*cc-hcc)
        -- Mesh is better!
        m:addRect(i*cc-hcc,gh*0.5-hcc,1,gh)
    end
    for j,v in ipairs(grid[1] or {}) do
        --line(-hcc,j*cc-hcc,gw*cc-hcc,j*cc-hcc)
        m:addRect(gw*0.5-hcc,j*cc-hcc,gw,1)
    end
end

function setupBackground()
    checkerboard = mesh()
    local size = 10
    for i = 1, 200 do
        for j = 1, 200 do
            local r = checkerboard:addRect((i-1)*size-size/2,(j-1)*size-size/2,size,size)
            local g = ((i+j)%2)*70+130
            local c = color(g,g,g)
            checkerboard:setRectColor(r,c)
        end
    end
end

function setupRender()
    globalImage = image(WIDTH,HEIGHT)
end

function setupDrawboard()
    setupGrid()
    setupBackground()
    setupRender()
end

function setupHelp()
    help = Help()
    help:addMessage("Tap around to paint pixels")
end

function setupPicker()
    pickerShowing = false
    picker = ColorChooseBox(200,HEIGHT-150)
    pickerColor = picker:getColor()
end

function setupBrush()
    brushShowing = false
    brush = EasySlider(WIDTH-100,HEIGHT-50,100,0)
end

function setupEyedropper()
    eyedropper = Eyedropper()
    eyedropper:addHandler(function(c) pickerColor = c end)
end

function setupTools()
    setupPicker()
    setupBrush()
    setupEyedropper()
end

function setupExport()
    spriteName = ""
    local handler = function(t)
        spriteName = t
    end
    spriteNameInput = Input(WIDTH/2-70,HEIGHT/2+20,140,20,"Arial-BoldMT","", handler)
end

function setupProjectImages()
    downloadImageToProject("Icon","https://www.dropbox.com/s/3t91x976chachgg/Icon%402x.png?dl=1")
    downloadImageToProject("ColorChoose","https://www.dropbox.com/s/rup859kro8a3hkx/ColorChoose.png?dl=1")
    downloadImageToProject("ColorCircle","https://www.dropbox.com/s/0rvl2fyi0f3t414/ColorCircle.png?dl=1")
end
