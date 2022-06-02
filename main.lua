function _init()
    roadBottomY = 158
    bezierAnchorY = 120
    leftBezierAnchorX = 20
    rightBezierAnchorX = 108
    centralBezierAnchorX = 64
    leftBezierTopX = 50
    rightBezierTopX = 78
    centralBezierTopX = 64
    horzY = 40
    horzMovementInterval = 0.25
    minXCurve = 0
    curbWidth = 4
    logfile = "log.txt"
end

function _update()
    if (btn(0)) then
        leftBezierAnchorX -= 1
        rightBezierAnchorX -= 1
        centralBezierAnchorX -= 1
        leftBezierTopX += horzMovementInterval
        rightBezierTopX += horzMovementInterval
        centralBezierTopX += horzMovementInterval
    end
    if (btn(1)) then
        leftBezierAnchorX += 1
        rightBezierAnchorX += 1
        centralBezierAnchorX += 1
        leftBezierTopX -= horzMovementInterval
        rightBezierTopX -= horzMovementInterval
        centralBezierTopX -= horzMovementInterval
    end
    if (btn(2)) then
        bezierAnchorY -= 1
        bezierAnchorY -= 1
    end
    if (btn(3)) then
        bezierAnchorY += 1
        bezierAnchorY += 1
    end
end

function _draw()
    cls(3)
    drawLeftRoadEdge()
    drawCentralLine()
    drawRightRoadEdge()
    drawSky()
    
end

function drawSky()
    rectfill(0,0,127,horzY,12)
end

function drawLeftRoadEdge()
    drawqbcExtended(20,roadBottomY,leftBezierTopX,horzY,leftBezierAnchorX,bezierAnchorY,200,0)
    drawqbcAlternating(20,roadBottomY,leftBezierTopX,horzY,leftBezierAnchorX,bezierAnchorY,200,curbWidth,7,8)
    -- pset(leftBezierAnchorX,bezierAnchorY,8)
end

function drawRightRoadEdge()
    drawqbcExtended(108,roadBottomY,rightBezierTopX,horzY,rightBezierAnchorX,bezierAnchorY,200,3)
    drawqbcAlternating(108,roadBottomY,rightBezierTopX,horzY,rightBezierAnchorX,bezierAnchorY,200,curbWidth,7,8)
    -- pset(rightBezierAnchorX,bezierAnchorY,8)
end

function drawCentralLine()
    drawqbcAlternating(64,roadBottomY,centralBezierTopX,horzY,centralBezierAnchorX,bezierAnchorY,200,2,7,0)
    -- pset(centralBezierAnchorX,bezierAnchorY,8)
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

function toggleColour(originalCol,c1,c2)
    if originalCol == c1 then return c2 else return c1
    end
end

function drawqbcAlternating(x1,y1,x2,y2,x3,y3,n,w,c1,c2)
    local colour = c1
    for i = 1,n do 
        local t = i/n
        local x = qbcvector(x1,x2,x3,t)
        local y = qbcvector(y1,y2,y3,t)
        if flr(y) % 5 == 1 then colour = toggleColour(colour,c1,c2) end
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
        -- count x to 128
        for newX = x,128 do
            pset(newX,y,c)
        end
    end
end

function Dlog(str, overwrite)
    overwrite = overwrite or false
    printh(str, logfile, overwrite)
 end