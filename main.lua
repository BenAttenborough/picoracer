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
    horzY = 60
    leftBezierAnchorX = leftRoadBottomX 
    rightBezierAnchorX = rightRoadBottomX 
    centralBezierAnchorX = 64
    horzMovementInterval = 0.25
    curbWidth = 4
    logfile = "log2.txt"
    -- slowCount = 1
    tempMovementCount = 1
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
    Dlog("Initialise log", true)
    speed = 1
    maxInterval = 30
    interval = 0
    frameAction = 0
    count = 0
    trackCount = 0
    instructionCount = #track
    currentInstruction = 0
    instructionMovementCount = 1
    carX = 53
end

function _update60()
    instructionDuration = track[currentInstruction + 1][1]
    instructionDirection = track[currentInstruction + 1][2]
    instructionDistance = track[currentInstruction + 1][3]
    input()
    interval = maxInterval / speed
    frameAction = flr(maxInterval / interval)
    count += 1
    count = count % maxInterval
    if count % frameAction != 0 then
        movementCount += 1
        trackCount += 1
        if instructionMovementCount < instructionDistance then
            if instructionDirection == "right" then
                moveRoadRight()
            elseif instructionDirection == "left" then
                moveRoadLeft()
            end
            instructionMovementCount += 1
        end
    end
    if movementCount == 5 then toggle = not toggle end 
    movementCount = movementCount % 5
    if trackCount == instructionDuration then 
        currentInstruction += 1
        currentInstruction = currentInstruction % instructionCount
        trackCount = 0
        instructionMovementCount = 0
    end
    cameraX = centralYAtBezier - 64
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
    print("speed:" .. speed,5,17,7)
    print("track count:" .. trackCount,5,23,7)
    print("instruction count:" .. instructionCount,5,29,7)
    print("instruction duration:" .. instructionDuration,5,35,7)
    print("instruction direction:" .. instructionDirection,5,41,7)
    print("instruction distance:" .. instructionDistance,5,47,7)
    -- print("count:" .. count,5,29,7)
    -- print("interval:" .. interval,5,35,7)
    -- print("frameAction:" .. frameAction,5,41,7)
    -- print("movementCount:" .. movementCount,5,29,7)
    sspr(sx,sy,carWidth,carHeight,carX,110)
end

function moveRoadLeft()
    leftBezierAnchorX += 1
    rightBezierAnchorX += 1
    centralBezierAnchorX += 1
    leftRoadTopX -= horzMovementInterval
    rightRoadTopX -= horzMovementInterval
    centralRoadTopX -= horzMovementInterval
end

function moveRoadRight()
    leftBezierAnchorX -= 1
    rightBezierAnchorX -= 1
    centralBezierAnchorX -= 1
    leftRoadTopX += horzMovementInterval
    rightRoadTopX += horzMovementInterval
    centralRoadTopX += horzMovementInterval
end

function input()
    if (btn(0)) then
        carX -= 1
    end
    if (btn(1)) then
        carX += 1
    end
    if (btn(2)) then
        horzY += 1
    end
    if (btn(3)) then
        horzY -= 1
    end
    if (btnp(4)) then
        speed = max(1, speed - 1)
    end
    if (btnp(5)) then
        speed = min(5, speed + 1)
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
    local sectionDrawDistance = 5
    local sectionDrawDistanceFull = 10
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
        -- if i >= 123 and i < 175 then
        --     sectionDrawDistance = 4
        --     sectionDrawDistanceFull = 8 
        -- elseif i >= 175 and i < 200 then
        --     sectionDrawDistance = 3
        --     sectionDrawDistanceFull = 6
        -- end
        -- if i >= 175 and i < 200 then
        --     sectionDrawDistance = 3
        --     sectionDrawDistanceFull = 6
        -- end
        if flr(flr(y)%sectionDrawDistanceFull) >= movementCount and flr(flr(y)%sectionDrawDistanceFull) < movementCount + sectionDrawDistance then colour = colour1 else colour = colour2 end
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