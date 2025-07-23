local objects = {
    x = 5,
    y = GLOBAL_VARS.leftTaskBar.height / 3 * 1,
    width = GLOBAL_VARS.leftTaskBar.width - 10,
    height = GLOBAL_VARS.leftTaskBar.height / 3 - 5,

    scrollY = 0,
    scrollSpeed = 40,
    maxScroll = 0,

    isDraggingChild = false,
    draggingChild = nil,
    dragOffsetY = 0,
    dragIndex = nil,

    pendingDrag = false,
    dragStartX = 0,
    dragStartY = 0,

    itemsList = {require 'items.rectangle', require 'items.circle'},
    addItemModalBox = false,
    addItemModalBoxData = {
        x = GLOBAL_VARS.leftTaskBar.width + 5,
        y = GLOBAL_VARS.leftTaskBar.height / 3 * 1,
        width = GLOBAL_VARS.leftTaskBar.width,
        height = 30
    },

    children = { -- initial items
        -- {
        --     name = "obj1",
        --     properties = {{
        --         name = "Health",
        --         value = 100,
        --         type = "num"
        --     }, {
        --         name = "Speed",
        --         value = 10,
        --         type = "num"
        --     }}
        -- }, {
        --     name = "obj2",
        --     properties = {{
        --         name = "Power",
        --         value = 50,
        --         type = "num"
        --     }, {
        --         name = "Defense",
        --         value = 20,
        --         type = "num"
        --     }}
        -- }
    },
    clickedChild = {}
}

local tween = require 'packages.tween'
local lg = love.graphics
local mouseReleased = true

function objects:load()
    addItemButton = Button:new()
    addItemButton.text = "+"
    addItemButton.x = 5
    addItemButton.y = self.y - 20
    addItemButton.width = self.width
    addItemButton.height = 20
    addItemButton.color = {0.3, 0.3, 0.3}

    addItemButton.hover.x = 5
    addItemButton.hover.y = self.y - 20
    addItemButton.hover.width = self.width
    addItemButton.hover.height = 20
    addItemButton.hover.color = {0.4, 0.4, 0.4}

    addItemButton:recall()
    addItemButton.callback = function()
        self.addItemModalBox = true
    end

    self:reloadChildClasses()

    local count = 0
    for _ in pairs(self.itemsList) do
        count = count + 1
    end
    self.addItemModalBoxData.height = 10 + (20 + 5) * count

end

function objects:reloadChildClasses()
    for _, child in ipairs(self.children) do
        child.color = {0.4, 0.4, 0.4}
        child.tween = nil
        child.isHovered = false
        child.deleteIsHovered = false
    end

end

function objects:update(dt)
    addItemButton:update(dt)
    self.maxScroll = math.max(0, ((#self.children + 1) * 22) - self.height)

    local mx, my = love.mouse.getPosition()
    local toRemove = nil
    local clicked = nil

    for i, child in ipairs(self.children) do
        if child.tween then
            if child.tween:update(dt) then
                child.tween = nil
            end
        end

        local itemY = self.y + (22 * i) - self.scrollY
        local isHovering = mx > self.x + 5 and mx < self.x + self.width - 10 and my > itemY and my < itemY + 20
        local isHoveringDelete = mx > self.x + self.width - 25 and mx < self.x + self.width - 10 and my > itemY and my <
                                     itemY + 20

        child.deleteIsHovered = isHoveringDelete

        if love.mouse.isDown(1) and mouseReleased then
            if isHoveringDelete then
                toRemove = i
            elseif isHovering then
                clicked = child
                self.pendingDrag = true
                self.dragStartX, self.dragStartY = mx, my
                self.dragOffsetY = itemY - my
                self.draggingChild = child
                self.dragIndex = i
            end
        end

    end

    if self.pendingDrag and love.mouse.isDown(1) then
        local dx = math.abs(mx - self.dragStartX)
        local dy = math.abs(my - self.dragStartY)

        if dx > 4 and dy > 4 then
            self.isDraggingChild = true
            self.pendingDrag = false
        end
    end

    if toRemove then
        table.remove(self.children, toRemove)
        self.clickedChild = {}
        self:reloadChildClasses()
    elseif clicked then
        self.clickedChild = clicked
        self:scrollToChild(clicked)
    end

    if not love.mouse.isDown(1) then
        if self.isDraggingChild and self.draggingChild and self.dragIndex then
            local newIndex = math.max(1, math.min(#self.children, math.floor((my - self.y + self.scrollY) / 22) + 1))

            if newIndex ~= self.dragIndex then
                local draggedItem = table.remove(self.children, self.dragIndex)
                table.insert(self.children, newIndex, draggedItem)
                self:reloadChildClasses()
            end
        end

        self.isDraggingChild = false
        self.draggingChild = nil
        self.dragIndex = nil
        self.pendingDrag = false
        mouseReleased = true
    else
        mouseReleased = false
    end

end

function objects:wheelmoved(x, y)
    print("Scroll Y:", y) -- debug print

    self.scrollY = self.scrollY - y * self.scrollSpeed
    self.scrollY = math.max(0, math.min(self.scrollY, self.maxScroll))
end
function objects:scrollToChild(target)
    -- Always update maxScroll before any scroll calculation
    self.maxScroll = math.max(0, (#self.children * 22) - self.height)

    for i, child in ipairs(self.children) do
        if child == target then
            local itemTop = self.y + (22 * (i - 1)) - self.scrollY
            local itemBottom = itemTop + 20

            -- Adjust scrollY only if needed
            if itemTop < self.y then
                self.scrollY = math.max(0, 22 * (i - 1))
            elseif itemBottom > self.y + self.height then
                self.scrollY = math.min(22 * (i - 1) - (self.height - 22), self.maxScroll)
            end
            break
        end
    end
end

function objects:getCurrentChild()
    return self.clickedChild
end

function objects:draw()
    lg.setColor(0.3, 0.3, 0.3)
    lg.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)

    addItemButton:draw()

    -- Clip to taskbar area
    lg.setScissor(self.x, self.y, self.width, self.height)

    local mx, my = love.mouse.getPosition()
    local y = self.y
    local draggedChild = nil
    local draggedY = nil

    for i, child in ipairs(self.children) do
        local itemY = y + (22 * i) - self.scrollY
        local itemX = self.x + 5

        local isHovering = mx > self.x + 5 and mx < self.x + self.width - 10 and my > itemY and my < itemY + 20

        if isHovering and not child.isHovered then
            child.isHovered = true
            child.tween = tween.new(0.2, child.color, {0.5, 0.5, 0.5}, 'inOutQuad')
        elseif not isHovering and child.isHovered then
            child.isHovered = false
            child.tween = tween.new(0.2, child.color, {0.4, 0.4, 0.4}, 'inOutQuad')
        end

        -- if draggedY == itemY then
        --     itemY = itemY + 22 - self.scrollY
        -- end
        if self.isDraggingChild and self.draggingChild == child then
            draggedChild = child
            draggedY = my + self.dragOffsetY
        else
            if self.clickedChild == child then
                lg.setColor(1, 1, 1, 0.5)
                lg.rectangle("fill", itemX - 3, itemY - 3, self.width - 10 + 6, 26, 5, 5)
            end

            lg.setColor(child.color)
            lg.rectangle("fill", itemX, itemY, self.width - 10, 20, 5, 5)

            lg.setColor(1, 1, 1)
            lg.print(child.name, itemX + 8, itemY + 2)

            lg.setColor(child.deleteIsHovered and {1, 0.2, 0.2} or {1, 1, 1})
            lg.print("X", itemX + self.width - 20, itemY + 2)
        end
    end

    -- Draw dragged item last (on top)
    if draggedChild then
        local itemX = self.x + 5
        lg.setColor(draggedChild.color)
        lg.rectangle("fill", itemX, draggedY, self.width - 10, 20, 5, 5)

        lg.setColor(1, 1, 1)
        lg.print(draggedChild.name, itemX + 8, draggedY + 2)

        lg.setColor(draggedChild.deleteIsHovered and {1, 0.2, 0.2} or {1, 1, 1})
        lg.print("X", itemX + self.width - 20, draggedY + 2)
    end

    lg.setScissor() -- Reset clipping
end

function objects:drawAddItemModal()
    if self.addItemModalBox then
        lg.setColor(0.3, 0.3, 0.3)
        lg.rectangle("fill", self.addItemModalBoxData.x, self.addItemModalBoxData.y, self.addItemModalBoxData.width,
            self.addItemModalBoxData.height, 5, 5)

        local mx, my = love.mouse.getPosition()
        local itemYStart = self.addItemModalBoxData.y + 5
        local spacing = 5

        for i, item in ipairs(self.itemsList) do
            -- Assign default states if not already set
            if not item.color then
                item.color = {0.4, 0.4, 0.4}
                item.isHovered = false
                item.tween = nil
            end

            local itemY = itemYStart + (i - 1) * (20 + spacing)
            local isHovering = inBox(mx, my, self.addItemModalBoxData.x + 5, itemY, self.addItemModalBoxData.width - 10,
                20)

            if isHovering and not item.isHovered then
                item.isHovered = true
                item.tween = tween.new(0.2, item.color, {0.5, 0.5, 0.5}, 'inOutQuad')
            elseif not isHovering and item.isHovered then
                item.isHovered = false
                item.tween = tween.new(0.2, item.color, {0.4, 0.4, 0.4}, 'inOutQuad')
            end

            if item.tween then
                local done = item.tween:update(love.timer.getDelta())
                if done then
                    item.tween = nil
                end
            end

            -- Draw modal item
            lg.setColor(item.color)
            lg.rectangle("fill", self.addItemModalBoxData.x + 5, itemY, self.addItemModalBoxData.width - 10, 20, 5, 5)

            lg.setColor(1, 1, 1)
            lg.print(item.type, self.addItemModalBoxData.x + 10, itemY + 2)
        end
    end
end

function objects:mousepressed(x, y, button)
    local box = self.addItemModalBoxData
    if not inBox(x, y, box.x, box.y, box.width, box.height) and self.addItemModalBox then
        self.addItemModalBox = false
    end

    if self.addItemModalBox then
        local i = 0
        local itemY = self.addItemModalBoxData.y + 5
        for _, item in pairs(self.itemsList) do
            if inBox(x, y, self.addItemModalBoxData.x + 5, itemY + (20 * i) + 5, self.addItemModalBoxData.width - 10, 20) then
                if button == 1 then
                    local function cloneItem(item)
                        local propsCopy = {}
                        for _, prop in ipairs(item.properties) do
                            table.insert(propsCopy, {
                                name = prop.name,
                                value = prop.value,
                                type = prop.type
                            })
                        end
                        return {
                            name = item.name,
                            properties = propsCopy,
                            color = {0.4, 0.4, 0.4},
                            tween = nil,
                            isHovered = false,
                            deleteIsHovered = false
                        }
                    end

                    table.insert(self.children, cloneItem(item))
                    self:reloadChildClasses()
                end
            end
            i = i + 1
        end
    end

    addItemButton:mousepressed(x, y, button)
end

return objects
