local selection = {
    x = 5,
    y = GLOBAL_VARS.leftTaskBar.height / 3 * 2,
    width = GLOBAL_VARS.leftTaskBar.width - 10,
    height = GLOBAL_VARS.leftTaskBar.height / 3 - 5,
    modalBox = true,
    modalBoxData = {
        x = GLOBAL_VARS.leftTaskBar.x + 35 + GLOBAL_VARS.canvas.width / 2,
        y = 10 + GLOBAL_VARS.canvas.height / 2 - 100,
        width = 400,
        height = 200

    },
    enableInput = false,
    dragPosition = {
        x = 0,
        y = 0
    },
    modalBoxDragging = false,
    child = {},
    selectedProperty = {
        name = "name",
        value = 0,
        type = "num"
    }
}
local tween = require 'packages.tween'

function selection:load()

    closeButton = Button:new()
    closeButton.color = {0.3, 0.3, 0.3}
    closeButton.text = "X"
    closeButton.x = self.modalBoxData.x + self.modalBoxData.width - self.modalBoxData.height / 5
    closeButton.y = self.modalBoxData.y

    closeButton.width = self.modalBoxData.height / 5
    closeButton.height = self.modalBoxData.height / 5

    closeButton.hover.color = {0.4, 0.4, 0.4}
    closeButton.hover.width = closeButton.width + 6
    closeButton.hover.height = closeButton.height + 6
    closeButton.hover.x = closeButton.x - 3
    closeButton.hover.y = closeButton.y - 3

    closeButton:recall()

    closeButton.callback = function()
        self.modalBox = false
    end

    for _, child in ipairs(self.selectedProperty) do
        child.color = {0.4, 0.4, 0.4}
        child.tween = nil
        child.isHovered = false
    end
end

function selection:update(dt)

    closeButton:update(dt)
    if love.mouse.isDown(1) and self.modalBoxDragging then
        mx, my = love.mouse.getPosition()

        self.modalBoxData.x = mx - self.dragPosition.x
        self.modalBoxData.y = my - self.dragPosition.y
        closeButton.x = self.modalBoxData.x + self.modalBoxData.width - self.modalBoxData.height / 5
        closeButton.y = self.modalBoxData.y
        closeButton.hover.x = closeButton.x - 3
        closeButton.hover.y = closeButton.y - 3
        closeButton:recall()

    end

    local newChild = objects:getCurrentChild()
    if newChild and newChild ~= self.child then
        self.child = newChild
        self:modalBoxReset()
    end
    if self.child and self.child.properties then
        for _, prop in ipairs(self.child.properties) do
            if prop.tween then
                local complete = prop.tween:update(dt)
                if complete then
                    prop.tween = nil
                end
            end
        end
    end

end

function selection:modalBoxReset()
    self.modalBox = false
    self.modalBoxData.x = GLOBAL_VARS.leftTaskBar.x + 35 + GLOBAL_VARS.canvas.width / 2
    self.modalBoxData.y = 10 + GLOBAL_VARS.canvas.height / 2 - 100
    closeButton.x = self.modalBoxData.x + self.modalBoxData.width - self.modalBoxData.height / 5
    closeButton.y = self.modalBoxData.y
    closeButton.hover.x = closeButton.x - 3
    closeButton.hover.y = closeButton.y - 3
    closeButton:recall()
end
function selection:draw()
    -- Properties Box
    lg.setColor(0.3, 0.3, 0.3)
    lg.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)

    mx, my = love.mouse.getPosition()

    y = self.y
    if self.child and self.child.properties then
        for i, prop in ipairs(self.child.properties) do
            local itemY = y + (22 * i)
            local isHovering = mx > self.x + 5 and mx < self.x + self.width - 10 and my > itemY and my < itemY + 20

            -- Init values if not yet defined
            if not prop.color then
                prop.color = {0.4, 0.4, 0.4}
                prop.isHovered = false
                prop.tween = nil
            end

            if isHovering and not prop.isHovered then
                prop.isHovered = true
                prop.tween = tween.new(0.2, prop.color, {0.5, 0.5, 0.5}, 'inOutQuad')
            elseif not isHovering and prop.isHovered then
                prop.isHovered = false
                prop.tween = tween.new(0.2, prop.color, {0.4, 0.4, 0.4}, 'inOutQuad')
            end

            if isHovering and love.mouse.isDown(1) then
                self.selectedProperty = prop
                self:modalBoxReset()
                self.modalBox = true
            end

            lg.setColor(prop.color)
            lg.rectangle("fill", self.x + 5, itemY, self.width - 10, 20, 5, 5)
            lg.setColor(1, 1, 1)
            lg.print(prop.name or "Unnamed", self.x + 8, itemY + 2)
        end

    end
end

function selection:drawModals()

    if self.modalBox then
        self.enableInput = true
        lg.setColor(0, 0, 0, .5)
        lg.rectangle("fill", 0, 0, window.w, window.h)

        lg.setColor(0.3, 0.3, 0.3)
        lg.rectangle("fill", self.modalBoxData.x, self.modalBoxData.y, self.modalBoxData.width,
            self.modalBoxData.height, 10, 10)

        lg.setColor(0.2, 0.2, 0.2)
        lg.rectangle("fill", self.modalBoxData.x, self.modalBoxData.y, self.modalBoxData.width,
            self.modalBoxData.height / 5, 10, 10)

        lg.setColor(1, 1, 1)
        lg.print(self.selectedProperty.name, self.modalBoxData.x + 20, self.modalBoxData.y + 20)

        if self.modalError then
            lg.setColor(1, 0, 0)
            lg.print(self.modalErrorMessage, self.modalBoxData.x + 20, self.modalBoxData.y + 40)
        end

        lg.setColor(1, 1, 1)
        if self.selectedProperty.type == "num" then
            lg.print(self.selectedProperty.name .. " Value : " .. self.selectedProperty.value, self.modalBoxData.x + 20,
            self.modalBoxData.y + 60)
        end
        

        -- Close Button
        closeButton:draw()
    else
        self.enableInput = false
    end
end

function selection:textinput(t)
    if self.enableInput and self.selectedProperty.type == "num" then
        local errorFlag = false

        if tonumber(self.selectedProperty.value) == nil then
            errorFlag = true
            self.modalError = true
            self.modalErrorMessage = "Not a '(Number)' Format"
        end

        if not errorFlag then
            -- Append or replace value depending on current content
            if tonumber(self.selectedProperty.value) < 1 then
                self.selectedProperty.value = t
            else
                self.selectedProperty.value = self.selectedProperty.value .. t
            end
        end
    end
end



function selection:keypressed(key)

    if key == "backspace" then
        if tonumber(self.selectedProperty.value) < 10 then
            self.selectedProperty.value = 0
        else
            self.selectedProperty.value = tonumber(string.sub(tostring(self.selectedProperty.value), 1, -2))

        end
    end

    if key == "return" then
        self.modalBox = false
        self:modalBoxReset()
    end
end

function selection:mousepressed(x, y, button)

    if self.modalBox then

        closeButton:mousepressed(x, y, button)

    end

    cv = GLOBAL_VARS.canvas
    if not self.modalBox and inBox(x, y, cv.x, cv.y, cv.width, cv.height) then
        objects.clickedChild = nil
        self.child = nil
    end
    if x > self.modalBoxData.x and x < self.modalBoxData.x + self.modalBoxData.width and y > self.modalBoxData.y and y <
        self.modalBoxData.y + self.modalBoxData.height / 5 and self.modalBox then
        if button == 1 then
            self.modalBoxDragging = true
            self.dragPosition.x = x - self.modalBoxData.x
            self.dragPosition.y = y - self.modalBoxData.y
        end
    end

end

function selection:mousereleased(x, y, button)

    if self.modalBoxDragging then
        self.modalBoxDragging = false
    end
end
return selection
