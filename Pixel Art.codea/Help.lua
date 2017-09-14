Help = class()

function Help:init()
    -- you can accept and set parameters here
    if readLocalData"firstRun" then self.disabled = true end
    self.messages = {}
    if self.disabled then return end
    self.timer = 255
    self.countdownStarted = false
    self.offset = HEIGHT/3
    tween(0.8,self,{offset = 0,timer = 255},tween.easing.cubicOut,function() self.countdownStarted = true end)
end

function Help:draw()
    if self.disabled then return end
    -- Codea does not automatically call this method
    if self.messages[1] and self.timer and self.timer > 0 then
        textWrapWidth(WIDTH-80)
        font("Arial-BoldMT")
        fontSize(30)
        local w,h = textSize(self.messages[1])
        Better.fill(0,0,0,self.timer)
        Better.anchorPoint(0.5,0.5)
        Better.roundRect(WIDTH/2,HEIGHT/2-self.offset,w+80,h+80,30)
        fill(255,self.timer)
        text(self.messages[1],WIDTH/2,HEIGHT/2-self.offset)
        if self.countdownStarted then
            self.timer = self.timer - 4
        end
    elseif self.timer and self.timer <= 0 then
        self.countdownStarted = false
        self.offset = HEIGHT/3
        table.remove(self.messages,1)
        tween(0.8,self,{offset = 0,timer = 255},tween.easing.cubicOut,function() self.countdownStarted = true end)
    end
end

function Help:addMessage(message)
    if self.disabled then return end
    if not self.messages[1] then
        self.countdownStarted = false
        self.offset = HEIGHT/3
        tween(0.8,self,{offset = 0,timer = 255},tween.easing.cubicOut,function() self.countdownStarted = true end)
    end
    table.insert(self.messages,message)
end