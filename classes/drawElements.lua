local drawElements = {}
cv = GLOBAL_VARS.canvas

function drawElements:allDraw()
    for i = 1, #objects.children do
        local obj = objects.children[i]
        self:checkRect(obj)
        self:checkCirc(obj)
        self:checkPattern(obj)
    end
end


function drawElements:checkRect(obj)
    if obj.name == "Rectangle" then
        local props = unpackProperties(obj.properties)
        local mx, my = love.mouse.getPosition()
        love.graphics.setColor(props.color)

        if inBox(mx, my, cv.x + props.x, cv.y + props.y, props.width, props.height) and not selection.modalBox then
            if love.mouse.isDown(1) then
                objects.clickedChild = obj
                objects:scrollToChild(obj)

            end
            love.graphics.setColor(0, 0, 1, 0.5)
        end

        if love.graphics.rectangle(props.mode, cv.x + props.x, cv.y + props.y, props.width, props.height) then
            love.graphics.rectangle(props.mode, cv.x + props.x, cv.y + props.y, props.width, props.height)
        end
    end
end
function drawElements:checkCirc(obj)
    if obj.name == "Circle" then
        local props = unpackProperties(obj.properties)
        local mx, my = love.mouse.getPosition()
        love.graphics.setColor(props.color)
        print("radius:", props.radius, "x:", props.x, "y:", props.y)

        if inCircle(mx, my, cv.x + props.radius + props.x, cv.y + props.radius + props.y, props.radius) and
            not selection.modalBox then
            if love.mouse.isDown(1) then
                objects.clickedChild = obj
                objects:scrollToChild(obj)

            end
            love.graphics.setColor(0, 0, 1, 0.5)
        end
        if love.graphics.circle(props.mode, cv.x + props.radius + props.x, cv.y + props.radius + props.y, props.radius) then
            love.graphics.circle(props.mode, cv.x + props.radius + props.x, cv.y + props.radius + props.y, props.radius)
        end
    end
end
function drawElements:checkPattern(obj)
    if obj.type == "Pattern" then
        local props = unpackProperties(obj.properties)
        local mx, my = love.mouse.getPosition()

        -- fallback/defaults
        local t = love.timer.getTime()
        local radius = props.radius or 100
        local a = props.a or 1
        local b = props.b or 1
        local delta = props.delta or 0

        local modeFunc = modeFunctions[obj.name]
        if not modeFunc then return end

        -- simulate particle with required properties
        local particle = {
            radius = radius,
            a = a,
            b = b,
            delta = delta
        }

        love.graphics.setColor(1, 1, 1, 1)
        local lastX, lastY
        for i = 0, 100, 2 do
            local tSample = t + i * 0.1
            local x, y = modeFunc(particle, tSample)
            if lastX and lastY then
                love.graphics.setColor(1, 0.7, 0.2, 0.6)
                love.graphics.line(lastX, lastY, x, y)
            end
            lastX, lastY = x, y
        end

        -- hover detection (bounding circle)
        local cx, cy = modeFunc(particle, t)
        local dist = math.sqrt((mx - cx)^2 + (my - cy)^2)
        if dist < radius and not selection.modalBox then
            if love.mouse.isDown(1) then
                objects.clickedChild = obj
                objects:scrollToChild(obj)
            end
            love.graphics.setColor(0, 0, 1, 0.3)
            love.graphics.circle("fill", cx, cy, 10)
        end
    end
end

function checkForError(props)

end
return drawElements
