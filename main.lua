lg = love.graphics


window = {
    w = lg:getWidth(),
    h = lg:getHeight()
}
GLOBAL_VARS = {
    leftTaskBar = {
        x = 0,
        y = 0,
        width = 0.25 * window.w,
        height = window.h,
        enabled = true
    },
    canvas = {
        color = {1,1,1},
        x = 0,
        y = 0,
        width = 0.75 * window.w - 20, -- To get 75% and trim 10 px from each side 
        height = window.h - 20 
    }
}

GLOBAL_VARS.canvas.x = GLOBAL_VARS.leftTaskBar.x + GLOBAL_VARS.leftTaskBar.width + 10
GLOBAL_VARS.canvas.y = 10

function love.load()

    

end

function love.update(dt)



end

function love.draw()
    lg.setBackgroundColor(.2,.2,.2)
    -- Left Task Bar
    local gV = GLOBAL_VARS
    local lTB = gV.leftTaskBar
    local cv = gV.canvas
    
    lg.setColor(0.5,0.5,0.5)
    lg.rectangle("fill", lTB.x, lTB.y, lTB.width, lTB.height)

    lg.setColor(cv.color)
    lg.rectangle("fill", cv.x, cv.y, cv.width, cv.height, 10, 10)
end
