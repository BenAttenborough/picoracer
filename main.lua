function _init()
    leftBezierAnchorX = 20
    leftBezierAnchorY = 120
    rightBezierAnchorX = 108
    rightBezierAnchorY = 120
    leftBezierTopX = 50
    rightBezierTopX = 78
    horzY = 40
    horzMovementInterval = 0.25
    minXCurve = 0
    curbWidth = 2
end

function _update()
    if (btn(0)) then
        leftBezierAnchorX -= 1
        rightBezierAnchorX -= 1
        -- Useful idea below but would need to consider movement in the other direction
        -- leftBezierAnchorX = max(leftBezierAnchorX - 1, minXCurve)
        -- rightBezierAnchorX = max(rightBezierAnchorX - 1, minXCurve + 88)
        leftBezierTopX += horzMovementInterval
        rightBezierTopX += horzMovementInterval
    end
    if (btn(1)) then
        leftBezierAnchorX += 1
        rightBezierAnchorX += 1
        leftBezierTopX -= horzMovementInterval
        rightBezierTopX -= horzMovementInterval
    end
    if (btn(2)) then
        leftBezierAnchorY -= 1
        rightBezierAnchorY -= 1
    end
    if (btn(3)) then
        leftBezierAnchorY += 1
        rightBezierAnchorY += 1
    end
end

function _draw()
    cls(3)
    drawLeftRoadEdge()
    drawRightRoadEdge()
    drawSky()
    
end

function drawSky()
    rectfill(0,0,127,horzY,12)
end

function drawLeftRoadEdge()
    drawqbcExtended(20,158,leftBezierTopX,horzY,leftBezierAnchorX,leftBezierAnchorY,200,0)
    drawqbc(20,158,leftBezierTopX,horzY,leftBezierAnchorX,leftBezierAnchorY,200,curbWidth,7)
    rect(leftBezierAnchorX,leftBezierAnchorY,leftBezierAnchorX,leftBezierAnchorY,8)
end

function drawRightRoadEdge()
    drawqbcExtended(108,158,rightBezierTopX,horzY,rightBezierAnchorX,rightBezierAnchorY,200,3)
    drawqbc(108,158,rightBezierTopX,horzY,rightBezierAnchorX,rightBezierAnchorY,200,curbWidth,7)
    rect(rightBezierAnchorX,rightBezierAnchorY,rightBezierAnchorX,rightBezierAnchorY,8)
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