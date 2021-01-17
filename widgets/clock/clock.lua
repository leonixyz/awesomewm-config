local wibox = require("wibox")

local THEME = "white"
local HOME = os.getenv("HOME")
local ICON = HOME .. "/.config/awesome/widgets/clock/icons/clock-" .. THEME .. ".svg"

local clock_widget = wibox.widget {
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    {   -- clock icon
        id = "icon",
        image = ICON,
        resize = true,
        widget = wibox.widget.imagebox,
    },
    {   -- time
        id = "text",
        widget = wibox.widget.textclock("%H:%M")
    },
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    layout = wibox.layout.fixed.horizontal,
}

return clock_widget 
