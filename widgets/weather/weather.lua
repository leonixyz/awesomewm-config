local wibox = require("wibox")
local awful = require("awful")
local watch = require("awful.widget.watch")
local naughty = require("naughty")
local json = require("json")
local os = require("os")

local HOME_DIR = os.getenv("HOME")
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/weather/'
local ICONS_DIR = WIDGET_DIR .. 'icons/'
local API_URL = "https://tourism.opendatahub.bz.it/api/Weather?language=en"
local CITY_ID = 2
--[[
--  1: Silandro
--  2: Merano
--  3: Bolzano
--  4: Vipiteno
--  5: Bressanone
--  6: Brunico
--]]

local data = {}

local weather_widget = wibox.widget {
    {
        id = "icon1",
        widget = wibox.widget.imagebox,
    },
    {
        id = "icon2",
        widget = wibox.widget.imagebox,
    },
    {
        id = "icon3",
        widget = wibox.widget.imagebox,
    },
    {
        id = "icon4",
        widget = wibox.widget.imagebox,
    },
    {
        id = "icon5",
        widget = wibox.widget.imagebox,
    },
    {
        id = "icon6",
        widget = wibox.widget.imagebox,
    },
    {
        id = "icon7",
        widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.horizontal,
}

table.filter = function(t, filterIter)
  local out = {}

  for k, v in pairs(t) do
    if filterIter(v, k, t) then table.insert(out, v) end
  end

  return out
end

watch(string.format([[curl %s -H "accept: application/json"]], API_URL), 3600,
    function(widget, stdout, stderr, exitreason, exitcode)
        local response = json.decode(stdout)
        -- today and tomorrow forecast
        local days = table.filter(response.Stationdata, function(v) return v.Id == CITY_ID end)
        -- further days forecast
        for k, v in pairs(response.Forecast) do table.insert(days, v) end
        -- refine data
        for k, v in pairs(days) do
            local code = v.WeatherCode and v.WeatherCode or v.Weathercode
            local desc = v.WeatherDesc and v.WeatherDesc or v.Weatherdesc
            local min = v.MinTemp and v.MinTemp or (v.TempMinmin + v.TempMinmax) / 2
            local max = v.MaxTemp and v.MaxTemp or (v.TempMaxmin + v.TempMaxmax) / 2
            local year, month, day = v.date:match('(%d+)-(%d+)-(%d+)T')
            local date = os.date('%a %d/%m/%Y', os.time({year = year, month = month, day = day}))
            table.insert(data, {
                code = code,
                desc = desc,
                date = date,
                min = min,
                max = max
            })
        end
        -- set icons
        for k, v in pairs(data) do
            widget['icon' .. k]:set_image(ICONS_DIR .. v.code .. '.png')
        end
    end,
    weather_widget
)

--- Widget which is shown when user clicks on the main widget
local w = wibox {
    height = 420,
    width = 330,
    ontop = true,
    screen = mouse.screen,
    max_widget_size = 500,
    bg = '#1e252c',
}


weather_widget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function()
            awful.placement.top_right(w, { margins = {top = 25, right = 0}})

            local rows = {
                layout = wibox.layout.fixed.vertical,
            }

            for k, v in pairs(data) do
                local l = wibox.widget {
                    homogeneous   = true,
                    expand        = true,
                    layout        = wibox.layout.grid,
                }

                l:add_widget_at(wibox.widget {
                    image  = ICONS_DIR .. v.code .. '.png',
                    forced_width = 10,
                    forced_height = 10,
                    resize = true,
                    widget = wibox.widget.imagebox
                },                                                                          1, 1, 3, 1)
                l:add_widget_at(wibox.widget.textbox(string.format("<b>%s</b>", v.date)),   1, 2, 1, 2)
                l:add_widget_at(wibox.widget.textbox(string.format("Min: %2.1f°C", v.min)), 2, 2, 1, 1)
                l:add_widget_at(wibox.widget.textbox(string.format("Max: %2.1f°C", v.max)), 2, 3, 1, 1)
                l:add_widget_at(wibox.widget.textbox(v.desc),                               3, 2, 1, 2)
                l:insert_row(1)
                table.insert(rows, l)
            end

            w:setup {
                layout = wibox.container.margin,
                left = 20,
                {
                    layout = wibox.layout.fixed.vertical,
                    rows
                }
            }

            w:geometry({width = 330, height = #rows * 70})

            w.visible = not w.visible
        end)
    )
)

return weather_widget
