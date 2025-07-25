local drawElements = {}
cv = GLOBAL_VARS.canvas

local patternFunctions = {
    lissajous = function(p, t, props)
        return props.x + p.radius * math.sin(p.a * t + p.delta), props.y + p.radius * math.sin(p.b * t)
    end
}

function drawElements:update(dt)
    time = time + dt
    for i = 1, #objects.children do
        local obj = objects.children[i]
        if obj.type == "Pattern" then
            self:updatePattern(obj)
        end

    end
end

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

        if love.graphics.rectangle(props.mode, cv.x + props.x, cv.y + props.y, props.width, props.height, props.rx, props.ry) then
            love.graphics.rectangle(props.mode, cv.x + props.x, cv.y + props.y, props.width, props.height, props.rx, props.ry)
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
        love.graphics.setColor(props.color)
        for _, p in ipairs(obj.particles) do
            for i = 1, #p.trail - 1 do
                local a = p.trail[i]
                local b = p.trail[i + 1]
                local alpha = (1 - i / #p.trail) * 0.7
                love.graphics.setColor(0.4 + i / #p.trail, 0.8, 1, alpha)
                love.graphics.line(a.x, a.y, b.x, b.y)
            end
        end
    end
end
function drawElements:updatePattern(obj)
    local mx, my = love.mouse.getPosition()
    local modeFunc = patternFunctions[obj.name]
    local props = unpackProperties(obj.properties)

    for _, p in ipairs(obj.particles) do
        local t = time * p.speed + p.phase
        local x, y = modeFunc(p, t, props)

        -- Mouse attraction
        local dx, dy = mx - x, my - y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < 150 then
            x = x + dx * 0.01
            y = y + dy * 0.01
        end

        table.insert(p.trail, 1, {
            x = x,
            y = y
        })
        if #p.trail > 25 then
            table.remove(p.trail)
        end
    end
end

function checkForError(props)

end
return drawElements
