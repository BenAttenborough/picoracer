function _init()
    leftBezierAnchorX = 20
    leftBezierAnchorY = 120
    rightBezierAnchorX = 108
    rightBezierAnchorY = 120
    leftBezierTopX = 50
    rightBezierTopX = 78
    horzY = 40
end

function _update()
    if (btn(0)) then
        leftBezierAnchorX -= 1
        rightBezierAnchorX -= 1
        leftBezierTopX += 0.5
        rightBezierTopX += 0.5
    end
    if (btn(1)) then
        leftBezierAnchorX += 1
        rightBezierAnchorX += 1
        leftBezierTopX -= 0.5
        rightBezierTopX -= 0.5
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
    drawqbc(20,158,leftBezierTopX,horzY,leftBezierAnchorX,leftBezierAnchorY,200,0)
    rect(leftBezierAnchorX,leftBezierAnchorY,leftBezierAnchorX,leftBezierAnchorY,8)
end

function drawRightRoadEdge()
    drawqbc(108,158,rightBezierTopX,horzY,rightBezierAnchorX,rightBezierAnchorY,200,0)
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
function drawqbc(x1,y1,x2,y2,x3,y3,n,c)
    for i = 1,n do 
        local t = i/n
       pset(qbcvector(x1,x2,x3,t),qbcvector(y1,y2,y3,t),c)
    end
end