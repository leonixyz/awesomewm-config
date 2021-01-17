local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local THEME = "white"
local HOME = os.getenv("HOME")
local PATH_TO_ICONS = HOME .. "/.config/awesome/widgets/memory/icons/"

--- Main widget shown on wibar
local memory_widget = wibox.widget {
    {
        id = "content",
        {   -- separator
            markup = " ",
            widget = wibox.widget.textbox,
        },
        {   -- memory icon
            id = "icon",
            widget = wibox.widget.imagebox,
            image = PATH_TO_ICONS .. "memory-" .. THEME .. ".svg",
            resize = true,
        },
        {   -- memory percentage
            id = "text",
            widget = wibox.widget.textbox,
        },
        {   -- separator
            markup = " ",
            widget = wibox.widget.textbox,
        },
        layout  = wibox.layout.fixed.horizontal,
    },
    layout = wibox.container.margin(_, 0, 0, 3)
}

--- Widget which is shown when user clicks on the main widget
local w = wibox {
    height = 400,
    width = 800,
    ontop = true,
    screen = mouse.screen,
    expand = true,
    bg = '#1e252c',
    max_widget_size = 500
}

w:setup {
    border_width = 0,
    colors = {
        '#5ea19d',
        '#55918e',
        '#4b817e',
    },
    display_labels = false,
    forced_width = 40,
    id = 'pie',
    widget = wibox.widget.piechart
}

local total, used, free, shared, buff_cache, available

local function getPercentage(value)
    return math.floor(value / total * 100 + 0.5) .. '%'
end

local function updatePieChart()
    w.pie.data_list = {
        {'used ' .. getPercentage(used), used},
        {'free ' .. getPercentage(free), free},
        {'buff_cache ' .. getPercentage(buff_cache), buff_cache}
    }
end

watch('bash -c "free | grep Mem"', 5,
    function(widget, stdout, stderr, exitreason, exitcode)
        total, used, free, shared, buff_cache, available = stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)')
        
        local non_available = total - available
        widget.content.text:set_text(getPercentage(non_available))
        
        local imageType = THEME
        if non_available / total * 100 > 80 then
            imageType = "critical"
        end
        widget.content.icon:set_image(PATH_TO_ICONS .. "memory-" .. imageType .. ".svg")
        
        if w.visible then
            updatePieChart()
        end
    end,
    memory_widget 
)

memory_widget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function()
            awful.placement.top_right(w, { margins = {top = 25, right = 0}})
            w.pie.display_labels = true
            updatePieChart()
            w.visible = not w.visible
        end)
    )
)

return memory_widget 
