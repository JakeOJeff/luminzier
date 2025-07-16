lg = love.graphics
local width, height = love.window.getDesktopDimensions()
love.window.setMode(width, height, {
    fullscreen = false,
    resizable = false,  
    borderless = false, 
    vsync = true
})
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