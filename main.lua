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
    leftBezierAnchorX = leftRoadBottomX 
    rightBezierAnchorX = rightRoadBottomX 
    centralBezierAnchorX = 64
    horzMovementInterval = 0.25
    minXCurve = 0
    curbWidth = 4
    logfile = "log.txt"
    slowCount = 1
    movementCount = 1
    toggle = false
    carSprite = 96
    sx, sy = (carSprite % 16) * 8, flr(carSprite \ 16) * 8
    carHeight = 16
    carWidth = 24
    drawPoints = 200
    cameraX = 0
    centralYAtBezier = 0
    trackIndex = 1
    segmentLength = track[1][1]
    -- Dlog("Initialise log", true)
    tempCount = 0
    count = 0
end

function _update60()
    input()
    slowCount += 1
    slowCount = slowCount % 5
    movementCount += 1
    if movementCount == 5 then toggle = not toggle end 
    movementCount = movementCount % 5
    cameraX = centralYAtBezier - 64
    tempCount += 0.02
    count = flr(tempCount)
end

function _draw()
    cls(3)
    drawRoad(getLeftRoadConfig(),getRightRoadConfig(),drawPoints,0)
    drawLeftRoadEdge()
    drawCentralLine()
    drawRightRoadEdge()
    drawSky()
    print("fps:" .. stat(7),5,5,7)
    print("camera x:" .. cameraX,5,11,7)
    print("track:" .. track[1][2],5,17,7)
    print("count:" .. count,5,23,7)
    sspr(sx,sy,carWidth,carHeight,53,110)
end

function input()
    if (btn(0)) then
        leftBezierAnchorX += 1
        rightBezierAnchorX += 1
        centralBezierAnchorX += 1
        leftRoadTopX -= horzMovementInterval
        rightRoadTopX -= horzMovementInterval
        centralRoadTopX -= horzMovementInterval
    end
    if (btn(1)) then
        leftBezierAnchorX -= 1
        rightBezierAnchorX -= 1
        centralBezierAnchorX -= 1
        leftRoadTopX += horzMovementInterval
        rightRoadTopX += horzMovementInterval
        centralRoadTopX += horzMovementInterval
    end
    if (btn(2)) then
        horzY += 1
    end
    if (btn(3)) then
        horzY -= 1
    end
end

function drawCentralY()
    line(128/2, 0, 128/2, 128, 4)
end

function drawBezierY()
    line(0,bezierAnchorY,128,bezierAnchorY)
end

function drawCentralYAtBezier()
    line(centralYAtBezier,0,centralYAtBezier,128,8)
end

function drawSky()
    rectfill(0,0,127,horzY,12)
end

function getLeftRoadConfig()
    return {
        x1 = leftRoadBottomX,
        y1 = roadBottomY,
        x2 = leftRoadTopX,
        y2 = horzY,
        x3 = leftBezierAnchorX,
        y3 = bezierAnchorY
    }
end

function getRightRoadConfig()
    return {
        x1 = rightRoadBottomX,
        x2 = rightRoadTopX,
        x3 = rightBezierAnchorX,
        -- These calculations are unneeded apparently
        y1 = roadBottomY,
        y2 = horzY,
        y3 = bezierAnchorY
    }
end

function getCentralRoadConfig()
    return {
        x1 = centralRoadBottomX,
        y1 = roadBottomY,
        x2 = centralRoadTopX,
        y2 = horzY,
        x3 = centralBezierAnchorX,
        y3 = bezierAnchorY
    }
end

function drawLeftRoadEdge()
    drawqbcAlternating(getLeftRoadConfig(),drawPoints,curbWidth,7,8)
    -- pset(leftBezierAnchorX,bezierAnchorY,10)
end

function drawRightRoadEdge()
    drawqbcAlternating(getRightRoadConfig(),drawPoints,curbWidth,7,8)
    -- pset(rightBezierAnchorX,bezierAnchorY,10)
end

function drawCentralLine()
    calculateCameraX(getCentralRoadConfig(),drawPoints,2,7,0)
    drawqbcAlternating(getCentralRoadConfig(),drawPoints,2,7,0)
    -- pset(centralBezierAnchorX,bezierAnchorY,10)
end

function lv(v1,v2,t)
    return (1-t)*v1+t*v2
end

--Quadratic Bezier Curve Vector
function qbcvector(v1,v2,v3,t) 
    return  lv(lv(v1,v3,t), lv(v3,v2,t),t)
end

function drawqbcAlternating(lineConfig,n,width,colour1,colour2)
    if toggle then 
        local temp = colour1
        colour1 = colour2
        colour2 = temp
    end
    local colour = colour1
    for i = 1,n do 
        local t = i/n
        local x = qbcvector(lineConfig.x1,lineConfig.x2,lineConfig.x3,t) - cameraX
        local y = qbcvector(lineConfig.y1,lineConfig.y2,lineConfig.y3,t)
        if flr(flr(y)%10) >= movementCount and flr(flr(y)%10) < movementCount + 5 then colour = colour1 else colour = colour2 end
        line(x,y,x+(width-1),y,colour)
    end
end

function drawRoad(leftRoadConfig, rightRoadConfig, n, fillColour)
    for i = 1,n do 
        local t = i/n
        local x1 = qbcvector(leftRoadConfig.x1,leftRoadConfig.x2,leftRoadConfig.x3,t) - cameraX
        local y1 = qbcvector(leftRoadConfig.y1,leftRoadConfig.y2,leftRoadConfig.y3,t)
        local x2 = qbcvector(rightRoadConfig.x1,rightRoadConfig.x2,rightRoadConfig.x3,t) - cameraX
        -- calculating y2 is unneeded apparently as it the same as y1
        line(x1,y1,x2,y1,fillColour)
        
    end
end

function calculateCameraX(lineConfig,n,width,colour1,colour2)
    for i = 1,n do 
        local t = i/n
        local x = qbcvector(lineConfig.x1,lineConfig.x2,lineConfig.x3,t) 
        local y = qbcvector(lineConfig.y1,lineConfig.y2,lineConfig.y3,t)
        if flr(y) == bezierAnchorY then
            centralYAtBezier = x
            break
        end
    end
end

function Dlog(str, overwrite)
    overwrite = overwrite or false
    printh(str, logfile, overwrite)
 end