local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")

local HOME_DIR = os.getenv("HOME")
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/temperature-humidity/'
local ICONS_DIR = WIDGET_DIR .. 'icons/'
local THEME = 'white'

local temperature_humidity_widget = wibox.widget {
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    {
        image = ICONS_DIR .. 'temperature-' .. THEME .. '.svg',
        widget = wibox.widget.imagebox
    },
    {
        id = 'temperature',
        widget = wibox.widget.textbox
    },
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    {
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
        image =  ICONS_DIR .. 'humidity-' .. THEME .. '.svg',
        widget = wibox.widget.imagebox
    },
    {
        id = 'humidity',
        widget = wibox.widget.textbox
    },
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    layout = wibox.layout.fixed.horizontal,
}

local function update_widget(widget, stdout)
    local temperature = stdout:match("\"temperature\": ?([0-9]+)")
    local humidity = stdout:match("\"humidity\": ?([0-9]+)")
    temperature_humidity_widget.temperature:set_text(temperature .. '°C')
    temperature_humidity_widget.humidity:set_text(humidity .. '%')
end

watch([[curl http://192.168.0.147]],
        60, update_widget, temperature_humidity_widget)

return temperature_humidity_widget
