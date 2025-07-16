local selection = {
    x = 5,
    y = GLOBAL_VARS.leftTaskBar.height/3 * 2,
    width = GLOBAL_VARS.leftTaskBar.width - 10,
    height = GLOBAL_VARS.leftTaskBar.height/3 - 5
}


function selection:load()


end


function selection:update(dt)


end

function selection:draw()

    -- Properties Box
    lg.setColor(0.3,0.3,0.3)
    lg.rectangle("fill", self.x, self.y, self.width, self.height, 10, 10)

end

return selection