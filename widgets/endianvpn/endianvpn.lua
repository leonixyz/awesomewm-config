local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")

local THEME = "white"
local HOME = os.getenv("HOME")
local ICON = HOME .. "/.config/awesome/widgets/endianvpn/icons/endian-" .. THEME .. ".svg"

local endianvpn_widget = wibox.widget {
    {
        id = "content",
        {   -- separator
            markup = " ",
            widget = wibox.widget.textbox,
        },
        {   -- endian icon
            id = "icon",
            widget = wibox.widget.imagebox,
            image = ICON,
            resize = true,
        },
        {   -- vpn status
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

watch('endianvpnctl status', 10,
    function(widget, stdout, stderr, exitreason, exitcode)
        if stdout == 'active\n' then
            widget.active = true
            widget.content.text:set_text('on')
        elseif stdout == 'inactive\n' then
            widget.active = false
            widget.content.text:set_text('off')
        else
            widget.active = false
            widget.content.text:set_text('err')
        end
    end,
    endianvpn_widget 
)

local notification
local function set_status(status)
    awful.spawn.easy_async('endianvpnctl ' .. status,
        function(stdout, _, _, _)
            notification = naughty.notify{
                text =  "Turning " .. status .. " the VPN ",
                title = "Endian VPN",
                timeout = 5, hover_timeout = 0.5,
                width = 250,
            }
        end
    )
end

endianvpn_widget:buttons(
    awful.util.table.join(
        awful.button({}, 1, function()
            endianvpn_widget.content.text:set_text('♻')
            if endianvpn_widget.active then
                set_status('off')
            else
                set_status('on')
            end
        end)
    )
)

return endianvpn_widget 
