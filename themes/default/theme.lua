---------------------------
-- Default awesome theme --
---------------------------

local wibox = require("wibox")
local systray = wibox.widget.systray()

theme_name          = "default"
theme_dir           = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name

theme = {}

color_primary       = "#2f2f2f"
color_secondary     = "#000000"
color_urgent        = "#a30000"
color_fg_primary    = "#E0E0E0"
color_fg_secondary  = "#F5F5F5"
color_border_normal = "#181818"

theme.font          = "sans 10"
theme.taglist_font  = "sans 12"

theme.bg_normal     = color_secondary
theme.bg_focus      = color_primary
theme.bg_urgent     = color_urgent
theme.bg_minimize   = color_secondary
theme.bg_systray    = color_secondary
theme.fg_normal     = color_fg_primary
theme.fg_focus      = color_fg_secondary
theme.fg_urgent     = color_fg_secondary
theme.fg_minimize   = color_fg_secondary
theme.border_normal = color_border_normal
theme.border_focus  = color_primary
theme.border_width  = 1

theme.systray_icon_spacing = 2
systray:set_base_size(18)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme_dir .. "/icons/square_unsel.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

theme.menu_submenu_icon = theme_dir .. "/icons/submenu.png"
theme.menu_font         = "sans 12"
theme.menu_height       = 30
theme.menu_width        = 300
theme.menu_border_color = color_secondary
theme.menu_border_width = 1 
theme.menu_fg_focus     = color_fg_secondary
theme.menu_bg_focus     = color_secondary
theme.menu_fg_normal    = color_fg_primary
theme.menu_bg_normal    = color_primary
theme.wallpaper         = theme_dir .. "/cheat-black.png"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua

-- Layout icons
theme.layout_tile       = theme_dir .. "/icons/tile.png"
theme.layout_tilegaps   = theme_dir .. "/icons/tilegaps.png"
theme.layout_tileleft   = theme_dir .. "/icons/tileleft.png"
theme.layout_tilebottom = theme_dir .. "/icons/tilebottom.png"
theme.layout_tiletop    = theme_dir .. "/icons/tiletop.png"
theme.layout_fairv      = theme_dir .. "/icons/fairv.png"
theme.layout_fairh      = theme_dir .. "/icons/fairh.png"
theme.layout_spiral     = theme_dir .. "/icons/spiral.png"
theme.layout_dwindle    = theme_dir .. "/icons/dwindle.png"
theme.layout_max        = theme_dir .. "/icons/max.png"
theme.layout_fullscreen = theme_dir .. "/icons/fullscreen.png"
theme.layout_magnifier  = theme_dir .. "/icons/magnifier.png"
theme.layout_floating   = theme_dir .. "/icons/floating.png"
theme.layout_cornernw   = theme_dir .. "/icons/cornernw.png"

-- Various icons
theme.cpuicon      = theme_dir .. "/icons/cpu.png"
theme.clockicon    = theme_dir .. "/icons/clock.png"
theme.memicon      = theme_dir .. "/icons/mem.png"
theme.fsicon       = theme_dir .. "/icons/fs.png"
theme.volicon      = theme_dir .. "/icons/spkr.png"
theme.thermicon    = theme_dir .. "/icons/temp.png"
theme.baticon      = theme_dir .. "/icons/bat_full.png"
theme.shellicon    = theme_dir .. "/icons/shell.png"
theme.noteicon     = theme_dir .. "/icons/note.png"
theme.arch_icon    = theme_dir .. "/icons/arch.png"
theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
