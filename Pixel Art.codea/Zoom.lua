-- Zoom by @Herwig

Zoom = class()

function Zoom:init()
    -- you can accept and set parameters here
    self.touches = {}
    self:clear()
end

function Zoom:clear()
    self.lastPinchDist = 0
    self.pinchDelta = 1.0
    self.center = vec2(0,0)
    self.offset = vec2(0,0)
    self.zoom = 1
    self.started = false
    self.started2 = false
end

function Zoom:touched(touch)
    -- Codea does not automatically call this method
    if touch.state == ENDED or touch.state == CANCELLED then
        self.touches[touch.id] = nil
    else
        self.touches[touch.id] = touch
        if (touch.tapCount==2) then
            --self:clear()
        end
    end
end

function Zoom:processTouches()
    local touchArr = {}
    for k,touch in pairs(self.touches) do
        -- push touches into array
        table.insert(touchArr,touch)
    end

    if #touchArr == 2 then
        self.started = false
        local t1 = vec2(touchArr[1].x,touchArr[1].y)
        local t2 = vec2(touchArr[2].x,touchArr[2].y)

        local dist = t1:dist(t2)
        if self.started2 then
        --if self.lastPinchDist > 0 then 
            self.pinchDelta = dist/self.lastPinchDist          
        else
            self.offset= self.offset + ((t1 + t2)/2-self.center)/self.zoom
            self.started2 = true
        end
        self.center = (t1 + t2)/2
        self.lastPinchDist = dist
    elseif (#touchArr == 1) then
        self.started2 = false
        local t1 = vec2(touchArr[1].x,touchArr[1].y)
        self.pinchDelta = 1.0
        self.lastPinchDist = 0
        if not(self.started) then
            self.offset = self.offset + (t1-self.center)/self.zoom
            self.started = true
        end
        self.center=t1
    else
        self.pinchDelta = 1.0
        self.lastPinchDist = 0
        self.started = false
        self.started2 = false
    end
end

function Zoom:clip(x,y,w,h)
    clip(x*self.zoom+self.center.x- self.offset.x*self.zoom,
        y*self.zoom+self.center.y- self.offset.y*self.zoom,
        w*self.zoom+1,h*self.zoom+1)
end

function Zoom:text(str,x,y)
    local fSz = fontSize()
    local xt=x*self.zoom+self.center.x- self.offset.x*self.zoom
    local yt=y*self.zoom+self.center.y- self.offset.y*self.zoom
    fontSize(fSz*self.zoom)
    local xtsz,ytsz=textSize(str)
    tsz=xtsz
    if tsz<ytsz then tsz=ytsz end
    if (tsz>2048) then
        local eZoom= tsz/2048
        fontSize(fSz*self.zoom/eZoom)
        pushMatrix()
        resetMatrix()
        translate(xt,yt)
        scale(eZoom)
        text(str,0,0)
        popMatrix()
        fontSize(fSz)
    else
        pushMatrix()
        resetMatrix()
        fontSize(fSz*self.zoom)
        text(str,xt,yt)
        popMatrix()
        fontSize(fSz)
    end
end

function Zoom:clip(x,y,w,h)
    clip(x*self.zoom+self.center.x- self.offset.x*self.zoom,
        y*self.zoom+self.center.y- self.offset.y*self.zoom,
        w*self.zoom+1,h*self.zoom+1)
end

function Zoom:text(str,x,y)
    local fSz = fontSize()
    local xt=x*self.zoom+self.center.x- self.offset.x*self.zoom
    local yt=y*self.zoom+self.center.y- self.offset.y*self.zoom
    fontSize(fSz*self.zoom)
    local xtsz,ytsz=textSize(str)
    tsz=xtsz
    if tsz<ytsz then tsz=ytsz end
    if (tsz>2048) then
        local eZoom= tsz/2048
        fontSize(fSz*self.zoom/eZoom)
        pushMatrix()
        resetMatrix()
        translate(xt,yt)
        scale(eZoom)
        text(str,0,0)
        popMatrix()
        fontSize(fSz)
    else
        pushMatrix()
        resetMatrix()
        fontSize(fSz*self.zoom)
        text(str,xt,yt)
        popMatrix()
        fontSize(fSz)
    end
end

function Zoom:draw()
    -- compute pinch delta
    self:processTouches()
    -- scale by pinch delta
    self.zoom = math.max( self.zoom*self.pinchDelta, 0.2 )

    translate(self.center.x- self.offset.x*self.zoom,
        self.center.y- self.offset.y*self.zoom)
    scale(self.zoom,self.zoom)

    self.pinchDelta = 1.0
    
end
