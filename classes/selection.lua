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
end

function selection:update(dt)

    closeButton:update(dt)
    if love.mouse.isDown(1) and self.modalBoxDragging then
        print("WHOOP WHOOP")
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
        print("PROPS EXIST " .. #self.child.properties)
        for i = 1, #self.child.properties do
            local prop = self.child.properties[i]
            local itemY = y + (16 * i)

            if mx > self.x + 5 and mx < self.x + self.width - 10 and my > itemY and my < itemY + 14 then
                lg.setColor(0.5, 0.5, 0.5)
                if love.mouse.isDown(1) then
                    self.selectedProperty = prop
                    self:modalBoxReset()
                    self.modalBox = true
                end
            else
                
                lg.setColor(0.4, 0.4, 0.4)
            end

            lg.rectangle("fill", self.x + 5, itemY, self.width - 10, 14)
            lg.setColor(1, 1, 1)
            lg.print(prop.name or "Unnamed", self.x + 8, itemY + 2)
        end
    end
end

function selection:drawModals()

    if self.modalBox then
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

        -- Close Button
        closeButton:draw()
    end
end

function selection:mousepressed(x, y, button)

    if self.modalBox then

        closeButton:mousepressed(x, y, button)

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
