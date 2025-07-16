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


end