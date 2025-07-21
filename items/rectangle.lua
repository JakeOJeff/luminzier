local rectangle = {
    type = "Rectangle",
    name = "Rectangle",
    properties = {
        { name = "x", value = 0, type = "num" },
        { name = "y", value = 0, type = "num" },
        { name = "width", value = 50, type = "num" },
        { name = "height", value = 50, type = "num" },
        { name = "rx", value = 0, type = "num" },
        { name = "mode", value = "fill", type = "string" },
        { name = "color", value = {0.5, 0.5, 0.5}, type = "color" }
    }
}

return rectangle
