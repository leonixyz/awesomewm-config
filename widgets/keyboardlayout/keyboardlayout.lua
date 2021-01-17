local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local THEME = "white"
local HOME = os.getenv("HOME")
local ICON = HOME .. "/.config/awesome/widgets/keyboardlayout/icons/keyboardlayout-" .. THEME .. ".svg"

local layout = {
    selected = 0,
    available = { 'us', 'it', 'de' }
}

local keyboardlayout_widget = wibox.widget {
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    {   -- keyboard layout icon
        id = "icon",
        image = ICON,
        resize = true,
        widget = wibox.widget.imagebox,
    },
    {   -- keyboard layout value
        id = "text",
        widget = awful.widget.keyboardlayout()
    },
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    layout = wibox.layout.fixed.horizontal,
}

keyboardlayout_widget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function()
            layout.selected = layout.selected + 1
            layout.selected = layout.selected % #layout.available + 1
            cmd = 'setxkbmap ' .. layout.available[layout.selected]

            awful.spawn.easy_async(cmd, function(_, _, _, _)
            end)
        end)
    )
)

return keyboardlayout_widget
