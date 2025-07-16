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
        height = window.h
    }
}

function love.load()

end

function love.update(dt)

end

function love.draw()
    -- Left Task Bar
    local gV = GLOBAL_VARS
    local lTB = gV.leftTaskBar

    lg.setColor(0.7,0.7,0.7)
    lg.rectangle("fill", lTB.x, lTB.y, lTB.width, lTB.height)
end
