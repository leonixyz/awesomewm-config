local awful = require("awful")
local wibox = require("wibox")

local THEME = "white"
local HOME = os.getenv("HOME")
local ICON = HOME .. "/.config/awesome/widgets/calendar/icons/calendar-" .. THEME .. ".svg"
local TODAY_FG_COLOR = '#000000'
local TODAY_BG_COLOR = '#ffffff'

--- Main widget shown on wibar
local calendar_widget = wibox.widget {
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    {   -- calendar icon
        id = "icon",
        image = ICON,
        resize = true,
        widget = wibox.widget.imagebox,
    },
    {   -- date 
        id = "text",
        widget = wibox.widget.textclock("%d/%m/%Y")
    },
    {   -- separator
        widget = wibox.widget.textbox,
        markup = " "
    },
    layout = wibox.layout.fixed.horizontal,
}

local function decorate_cell(widget, flag, _)
    -- return a different widget only if we are on focus
    if flag ~= "focus" then
        return widget
    end
    
    return wibox.widget {
        widget,
        fg = TODAY_FG_COLOR,
        bg = TODAY_BG_COLOR,
        widget = wibox.container.background
    }
end

--- Widget which is shown when user clicks on the main widget
local w = wibox {
    height = 250,
    width = 250,
    ontop = true,
    screen = mouse.screen,
    max_widget_size = 500
}

w:setup {
    id = 'calendar',
    date = os.date('*t'),
    week_numbers = false,
    start_sunday = false,
    fn_embed = decorate_cell,
    widget = wibox.widget.calendar.month
}

calendar_widget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function()
            awful.placement.top_right(w, { margins = {top = 27, right = 0}})
            w.visible = not w.visible
        end)
    )
)

return calendar_widget
