local drawElements = {}
cv = GLOBAL_VARS.canvas



function drawElements:allDraw()
    for i = 1, #objects.children do
        local obj = objects.children[i]
        self:checkRect(obj)
        self:checkCirc(obj)
    end
end

function drawElements:checkRect(obj)
    if obj.name == "Rectangle" then
        local props = unpackProperties(obj.properties)
        local mx, my = love.mouse.getPosition()
        love.graphics.setColor(props.color)

        if inBox(mx, my, cv.x + props.x, cv.y + props.y, props.width, props.height) and not selection.modalBox  then
            if love.mouse.isDown(1) then
                objects.clickedChild = obj
                objects:scrollToChild(obj)

            end
            love.graphics.setColor(0, 0, 1, 0.5)
        end

        love.graphics.rectangle(props.mode, cv.x + props.x, cv.y + props.y, props.width, props.height)
    end
end
function drawElements:checkCirc(obj)
    if obj.name == "Circle" then
        local props = unpackProperties(obj.properties)
        local mx, my = love.mouse.getPosition()
        love.graphics.setColor(props.color)
print("radius:", props.radius, "x:", props.x, "y:", props.y)

        if inCircle(mx, my, cv.x + props.radius + props.x, cv.y + props.radius + props.y, props.radius) and not selection.modalBox then
            if love.mouse.isDown(1) then
                objects.clickedChild = obj
                objects:scrollToChild(obj)

            end
            love.graphics.setColor(0, 0, 1, 0.5)
        end
        love.graphics.circle(props.mode, cv.x + props.radius + props.x, cv.y + props.radius + props.y, props.radius)
    end
end
return drawElements
