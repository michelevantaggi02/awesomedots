local help = {}
local beautiful = require("beautiful")

help.rrect = function(rad)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, rad)
  end
end

help.prrect = function(radius, tl, tr, br, bl)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(
      cr,
      width,
      height,
      tl,
      tr,
      br,
      bl,
      radius
    )
  end
end

help.fg = function(text, color, thickness)
  color = color or "red"
  return "<span foreground='" .. color .. "' font-weight='" .. thickness .. "'>" .. text .. "</span>"
end

help.merge = function(first_table, second_table)
  for k, v in pairs(second_table) do first_table[k] = v end
end

help.write_to_file = function(path, content)
  local activethemefile = io.open(path, "w")
  if not activethemefile then
    return
  end
  activethemefile:write(content .. '\n')
  activethemefile:close()
end

help.call_wal = function ()
  awful.spawn.easy_async_with_shell("wal -i "..beautiful.theme_dir .. beautiful.activetheme .. "/wallpapers/ -n && betterlockscreen -u \"$(< \"${HOME}/.cache/wal/wal\")\"")
end

help.randomize_wallpaper = function()
  awful.spawn.easy_async_with_shell("wal -i "..beautiful.theme_dir .. beautiful.activetheme .. "/wallpapers/ -n && feh --bg-fill \"$(< \"${HOME}/.cache/wal/wal\")\"  ", function ()
  awesome.restart()
    
  end)


  
 -- awful.spawn.easy_async_with_shell("feh --bg-fill --randomize " ..
  --  beautiful.theme_dir .. beautiful.activetheme .. "/wallpapers/*")
end

help.screenshot = function()
  awful.spawn.easy_async_with_shell("scrot -s -l mode=edge -e 'xclip -selection clipboard -t image/png -i $f' /home/" ..
    os.getenv('USER') .. "/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H.%M.%S.png")
end

return help
