local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local THEME = "white"
local HOME = os.getenv("HOME")
local PATH_TO_ICONS = HOME .. "/.config/awesome/widgets/battery/icons/" .. THEME .. "/"


local battery_widget = wibox.widget {
    {
        id = "content",
        {   -- separator
            markup = " ",
            widget = wibox.widget.textbox,
        },
        {   -- battery icon
            id = "icon",
            widget = wibox.widget.imagebox,
            resize = true,
        },
        {   -- battery percentage
            id = "text",
            widget = wibox.widget.textbox,
        },
        {   -- separator
            markup = " ",
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.container.margin(_, 0, 0, 3)
}

-- Popup with battery info
-- One way of creating a pop-up notification - naughty.notify
local notification
local function show_battery_status()
    awful.spawn.easy_async([[bash -c 'acpi']],
        function(stdout, _, _, _)
            notification = naughty.notify{
                text =  stdout,
                title = "Battery status",
                timeout = 5, hover_timeout = 0.5,
                width = 200,
            }
        end
    )
end

local function show_battery_warning()
    naughty.notify{
        icon = PATH_TO_ICONS .. "../warning.png",
        icon_size=100,
        text = "Huston, we have a problem",
        title = "Battery is dying",
        timeout = 5, hover_timeout = 0.5,
        position = "top_right",
        bg = "#F06060",
        fg = "#EEE9EF",
        width = 300,
    }
end

watch("acpi", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
        local iconType
        local _, status, charge_str, time = string.match(stdout, '(.+): (%a+), (%d?%d?%d)%%,? ?.*')
        local charge = tonumber(charge_str)
        if (charge >= 0 and charge < 5) then
            iconType = "battery-critical"
            if status ~= 'Charging' then
                show_battery_warning()
            end
        elseif (charge >= 5 and charge < 30) then iconType = "battery-00"
        elseif (charge >= 30 and charge < 80) then iconType = "battery-66"
        elseif (charge >= 80 and charge <= 100) then iconType = "battery-100"
        end
        if status == 'Charging' then
            charge_str = "⚡" .. charge_str
        end
        widget.content.icon:set_image(PATH_TO_ICONS .. iconType .. ".svg")
        widget.content.text:set_text(charge_str .. "%")
    end,
    battery_widget)

battery_widget:connect_signal("mouse::enter", function() show_battery_status() end)
battery_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

return battery_widget
