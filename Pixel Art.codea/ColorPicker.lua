  -- Color Picker by @DayLightTimer
ColorChooseBox = class()

function ColorChooseBox:init(x,y)
    -- you can accept and set parameters here
    self.backgroundColor = color(0, 0, 0, 255)
    self.x = x
    self.y = y
    self.img = image(260,220)
    self.chooseCircleIn = vec2(110,110)
    self.chooseCircleOut = vec2(0,101)
    self.colorOperation = color(255, 0, 0, 255)
    self.hide = 255
    self.SlideIn = false
    self.SlideOut = false
    self.touchid = nil
    self.AlphaSlide = EasySlider(x+110,y,200,1,2)
    self.firstDraw = false
end

function ColorChooseBox:draw()
    -- Codea does not automatically call this method
    setContext(self.img)
    background(0, 0, 0, 0)
    sprite("Project:ColorCircle",110,110)
    rectMode(CENTER)
    fill(self.colorOperation)
    strokeWidth(0)
    rect(110,110,110.5,110.5)
    sprite("Project:ColorChoose",110,110,110)
    noTint()
    noFill()
    strokeWidth(3)
    ellipse(self.chooseCircleIn.x,self.chooseCircleIn.y,20)
    ellipse(self.chooseCircleOut.x+110,self.chooseCircleOut.y+110,20)
    translate(-self.x+130,-self.y+110)
    self.AlphaSlide:draw()
    resetMatrix()
    setContext()
    tint(255,self.hide)
    spriteMode(CENTER)
    sprite(self.img,self.x,self.y)
    local r,g,b,a=self.img:get(self.chooseCircleOut.x//1+110,self.chooseCircleOut.y//1+110)
    self.colorOperation=color(r,g,b,a)
    noTint()
    self.firstDraw = true
end

function ColorChooseBox:touched(touch)
    -- Codea does not automatically call this method
    if vec2(touch.x,touch.y):dist(vec2(self.x-20,self.y))>90 and vec2(touch.x,touch.y):dist(vec2(self.x-20,self.y))<=110 and touch.state==BEGAN then
        self.SlideOut=true
        self.touchid=touch.id
    elseif touch.x>self.x-55 and touch.x<self.x+55 and touch.y>self.y-55 and touch.y<self.y+55 and touch.state==BEGAN then
        self.SlideIn=true
        self.touchid=touch.id
    end
    if self.SlideOut and self.touchid==touch.id then
        local vector = vec2(touch.x-self.x,touch.y-self.y):normalize()
        self.chooseCircleOut = 101*vector
    elseif self.SlideIn and self.touchid==touch.id then
        if touch.x>self.x-55 and touch.x<self.x+55 and touch.y>self.y-55 and touch.y<self.y+55 then
            self.chooseCircleIn=vec2(touch.x-self.x+110,touch.y-self.y+110)
        else
            if touch.x<=self.x+55 and touch.x>=self.x-55 then
                if touch.y>=self.y+55 then
                    self.chooseCircleIn=vec2(touch.x-self.x+110,55+110)
                elseif touch.y<=self.y-55 then
                    self.chooseCircleIn=vec2(touch.x-self.x+110,56)
                end
            elseif touch.x>self.x+55 then
                if touch.y<=self.y+55 and touch.y>=self.y-55 then
                    self.chooseCircleIn=vec2(55+110,touch.y-self.y+110)
                elseif touch.y>self.y+55 then
                    self.chooseCircleIn=vec2(55+110,55+110)
                else
                    self.chooseCircleIn=vec2(55+110,56)
                end
            elseif touch.x<self.x-55 then
                if touch.y<=self.y+55 and touch.y>=self.y-55 then
                    self.chooseCircleIn=vec2(56,touch.y-self.y+110)
                elseif touch.y>self.y+55 then
                    self.chooseCircleIn=vec2(56,55+110)
                else
                    self.chooseCircleIn=vec2(56,56)
                end
            end
        end
    end
    if touch.state==ENDED then
        self.SlideIn,self.SlideOut=false,false
    end
    self.AlphaSlide:touched(touch)
end

function ColorChooseBox:getColor()
    if not self.firstDraw then
        return color(255)
    end
    local r,g,b=self.img:get(self.chooseCircleIn.x//1,self.chooseCircleIn.y//1)
    return color(r,g,b,self.AlphaSlide.pos*255)
end
