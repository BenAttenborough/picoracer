function _init()
    roadWidthBottom = 120
    roadWidthTop = 28
    roadWidthHalf = flr(roadWidthBottom / 2)
    roadWidthTopHalf = flr(roadWidthTop / 2)
    screenwidth = 128
    screenXMid = flr(screenwidth / 2)
    roadBottomY = 148
    bezierAnchorY = 120
    leftRoadTopX = screenXMid - roadWidthTopHalf
    rightRoadTopX = screenXMid + roadWidthTopHalf
    centralRoadTopX = 64
    leftRoadBottomX = screenXMid - roadWidthHalf
    rightRoadBottomX = screenXMid + roadWidthHalf
    centralRoadBottomX = screenXMid
    horzY = 40
    bezierOffsetY = 5
    leftBezierAnchorX = leftRoadBottomX - bezierOffsetY
    rightBezierAnchorX = rightRoadBottomX + bezierOffsetY
    centralBezierAnchorX = 64
    horzMovementInterval = 0.25
    minXCurve = 0
    curbWidth = 4
    logfile = "log.txt"
    slowCount = 1
    movementCount = 1
    toggle = false
    carSprite = 96
    Dlog("Initialise log", true)
end

function _update60()
    input()
    slowCount += 1
    slowCount = slowCount % 5
    movementCount += 1
    if movementCount == 5 then toggle = not toggle end 
    movementCount = movementCount % 5
end

function _draw()
    cls(3)
    drawLeftRoadEdge()
    drawCentralLine()
    drawRightRoadEdge()
    drawSky()
    print("fps:" .. stat(7),5,5,7)
    -- print(slowCount,5,5,7)
    -- print(movementCount,5,5,7)
    -- print(toggle,5,12,7)

    -- sspr(96)
end

function shiftRoadLeft(amount)
    leftRoadBottomX -= amount
    leftRoadTopX -= amount
    leftBezierAnchorX += amount
    rightRoadBottomX -= amount
    rightRoadTopX -= amount
    rightBezierAnchorX += amount
    centralRoadBottomX -= amount
    centralRoadTopX -= amount
    centralBezierAnchorX += amount
end

function input()
    if (btn(0)) then
        leftBezierAnchorX += 1
        rightBezierAnchorX += 1
        centralBezierAnchorX += 1
        leftRoadTopX -= horzMovementInterval
        rightRoadTopX -= horzMovementInterval
        centralRoadTopX -= horzMovementInterval
        -- shiftRoadLeft(1)
    end
    if (btn(1)) then
        leftBezierAnchorX -= 1
        rightBezierAnchorX -= 1
        centralBezierAnchorX -= 1
        leftRoadTopX += horzMovementInterval
        rightRoadTopX += horzMovementInterval
        centralRoadTopX += horzMovementInterval
        -- screenXMid -= 1

    end
    if (btnp(2)) then
        horzY += 1
    end
    if (btnp(3)) then
        horzY -= 1
    end
end

function drawSky()
    rectfill(0,0,127,horzY,12)
end

function drawLeftRoadEdge()
    drawqbcExtended(leftRoadBottomX,roadBottomY,leftRoadTopX,horzY,leftBezierAnchorX,bezierAnchorY,200,0)
    drawqbcAlternating(leftRoadBottomX,roadBottomY,leftRoadTopX,horzY,leftBezierAnchorX,bezierAnchorY,200,curbWidth,7,8)
    pset(leftBezierAnchorX,bezierAnchorY,10)
end

function drawRightRoadEdge()
    drawqbcExtended(rightRoadBottomX,roadBottomY,rightRoadTopX,horzY,rightBezierAnchorX,bezierAnchorY,200,3)
    drawqbcAlternating(rightRoadBottomX,roadBottomY,rightRoadTopX,horzY,rightBezierAnchorX,bezierAnchorY,200,curbWidth,7,8)
    pset(rightBezierAnchorX,bezierAnchorY,10)
end

function drawCentralLine()
    drawqbcAlternating(centralRoadBottomX,roadBottomY,centralRoadTopX,horzY,centralBezierAnchorX,bezierAnchorY,200,2,7,0)
    pset(centralBezierAnchorX,bezierAnchorY,10)
end

function lv(v1,v2,t)
    return (1-t)*v1+t*v2
end

--Quadratic Bezier Curve Vector
function qbcvector(v1,v2,v3,t) 
    return  lv(lv(v1,v3,t), lv(v3,v2,t),t)
end

--draw Quadratic Bezier Curve
--x1,y1 = starting point 
--x2,y2 = end point
--x3,y3 = 3rd manipulating point 
--n = "amount of pixels in curve"(just put it higher than you expect)
--c = color
function drawqbc(x1,y1,x2,y2,x3,y3,n,w,c)
    for i = 1,n do 
        local t = i/n
        local x = qbcvector(x1,x2,x3,t)
        local y = qbcvector(y1,y2,y3,t)
        for j = 0,(w-1) do
            pset(x+j,y,c)
        end
    end
end

-- function toggleCurbColours()
--     local temp = c1
--     c1 = c2
--     c2 = temp
-- end

function drawqbcAlternating(x1,y1,x2,y2,x3,y3,n,w,c1,c2)
    if toggle then 
        local temp = c1
        c1 = c2
        c2 = temp
    end
    local initY = qbcvector(y1,y2,y3,1/n)
    local colour = c1
    for i = 1,n do 
        local t = i/n
        local x = qbcvector(x1,x2,x3,t)
        local y = qbcvector(y1,y2,y3,t)  
        if flr(flr(y)%10) >= movementCount and flr(flr(y)%10) < movementCount + 5 then colour = c1 else colour = c2 end
        for j = 0,(w-1) do
            pset(x+j,y,colour)
        end
    end
end

function drawqbcExtended(x1,y1,x2,y2,x3,y3,n,c)
    for i = 1,n do 
        local t = i/n
        local x = qbcvector(x1,x2,x3,t)
        local y = qbcvector(y1,y2,y3,t)
        for newX = x,128 do
            pset(newX,y,c)
        end
    end
end

function Dlog(str, overwrite)
    overwrite = overwrite or false
    printh(str, logfile, overwrite)
 end