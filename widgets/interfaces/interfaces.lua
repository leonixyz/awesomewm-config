local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local THEME = "white"
local HOME = os.getenv("HOME")
local ICON = HOME .. "/.config/awesome/widgets/interfaces/icons/wifi-" .. THEME .. ".svg"

local interface_widget = wibox.widget {
    {
        id = "content",
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
        {   -- ip address
            id = "text",
            markup = "none",
            widget = wibox.widget.textbox,
        },
        {   -- separator
            widget = wibox.widget.textbox,
            markup = " "
        },
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.container.margin(_, 0, 0, 3)
}

local notification
local function show_interface_status()
    awful.spawn.easy_async([[ip address]],
        function(stdout, _, _, _)
            notification = naughty.notify{
                text =  stdout,
                title = "Network interfaces",
                timeout = 5, hover_timeout = 0.5,
                width = 1000,
            }
        end
    )
end

local function worker(user_args)
    
    local args = user_args or {}
    local int_type = args.int_type or "ethernet"
    local ipv6 = args.ipv6
    local timeout = args.timeout or 5
    local interface = args.name

    if interface == nil then return end

    watch("ip address show " .. interface, timeout,
        function(widget, stdout, stderr, exitreason, exitcode)
            if ipv6 then
                ip = stdout:match("inet6 ([^ ]+) ")
            else
                ip = stdout:match("inet ([^ ]+) ")
                --ip = stdout:match("inet (%d+%.%d+%.%d+%.%d+/%d+)")
            end
            widget.content.text:set_markup(ip)
        end,
        interface_widget)

    interface_widget:connect_signal("mouse::enter", function() show_interface_status() end)
    interface_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

    return interface_widget
end

return setmetatable(interface_widget, { __call = function(_, ...) return worker(...) end })
