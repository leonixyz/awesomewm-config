local watch = require("awful.widget.watch")
local wibox = require("wibox")

local THEME = "white"
local HOME = os.getenv("HOME")
local ICON = HOME .. "/.config/awesome/widgets/cpu/icons/cpu-" .. THEME .. ".svg"
local ICON_ALERT = HOME .. "/.config/awesome/widgets/cpu/icons/cpu-critical.svg"

local cpugraph_widget = wibox.widget {
    max_value = 100,
    color = '#ffffff',
    background_color = "#00000000",
    forced_width = 50,
    step_width = 2,
    step_spacing = 1,
    widget = wibox.widget.graph
}

local cpu_widget = wibox.widget {
    {
        id = "content",
        {   -- separator
            markup = " ",
            widget = wibox.widget.textbox,
        },
        {   -- cpu icon
            id = "icon",
            widget = wibox.widget.imagebox,
            image = ICON,
            resize = true,
        },
        wibox.container.margin(wibox.container.mirror(cpugraph_widget, { horizontal = true }), 0, 0, 0, 2),
        {   -- separator
            markup = " ",
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.fixed.horizontal,
    },
    --layout = wibox.container.margin(_, 0, 0, 3)
    layout = wibox.layout.fixed.horizontal,
}

local total_prev = 0
local idle_prev = 0

watch("cat /proc/stat | grep '^cpu '", 1,
    function(widget, stdout, stderr, exitreason, exitcode)
        local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
        stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

        local total = user + nice + system + idle + iowait + irq + softirq + steal

        local diff_idle = idle - idle_prev
        local diff_total = total - total_prev
        local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

        if diff_usage > 80 then
            widget:set_color('#ff4136')
            cpu_widget.content.icon:set_image(ICON_ALERT)
        else
            widget:set_color('#ffffff')
            cpu_widget.content.icon:set_image(ICON)
        end

        widget:add_value(diff_usage)

        total_prev = total
        idle_prev = idle
    end,
    cpugraph_widget
)

return cpu_widget
