-- Input field by @LightDye
--[[--
GLOBAL FUNCTIONS 
These global functions can be declared out of this file if required
--]]--

-- (deleted)

--[[ INPUT CLASS ]]--

Input = class()

Input.instances = {}

local padding = 10

--[[ Class functions ]]--

function Input._draw()
    for _,input in ipairs(Input.instances) do
        input:draw()
    end
end

function Input._touched(touch)
    for _,input in ipairs(Input.instances) do
        input:touched(touch)
    end
end

function Input._put(key)
    for _,input in ipairs(Input.instances) do
        if input.focus then
            input:put(key)
        end
    end
end

--[[ Instance functions ]]--

function Input:init(x, y, w, h, fontName, txt, onEnter, target)
    table.insert(Input.instances, self)
    self.fontSize = h
    self.fontName = fontName
    font(self.fontName)
    fontSize(self.fontSize)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    if txt then
        self.txt = txt
    else
        self.txt = ""
    end
    self.pos = string.len(self.txt)
    self.winPos = 0

    self.cursor = Cursor(self.h+padding/2)

    self:blur()
    if onEnter == nil then
        self.onEnter = function() print(self.txt) end
    else
        self.onEnter = onEnter
    end
    self.target = target
end

function Input:put(key)
    if key == BACKSPACE then
        self:backspace()
    elseif key == RETURN then
        self:enter()
    else
        self:insert(key)        
    end
end

function Input:backspace()
    if self.pos > 0 then
        local head,tail = self:splitAndDrop(1)
        self.txt = head..tail
        self.pos = self.pos - 1
        if self.pos == self.winPos and self.winPos > 0 then
            self.winPos = self.winPos - 1
        end
    end
end

function Input:insert(key)
    local head,tail = self:splitAndDrop(0)
    self.txt = head..key..tail
    self.pos = self.pos + 1
    while self.pos > self:winSize() do
        self.winPos = self.winPos + 1
    end
end

function Input:enter()
    self:blur()
    if self.target then
        self.onEnter(self.target, self.txt)
    else
        self.onEnter(self.txt)
    end
end

function Input:splitAndDrop(dropCount)
    local head = string.sub(self.txt, 0, self.pos - dropCount)
    local tail = string.sub(self.txt, self.pos + 1)
    return head,tail
end

function Input:blur()
    self.focus = false
    hideKeyboard()
end

function Input:visiblePart()
    local winSize = self:winSize()
    return string.sub(self.txt, self.winPos + 1, self.winPos + winSize)
end

function Input:winSize()
    font(self.fontName)
    local winSize = string.len(self.txt)
    local part = string.sub(self.txt, self.winPos, self.winPos + winSize)
    local w,_ = textSize(part)
    while w > self.w do
        winSize = winSize - 1
        part = string.sub(self.txt, self.winPos, self.winPos + winSize)
        w,_ = textSize(part)
    end
    return winSize
end

function Input:draw()
    pushMatrix()
        translate(self.x, self.y)
        pushStyle()
            self:showBox()
            self:showText()
            self:posCursor()
            if self.focus then
                self:showBorder()
                self.cursor:draw()
            end
        popStyle()
    popMatrix()
end

function Input:showBox()
    fill(255, 255, 255, 255)
    stroke(255, 255, 255, 255)
    strokeWidth(padding)
    rect(-padding, -padding, self.w+2*padding, self.h+2*padding)
end

function Input:showBorder()
    noFill()
    strokeWidth(2)
    stroke(127, 127, 127, 255)
    rect(-padding, -padding, self.w+2*padding, self.h+2*padding)
end


function Input:showText()
    font(self.fontName)
    textMode(CORNER)
    fill(0, 0, 0, 255)
    text(self:visiblePart(), 0, 0)
end

function Input:touched(touch)
    if self:contains(touch) then
        self.focus = true
        if not isKeyboardShowing() then
            showKeyboard()
        end
        if touch.state ~= ENDED then
            self:moveCursor(touch.x)
        end
    else
        self:enter()
    end
end

function Input:contains(touch)
    return self.x <= touch.x 
        and touch.x <= (self.x + self.w)
        and self.y <= touch.y 
        and touch.y <= (self.y + self.h)
end

function Input:moveCursor(x)
    pushStyle()
        font(self.fontName)
        local min = math.huge
        local part = self:visiblePart()
        for i = 0,string.len(part) do
            local sub = string.sub(part, 0, i)
            local w,_ = textSize(sub)
            local dist = math.abs(x - (self.x + w))
            if dist < min then
                min = dist
                self.pos = self.winPos + i
            end
        end
    popStyle()
    local rightEnd = self.winPos + self:winSize()
    if self.pos == self.winPos and self.winPos > 0 then
        self.winPos = self.winPos - 1
    elseif self.pos == rightEnd and rightEnd < string.len(self.txt) then
        self.winPos = self.winPos + 1
    end
    self:posCursor()
end

function Input:posCursor()
    pushStyle()
        font(self.fontName)
        local part = self:visiblePart()
        local relPos = self.pos - self.winPos
        local sub = string.sub(part, 0, relPos)
        self.cursor.x,_ = textSize(sub)
    popStyle()
end

Cursor = class()

function Cursor:init(h)
    self.h = h
    self.x = 0
    self.show = true
    tween.delay(0.4, Cursor._blink, self)
end

function Cursor:draw()
    if self.show then
        pushStyle()
            strokeWidth(3)
            stroke(0, 0, 0, 255)
            line(self.x, 0, self.x, self.h)
        popStyle()
    end
end

function Cursor._blink(cursor)
    cursor.show = not cursor.show
    tween.delay(0.4, Cursor._blink, cursor)
end