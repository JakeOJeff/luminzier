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
function objects:load()

end

function objects:update(dt)

end

function objects:getCurrentChild()
    print(self.clickedChild.name)
    return self.clickedChild
end

function objects:draw()
    -- Objects Box
    lg.setColor(0.3, 0.3, 0.3)
    lg.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)
    mx, my = love.mouse.getPosition()

    y = self.y
    for i = 1, #self.children do
        local itemY = y + (16 * i)
        if mx > self.x + 5 and mx < self.x + self.width - 10 and my > itemY and my < itemY + 14 then
            lg.setColor(0.5, 0.5, 0.5)
            if love.mouse.isDown(1) then
                self.clickedChild = self.children[i]
            end
        else
            lg.setColor(0.4, 0.4, 0.4)
        end

        objChild = self.children[i]
        lg.rectangle("fill", self.x + 5, y + (16 * i), self.width - 10, 14)
        lg.setColor(1, 1, 1)
        lg.print(objChild.name, self.x + 8, y + (16 * i) + 2)
    end

end

return objects
