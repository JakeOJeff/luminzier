
local objects = {
    x = 5,
    y = GLOBAL_VARS.leftTaskBar.height / 3 * 1,
    width = GLOBAL_VARS.leftTaskBar.width - 10,
    height = GLOBAL_VARS.leftTaskBar.height / 3 - 5,

    children = {{
        name = "obj1",
        properties = {{
            name = "Health",
            value = 100,
            type = "num"
        }, {
            name = "Speed",
            value = 10,
            type = "num"
        }}
    }, {
        name = "obj2",
        properties = {{
            name = "Power",
            value = 50,
            type = "num"
        }, {
            name = "Defense",
            value = 20,
            type = "num"
        }}
    }},

    clickedChild = {}
}
local tween = require 'packages.tween'
local lg = love.graphics

local mouseReleased = true

function objects:load()
    for _, child in ipairs(self.children) do
        child.color = {0.4, 0.4, 0.4}
        child.tween = nil
        child.isHovered = false
        child.deleteIsHovered = false
    end
end

function objects:update(dt)
    local mx, my = love.mouse.getPosition()
    local toRemove = nil
    local clicked = nil

    for i, child in ipairs(self.children) do
        -- Update tween animation
        if child.tween then
            local complete = child.tween:update(dt)
            if complete then
                child.tween = nil
            end
        end

        local itemY = self.y + (22 * i)
        local isHovering = mx > self.x + 5 and mx < self.x + self.width - 10
            and my > itemY and my < itemY + 20

        local isHoveringDelete = mx > self.x + self.width - 25 and mx < self.x + self.width - 10
            and my > itemY and my < itemY + 20

        child.deleteIsHovered = isHoveringDelete

        if love.mouse.isDown(1) and mouseReleased then
            if isHoveringDelete then
                toRemove = i
            elseif isHovering then
                clicked = child
            end
        end
    end

    if toRemove then
        table.remove(self.children, toRemove)
        self.clickedChild = {} -- clear selected if deleted
    elseif clicked then
        self.clickedChild = clicked
    end

    -- Handle one-time click logic
    if love.mouse.isDown(1) then
        mouseReleased = false
    else
        mouseReleased = true
    end
end


function objects:getCurrentChild()
    print(self.clickedChild.name)
    return self.clickedChild
end

function objects:draw()
    lg.setColor(0.3, 0.3, 0.3)
    lg.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)

    local mx, my = love.mouse.getPosition()
    local y = self.y

    for i, child in ipairs(self.children) do
        local itemY = y + (22 * i)
        local isHovering = mx > self.x + 5 and mx < self.x + self.width - 10
            and my > itemY and my < itemY + 20

        -- Trigger tween animations on hover
        if isHovering and not child.isHovered then
            child.isHovered = true
            child.tween = tween.new(0.2, child.color, {0.5, 0.5, 0.5}, 'inOutQuad')
        elseif not isHovering and child.isHovered then
            child.isHovered = false
            child.tween = tween.new(0.2, child.color, {0.4, 0.4, 0.4}, 'inOutQuad')
        end

        -- Select on click
        if isHovering and love.mouse.isDown(1) and mouseReleased then
            self.clickedChild = child
        end

        -- Draw child background
        lg.setColor(child.color)
        lg.rectangle("fill", self.x + 5, itemY, self.width - 10, 20, 5, 5)

        -- Draw child name
        lg.setColor(1, 1, 1)
        lg.print(child.name, self.x + 8, itemY + 2)

        -- Draw delete button (X)
        lg.setColor(child.deleteIsHovered and {1, 0.2, 0.2} or {1, 1, 1})
        lg.print("X", self.x + self.width - 20, itemY + 2)
    end
end

return objects
