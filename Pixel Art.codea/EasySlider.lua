-- EasySlider by @DayLightTimer
EasySlider = class()

function EasySlider:init(x,y,length,startPos,mode)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.length = length
    self.pos = startPos or 0.5
    self.mode = mode or 1
    self.isSliding = false
    self.touchid = nil
end

function EasySlider:draw()
    -- Codea does not automatically call this method
    if self.mode == 1 then
        strokeWidth(2)
        stroke(78, 78, 78, 255)
        line(self.x-self.length/2,self.y,self.x+self.length/2,self.y)
        strokeWidth(4)
        stroke(255, 255, 255, 255)
        line(self.x-self.length/2,self.y,self.x-self.length/2+self.pos*self.length,self.y)
        if not self.isSliding then
            fill(0, 0, 0, 255)
        else
            fill(255, 255, 255, 255)
        end
        strokeWidth(2)
        ellipse(self.x-self.length/2+self.pos*self.length,self.y,16)
    elseif self.mode == 2 then
        strokeWidth(2)
        stroke(78, 78, 78, 255)
        line(self.x,self.y-self.length/2,self.x,self.y+self.length/2)
        strokeWidth(4)
        stroke(255, 255, 255, 255)
        line(self.x,self.y-self.length/2,self.x,self.y-self.length/2+self.length*self.pos)
        if not self.isSliding then
            fill(0, 0, 0, 255)
        else
            fill(255, 255, 255, 255)
        end
        strokeWidth(2)
        ellipse(self.x,self.y-self.length/2+self.length*self.pos,16)
    end
end

function EasySlider:touched(touch)
    -- Codea does not automatically call this method
    if touch.state==BEGAN then
        if vec2(touch.x,touch.y):dist(vec2(self.x-self.length/2+self.pos*self.length,self.y))<=10 and self.mode==1 then
            self.isSliding = true
            self.touchid=touch.id
        elseif vec2(touch.x,touch.y):dist(vec2(self.x,self.y-self.length/2+self.length*self.pos))<=10 and self.mode==2 then
            self.isSliding = true
            self.touchid=touch.id
        end
    end
    if self.isSliding then
        if self.mode==1 and self.touchid==touch.id then
            self.pos=(touch.x-(self.x-self.length/2))/self.length
            if self.pos<=0 then
                self.pos=0
            elseif self.pos>=1 then
                self.pos=1
            end
        elseif self.mode==2 and self.touchid==touch.id then
            self.pos=(touch.y-(self.y-self.length/2))/self.length
            if self.pos<=0 then
                self.pos=0
            elseif self.pos>=1 then
                self.pos=1
            end
        end
    end
    if touch.state==ENDED then
        self.isSliding = false
        self.touchid = nil
    end
end
