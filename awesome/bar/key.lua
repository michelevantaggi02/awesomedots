local keyboardlayout = awful.widget.keyboardlayout()


local layouts = { "it", "us" }
local current_layout = 1  -- us is default

keyboardlayout.switch = function()
    current_layout = current_layout % #layouts + 1
    os.execute("setxkbmap " .. layouts[current_layout])
end

keyboardlayout:buttons(awful.util.table.join(
  awful.button({}, 1, function()
    keyboardlayout.switch()
  end)
))

return keyboardlayout