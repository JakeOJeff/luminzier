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

-- GLOBAL FUNCS
function unpackProperties(propList)
    local props = {}
    for _, prop in ipairs(propList) do
        props[prop.name] = prop.value
    end
    return props
end
function inBox(mx, my, x, y, width, height)
    if mx > x and mx < x + width and my > y and my < y + height then
        return true
    end
    return false

end

function inCircle(mx, my, x, y, radius)
    local dist = math.sqrt( (y - my)^2 + (x - mx)^2 )

    if dist < radius then
        return true
    end

    return false
end
-- Libs
Button = require 'library.button'


objects = require 'classes.objects'
selection = require 'classes.selection'


drawElements = require 'classes.drawElements'

function love.load()
    selection:load()
    objects:load()

 
end

function love.update(dt)
    selection:update(dt)
    objects:update(dt)

end

function love.draw()
    lg.setBackgroundColor(.2,.2,.2)
    -- Left Task Bar
    local gV = GLOBAL_VARS
    local lTB = gV.leftTaskBar
    local cv = gV.canvas
    
    lg.setColor(0.5,0.5,0.5)
    lg.rectangle("fill", lTB.x, lTB.y, lTB.width, lTB.height)


    objects:draw()

    
    selection:draw()

    lg.setColor(cv.color)
    lg.rectangle("fill", cv.x, cv.y, cv.width, cv.height, 10, 10)

    drawElements:allDraw()

    selection:drawModals()
    objects:drawAddItemModal()
end


function love.mousepressed(x, y, button)
    selection:mousepressed(x, y, button)
    objects:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    selection:mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    objects:wheelmoved(x, y)
end