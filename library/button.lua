local class = require 'packages.middleclass'
local class = require 'packages.middleclass'

local Button = class('Button')

function Button:initialize(x, y, width, height, text, callback, color, rounded, hover, duration, fontName)

    self.x = x or 10
    self.y = y or 10
    self.width = width or 50
    self.height = height or 20
    self.rounded = rounded or 10
    self.text = text or "Button"
    self.color = color or {1,1,1}
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

    self.font = self.font or love.graphics.getFont()
    self.state = {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
        rounded = self.rounded,
        color = {unpack(self.color)}
    }

    self.noraml = {
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
        color = {unpacked(self.hover.color or self.color)}
    }
end

function Button:update(dt)

    mx, my = love.mouse.getPosition()

    if mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height then
        self.tweenHover = tween.new(self.duration, self.state, self.hover)
        self.tweenHover:update(dt)
    else
        self.tweenReset = tween.new(self.duration, self.state, self.normal)
        self.tweenReset:update(dt)
    end
end

