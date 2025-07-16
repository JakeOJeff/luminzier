local class = require 'packages.middleclass'
local tween = require 'packages.tween'

local Button = class('Button')

function Button:initialize(x, y, width, height, text, callback, color, rounded, hover,
                           duration, fontName)
    self.x = x or 10
    self.y = y or 10
    self.width = width or 50
    self.height = height or 20
    self.rounded = rounded or 10
    self.text = text or "Button"
    self.color = color or {1, 1, 1}
    self.font = fontName or lg.getFont()

    self.callback = callback or function() end
    hover = hover or {}
    self.state = {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
        rounded = self.rounded,
        color = {unpack(self.color)}
    }
    self.normal = self.state
    self.hover = {
        x = hover.x or self.x,
        y = hover.y or self.y,
        width = hover.width or self.width,
        height = hover.height or self.height,
        rounded = hover.rounded or self.rounded,
        color = {unpack(hover.color or self.color)}
    }

    self.duration = duration or 0.06

    return self
end
function Button:recall()

    self.font = self.font or hfont
    self.state = {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
        rounded = self.rounded,
        color = {unpack(self.color)}
    }
    self.normal = {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
        rounded = self.rounded,
        color = {unpack(self.color)}
    }
    self.hover = self.hover or {}
    self.hover = {
        x = self.hover.x or self.x,
        y = self.hover.y or self.y,
        width = self.hover.width or self.width,
        height = self.hover.height or self.height,
        rounded = self.hover.rounded or self.rounded,
        color = {unpack(self.hover.color or self.color)}
    }
end
function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.width and my > self.y and my < self.y +
        self.height then
        self.tweenHover = tween.new(self.duration, self.state, self.hover)
        self.tweenHover:update(dt)

    else

        self.tweenReset = tween.new(self.duration, self.state, self.normal)
        self.tweenReset:update(dt)
    end

    --self:recall()
end

function Button:mousepressed(x, y, button)
    if button == 1 then
        if x >= self.x and x <= self.x + self.width and y >= self.y and y <=
            self.y + self.height then self.callback() end
    end
end

function Button:draw()
    local r, g, b = unpack(self.state.color)

    -- Calculate shadow color (darker)
    local shadowColor = {r * 0.6, g * 0.6, b * 0.6, 0.2}
    -- Calculate border color (lighter)
    local borderColor = {
        math.min(r + 0.2, 1),
        math.min(g + 0.2, 1),
        math.min(b + 0.2, 1),
        0.5
    }

    -- Draw shadow (offset by 3 pixels)
    
    love.graphics.setColor(shadowColor)
    love.graphics.rectangle("fill", self.state.x , self.state.y + 4,
                            self.state.width, self.state.height, self.state.rounded, self.state.rounded)

    -- Draw main button
    love.graphics.setColor(self.state.color)
    love.graphics.rectangle("fill", self.state.x, self.state.y,
                            self.state.width, self.state.height, self.state.rounded, self.state.rounded)

    -- Draw border
    love.graphics.setColor(borderColor)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.state.x, self.state.y,
                            self.state.width, self.state.height, self.state.rounded, self.state.rounded)

    -- Draw button text
    love.graphics.setFont(self.font)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.text,
        self.state.x + self.state.width/2 - self.font:getWidth(self.text)/2,
        self.state.y + self.state.height/2 - self.font:getHeight()/2)

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

return Button