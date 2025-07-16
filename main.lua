lg = love.graphics


-- Snap to (0,0) so it fills the top-left corner
love.window.setPosition(0, 0)
window = {
    w = lg:getWidth(),
    h = lg:getHeight()
}
GLOBAL_VARS = {
    leftTaskBar = {
        x = 0,
        y = 0,
        width = 50,
        height = window.h
    }
}

function love.load()

end

function love.update(dt)

end

function love.draw()
    -- Left Task Bar
end
