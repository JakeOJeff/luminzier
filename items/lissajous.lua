local lissajous = {
    type = "Pattern",
    name = "Lissajous",
    particles = {},
    properties = {
        { name = "x", value = 0, type = "num" },
        { name = "y", value = 0, type = "num" },
        { name = "a", value = 2.5, type = "num" },
        { name = "b", value = 2.5, type = "num" },
        { name = "delta", value = 0, type = "num" },
        { name = "radius", value = 100, type = "num" },
        { name = "particles", value = 200, type = "num"}
    }
}
return lissajous
