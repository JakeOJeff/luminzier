local drawElements = {}
cv = GLOBAL_VARS.canvas

local function unpackProperties(propList)
    local props = {}
    for _, prop in ipairs(propList) do
        props[prop.name] = prop.value
    end
    return props
end

function drawElements:allDraw()
    print(#objects.children)
    for i = 1, #objects.children do
        local obj = objects.children[i]
        print(obj.name)
        self:checkRect(obj)
    end
end

function drawElements:checkRect(obj)
    if obj.name == "Rectangle" then
        print("YESS")
        local props = unpackProperties(obj.properties)

        love.graphics.setColor(props.color)
        love.graphics.rectangle(props.mode,cv.x + props.x,cv.y + props.y, props.width, props.height)
    end
end

return drawElements
