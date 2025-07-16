local selection = {
    x = 5,
    y = GLOBAL_VARS.leftTaskBar.height/3 * 2,
    width = GLOBAL_VARS.leftTaskBar.width - 10,
    height = GLOBAL_VARS.leftTaskBar.height/3 - 5,
    modalBox = true,
    modalBoxData = {
        x =  GLOBAL_VARS.leftTaskBar.x + 35 + GLOBAL_VARS.canvas.width/2,
        y = 10 + GLOBAL_VARS.canvas.height/2  - 100,
        width = 400,
        height = 200
    },
    dragPosition = {
        x = 0,
        y = 0
    },
    modalBoxDragging = false,
    properties = {},
    selectedProperty = {
        name = "name",
        value = 0,
        type = "num"
    }
}


function selection:load()


end


function selection:update(dt)

    if love.mouse.isDown(1) and self.modalBoxDragging then
        print("WHOOP WHOOP")
        mx, my = love.mouse.getPosition()

        self.modalBoxData.x = mx - self.dragPosition.x
        self.modalBoxData.y = my - self.dragPosition.y
    end

end

function selection:draw()

    -- Properties Box
    lg.setColor(0.3,0.3,0.3)
    lg.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)

    for i,v in pairs(self.properties) do
        
    end



end

function selection:drawModals()

    if self.modalBox then
        lg.setColor(0,0,0,.5)
        lg.rectangle("fill", 0,0, window.w, window.h)

        lg.setColor(0.3, 0.3, 0.3)
        lg.rectangle("fill",self.modalBoxData.x , self.modalBoxData.y,  self.modalBoxData.width,  self.modalBoxData.height, 20, 20)
    
        lg.setColor(0.2, 0.2, 0.2)
        lg.rectangle("fill",self.modalBoxData.x , self.modalBoxData.y,  self.modalBoxData.width, self.modalBoxData.height/5, 20, 20)
    
        lg.setColor(1, 1, 1)
        lg.print(self.selectedProperty.name,self.modalBoxData.x + 20, self.modalBoxData.y + 20)
    end
end

function selection:mousepressed(x, y, button)

    if x > self.modalBoxData.x and x < self.modalBoxData.x + self.modalBoxData.width and y > self.modalBoxData.y and y < self.modalBoxData.y + self.modalBoxData.height/5 and self.modalBox then
        if button == 1 then
            self.modalBoxDragging = true
            self.dragPosition.x = x - self.modalBoxData.x
            self.dragPosition.y = y - self.modalBoxData.y
            print("ENTERED")
        end
    end

end

function selection:mousereleased(x, y, button)

    if self.modalBoxDragging then
        self.modalBoxDragging = false
                    print("exited")
    end
end
return selection