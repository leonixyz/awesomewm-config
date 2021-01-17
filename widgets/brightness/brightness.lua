local wibox = require("wibox")
local watch = require("awful.widget.watch")

local THEME = "white"
local HOME = os.getenv("HOME")
local ICON = HOME .. "/.config/awesome/widgets/brightness/icons/brightness-" .. THEME .. ".svg"
local GET_BRIGHTNESS_CMD = "xbacklight -get"

local brightness_widget = wibox.widget {
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    {   -- brightness icon
        id = "icon",
        image = ICON,
        resize = true,
        widget = wibox.widget.imagebox,
    },
    {   -- brightness percentage value
        id = "text",
        widget = wibox.widget.textbox,
    },
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    layout = wibox.layout.fixed.horizontal,
}

watch(
    GET_BRIGHTNESS_CMD, 1,
    function(widget, stdout, stderr, exitreason, exitcode)
        local brightness_level = tonumber(string.format("%.0f", stdout))
        widget.text:set_text(brightness_level .. "%")
    end,
    brightness_widget
)

return brightness_widget
