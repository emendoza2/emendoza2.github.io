-- "Better" global
-- Provides a few (hopefully) useful modifications of codea functions
-- Styling better objects requires using Better methods (usually), so to be safe, always use Better style methods on Better objects.
-- TODO: layering
do

    local doNothing = function() end
    Better = {
    -- "activate" Better
    activate = function()
        if not Better._activated then
            Better._activated = true
            local _draw = draw
            draw = function()
                Better._uniqueIds = 1
                for i,v in pairs(Better._buttons) do
                    v.o = false
                end
                for i,v in pairs(Better._prioritizedButtons) do
                    v.o = false
                end
                _draw() 
                for i,v in pairs(Better._buttons) do
                    if not v.o then
                        Better._buttons[i] = nil
                    end
                end
                for i,v in pairs(Better._prioritizedButtons) do
                    if not v.o then
                        Better._prioritizedButtons[i] = nil
                    end
                end
            end
            local _touched = touched or doNothing
            touched = function(touch) 
                if touch.state == ENDED then
                    for i,v in pairs(Better._prioritizedButtons) do
                        if touch.x > v.x and touch.y > v.y and touch.x < v.x + v.w and touch.y < v.y + v.h then
                            v.c(touch) 
                            
                            return
                        end
                    end 
                end
                _touched(touch) 
                if touch.state == ENDED then
                    for i,v in pairs(Better._buttons) do
                        if touch.x > v.x and touch.y > v.y and touch.x < v.x + v.w and touch.y < v.y + v.h then

                            v.c(touch) 
                        end
                    end 
                end
            end
        end
    end,
    -- unique id generator
    uniqueId = function()
        local old = Better._uniqueIds
        Better._uniqueIds = Better._uniqueIds + 1 
        return old
    end,
    _uniqueIds = 1,
    -- table copy
    tableCopy = function(orig)
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[Better.tableCopy(orig_key)] = Better.tableCopy(orig_value)
            end
            setmetatable(copy, Better.tableCopy(getmetatable(orig)))
        else -- number, string, boolean, etc
            copy = orig
        end
        return copy
    end,
    -- push/pop style
    pushStyle = function()
        table.insert(Better._styleStack,1,Better.tableCopy(Better._data))
    end, 
    popStyle = function()
        if #Better._styleStack == 0 then
            return
        end
        Better._data = Better.tableCopy(Better._styleStack[1])
        table.remove(Better._styleStack,1)
    end,
    
    anchorPoint = function(x,y)
        Better._data.anchorPoint = vec2(-x,-y)
    end,
    invertY = function(i)
        invertY = t or not invertY
    end,
    --[[ Rounded rect by @Zoyt modified by me (deprecated)
    roundRect = function(x, y, w, h, cr)
        pushMatrix()
        translate(w*Better._data.anchorPoint.x,h*Better._data.anchorPoint.y)
        pushStyle()
        insetPos = vec2(x+cr,y+cr)
        insetSize = vec2(w-2*cr,h-2*cr)
        
        local f = Better._data.globalFill
        fill(f)
        
        rectMode(CORNER)
        rect(insetPos.x,insetPos.y,insetSize.x,insetSize.y)
        
        r,g,b,a = f.r,f.g,f.b,f.a
        stroke(r,g,b,a)
        
        if cr > 0 then
            smooth()
            lineCapMode(ROUND)
            strokeWidth(cr*2)
            
            line(insetPos.x, insetPos.y, 
                insetPos.x + insetSize.x, insetPos.y)
            line(insetPos.x, insetPos.y,
                insetPos.x, insetPos.y + insetSize.y)
            line(insetPos.x, insetPos.y + insetSize.y,
                insetPos.x + insetSize.x, insetPos.y + insetSize.y)
            line(insetPos.x + insetSize.x, insetPos.y,
                insetPos.x + insetSize.x, insetPos.y + insetSize.y)            
        end
        popStyle()
        popMatrix()
    end,]]
    _RRects = {},
    -- round rect by @Andrew_Stacey modified by me
    roundRect = function(x,y,w,h,s,c,a)
        c = c or 0
        w = w or 0
        h = h or 0
        if w < 0 then
            x = x + w
            w = -w
        end
        if h < 0 then
            y = y + h
            h = -h
        end
        w = math.max(w,2*s)
        h = math.max(h,2*s)
        a = a or 0
        pushMatrix()
        local anchor = Better._data.anchorPoint
        translate(x+anchor.x*w,y+anchor.y*h)
        rotate(a)
        local label = table.concat({w,h,s,c},",")
        if Better._RRects[label] then
            Better._RRects[label]:setColors(Better.fill())
            Better._RRects[label]:draw()
        else
            local rr = mesh()
            local v = {}
            local ce = vec2(w/2,h/2)
            local n = 4
            local o,dx,dy
            for j = 1,4 do
                dx = -1 + 2*(j%2)
                dy = -1 + 2*(math.floor(j/2)%2)
                o = ce + vec2(dx * (w/2 - s), dy * (h/2 - s))
                if math.floor(c/2^(j-1))%2 == 0 then
                    for i = 1,n do
                        table.insert(v,o)
                        table.insert(v,o + vec2(dx * s * math.cos((i-1) * math.pi/(2*n)), dy * s * math.sin((i-1) * math.pi/(2*n))))
                        table.insert(v,o + vec2(dx * s * math.cos(i * math.pi/(2*n)), dy * s * math.sin(i * math.pi/(2*n))))
                    end
                else
                    table.insert(v,o)
                    table.insert(v,o + vec2(dx * s,0))
                    table.insert(v,o + vec2(dx * s,dy * s))
                    table.insert(v,o)
                    table.insert(v,o + vec2(0,dy * s))
                    table.insert(v,o + vec2(dx * s,dy * s))
                end
            end
            rr.vertices = v
            rr:addRect(ce.x,ce.y,w,h-2*s)
            rr:addRect(ce.x,ce.y + (h-s)/2,w-2*s,s)
            rr:addRect(ce.x,ce.y - (h-s)/2,w-2*s,s)
            rr:setColors(Better._data.globalFill)
            rr:draw()
            Better._RRects[label] = rr
        end
        popMatrix()
    end,
    -- "Better" button table (function is below)
    button = {text = function(t,x,y,w,h,c,e)
        x,y = x+w*Better._data.anchorPoint.x,y+h*Better._data.anchorPoint.y
        Better.pushStyle()
        Better._data.anchorPoint = vec2(0,0)
        Better.roundRect(x,y,w,h,math.min(w,h)*0.2)
        Better.anchorPoint(0.5,0.5)
        Better.text(t,x+w/2,y+h/2)
        Better.popStyle()
        local self = {x = x,y = y,w = w,h = h,c = c or doNothing,o = true,e = e or false}
        -- execute this only once, using a unique id
        local id = Better.uniqueId()
        if e then
            if not Better._prioritizedButtons[id] then
                Better._prioritizedButtons[id] = self
            end
            Better._prioritizedButtons[id].o = true
        else
            if not Better._buttons[id] then
                Better._buttons[id] = self
            end
            Better._buttons[id].o = true
        end
        
    end,
    
    image = function(img,x,y,w,h,c,e,p)
        x,y = x+w*Better._data.anchorPoint.x,y+h*Better._data.anchorPoint.y
        local padding = p or math.min(x,y)*0.1
        Better.pushStyle()
        Better._data.anchorPoint = vec2(0,0)
        Better.roundRect(x,y,w,h,math.min(w,h)*0.2)
        -- Since sprites are not yet incorporated into better, use normal methods here
        pushStyle()
        spriteMode(CENTER)
        sprite(img,x+w*0.5,y+h*0.5,w-padding*2)
        popStyle()
        Better.popStyle()
        local self = {x = x,y = y,w = w,h = h,c = c or doNothing,o = true,e = e or false}
        -- execute this only once, using a unique id
        local id = Better.uniqueId()
        if e then
            if not Better._prioritizedButtons[id] then
                Better._prioritizedButtons[id] = self
            end
            Better._prioritizedButtons[id].o = true
        else
            if not Better._buttons[id] then
                Better._buttons[id] = self
            end
            Better._buttons[id].o = true
        end
    end,
    
    -- Segmented Button
    segmented = function(x,y,w,h,...)
        local arg = table.pack(...)
        local numberOfButtons = #arg
        x,y = x+w*Better._data.anchorPoint.x,y+h*Better._data.anchorPoint.y
        
        -- Large container for all buttons
        Better.pushStyle()
        Better.anchorPoint(0,0)
        Better.roundRect(x,y,w,h,math.min(w,h)*0.2)
        
        local fillColor = Better.fill()
        local avg = (fillColor.r+fillColor.g+fillColor.b)/3 
        local partSize = w*(1/numberOfButtons)
        pushStyle()
        stroke(Better.textFill())
        lineCapMode(SQUARE)
        strokeWidth(strokeWidth() > 1.5 and strokeWidth() or 1.5)
        pushMatrix()
        translate(x,y)
        for i = 1, #arg-1 do
            line(partSize*i,0,partSize*i,h)
        end
        popMatrix()
        popStyle()
        Better.popStyle()
        
        Better.pushStyle()
        pushMatrix()
        translate(x,y)
        Better.anchorPoint(0.5,0)
        for i,v in ipairs(arg) do
            -- Drawing each label
            pushStyle()
            local t, c, e = v.text, v.callback, v.exclusive
            local xOff = partSize*(i-1)
            local xMargin = partSize*0.1
            local utw,uth = textSize(t)
            textWrapWidth(partSize-partSize*0.1)
            local tw,th = textSize(t)
            local yMargin = h*0.15
            
            clip(x+xOff+xMargin,y+yMargin,partSize-xMargin*2,h-yMargin*2)
            Better.text(t,partSize*i-partSize*0.5,h-th-(h/2-uth/2))
            clip()
            
            -- Label button info
            local self = {x = x+xOff,y = y,w = partSize,h = h,c = c or doNothing,o = true,e = e or false}
            local id = Better.uniqueId()
            if e then
            if not Better._prioritizedButtons[id] then
                Better._prioritizedButtons[id] = self
            end
                Better._prioritizedButtons[id].o = true
            else
                if not Better._buttons[id] then
                    Better._buttons[id] = self
                end
                Better._buttons[id].o = true
            end
            popStyle()
            end
        popMatrix()
        Better.popStyle()
    end},
    -- "Better" fill
    -- Better fill returns a color (instead of four values)
    -- Better fill does not affect non-better objects
    -- When alpha is not specified, it is assumed to be 255
    -- TODO: add an animate feature and a feature that allows you to type in color names
    fill = function(r,g,b,a)
        -- set local variables for modification
        local r,g,b,a = r,g,b,a
        if not r then
            return Better._data.globalFill
        end
        -- fallback
        -- case: r is color
        if type(r) == "userdata" and r.r and r.g and r.b and r.a then
            Better._data.globalFill = r
            return
        end
        if not a then
            a = 255
            if not b then
                a = g
                r, g, b = g, g, g
                if not g then
                    a = 255
                    r, g, b = r, r, r
                end
            end
        end
        Better._data.globalFill = color(r,g,b,a)
        for k,_ in pairs(Better._data.stylingOrder) do
            Better._data.stylingOrder[k] = "globalFill"
        end
    end,
    -- "Better" function for setting text color
    textFill = function(r,g,b,a)
        -- set local variables for modification
        local r,g,b,a = r,g,b,a
        if not r then
            return Better._data[Better._data.stylingOrder.text]
        end
        -- fallback
        -- case: r is color
        if type(r) == "userdata" and r.r and r.g and r.b and r.a then
            Better._data.textColor = r
            return
        end
        if not a then
            a = 255
            if not b then
                a = g
                r, g, b = g, g, g
                if not g then
                    a = 255
                    r, g, b = r, r, r
                end
            end
        end
        Better._data.textColor = color(r,g,b,a)
        Better._data.stylingOrder.text = "textColor"
    
    end,
    
    -- "Better" function for setting text size
    fontSize = fontSize,
    
    -- fallback for original text function
    _text = text,
    -- "Better" text function
    text = function(t,x,y,w,h)
        pushStyle()
        -- set local variables for modification
        --local t = type(t) == "string" and t or tostring(t)
        local x = x
        local y = y
        local w, h = w, h
        
        -- anchor points and such aren't applicable in CORNERS mode
        if textMode() ~= CORNERS then
            -- textSize width and height
            local tw, th = textSize(t)
            
            -- fallback
            -- height is calculated based on tw and w (may fail for text with many wrapped lines)
            if not w then
                w = tw
            end
            h = h or th * math.floor(tw/w)
            x = x + w * Better._data.anchorPoint.x
            y = y + h * Better._data.anchorPoint.y
            if Better._data.invertY then
                y = HEIGHT - y - h
            end
            textMode(CORNER)
        end
        
        -- fill according to style order
        fill(Better._data[Better._data.stylingOrder.text])
        
        -- finally, execute the original text function
        textWrapWidth(w)
        Better._text(t,x,y)
        popStyle()
        
    end,
    _data = {
        anchorPoint = vec2(0,0),
        invertY = false,
        textColor = color(40,40,40),
        globalFill = color(40,40,40),
        fontSize = 20,
        stylingOrder = {
            text = "textColor"
        }
    },
    -- additional info tables
    _styleStack = {},
    _buttons = {},
    _prioritizedButtons = {}
    
    }
    -- "Better" button function
    do
        local mt = {}
        mt.__call = function(self,x,y,w,h,c,e)
            x,y = x+w*Better._data.anchorPoint.x,y+h*Better._data.anchorPoint.y
            Better.pushStyle()
            Better.anchorPoint(0,0)
            Better.roundRect(x,y,w,h,math.min(w,h)*0.2)
            Better.popStyle()
            local self = {x = x,y = y,w = w,h = h,c = c or doNothing,o = true,e = e or false}
            -- execute this only once
            local id = Better.uniqueId()
            if e then
            if not Better._prioritizedButtons[id] then
                Better._prioritizedButtons[id] = self
            end
                Better._prioritizedButtons[id].o = true
            else
                if not Better._buttons[id] then
                    Better._buttons[id] = self
                end
                Better._buttons[id].o = true
            end
        end
        setmetatable(Better.button,mt)
    end
end