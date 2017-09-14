Eyedropper = class()

function Eyedropper:init()
    -- you can accept and set parameters here
    self.on = false
    self.size = 0
    self.position = vec2(0,0)
    self.visibleColor = color(0,0,0,0)
    self.color = color(0,0,0,0)
    self.handlers = {}
    self.firstPlay = false
    self.state = "off"
end

function Eyedropper:draw()
    -- Codea does not automatically call this method
    if self.on then
        pushStyle()
        noFill()
        local r,g,b,a = self.visibleColor.a,self.visibleColor.g,self.visibleColor.b,self.visibleColor.a
        stroke(r,g,b)
        strokeWidth(5)
        ellipse(self.position.x,self.position.y,self.size)
        strokeWidth(4)
        for i = 0, 3 do
            pushMatrix()
            translate(self.position.x,self.position.y)
            rotate(i*360*0.25)
            line(self.size/200*10,0,self.size/200*50,0)
            popMatrix()
        end
        popStyle()
    end
end

function Eyedropper:activate(pos)
    if not self.firstPlay then
        help:addMessage("Move the eyedropper around to select a color")
        help:addMessage("When you release your finger, the eyedropper will close")
        self.firstPlay=true
        return
    end
    self.state = "ready"
    self.position = pos
    self.on = true
    tween(0.7,self,{size = 200},tween.easing.expoOut)
end

function Eyedropper:deactivate()
    tween(0.5,self,{size = 0},tween.easing.cubicOut,function() 
        self.on = false 
        self.state = "off"
    end)
end

function Eyedropper:toggle(pos)
    if self.on then
        self:deactivate()
    else
        self:activate(pos)
    end
end

function Eyedropper:getColor(img)
    local r,g,b,a = img:get(math.floor(self.position.x+0.5),math.floor(self.position.y+0.5))
    local chosenColor = color(r,g,b,a)
    if chosenColor ~= self.color then
        self.color = chosenColor
        for i,v in ipairs(self.handlers) do
            v(self.color)
        end
        tween(0.1,self.visibleColor,{r=r,g=g,b=b,a=a})
    end
end

function Eyedropper:addHandler(f)
    table.insert(self.handlers,f)
    return #self.handlers
end

function Eyedropper:touched(touch)
    -- Codea does not automatically call this method
    if self.on then
        if self.state == "ready" and touch.state == MOVING then
            self.state = "started"
        end
        if self.state == "started" then
            self.position = vec2(touch.x,touch.y)
            self:getColor(globalImage)
            if touch.state == ENDED then
                self:deactivate()
            end
        end
        return true
    end
end
