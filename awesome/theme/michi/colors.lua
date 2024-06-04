local colors = {}
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()

colors.ok = "#00c746"
colors.err = "#c70000"
colors.pri = xrdb.color10 -- "#00c785"
colors.bg = xrdb.color0-- "#191919"
colors.bg2 = xrdb.color0 .. "ee" --"#131313"
colors.bg3 = xrdb.color0 .. "dd"--"#070707"
colors.fg = xrdb.color6 -- "#c7c7c7"
colors.fg2 = xrdb.color6 .. "aa" --"#4a4a4a"

return colors
