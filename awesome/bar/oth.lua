local M = {}

-- Separator
M.sep = wibox.widget {
  {
    forced_width = dpi(2),
    shape = gears.shape.line,
    widget = wibox.widget.separator
  },
  top = dpi(5),
  left = dpi(15),
  right = dpi(15),
  bottom = dpi(5),
  widget = wibox.container.margin
}

M.launch = wibox.widget {
  {
    markup = "\u{f17c}",
    font = beautiful.icofontname .. "12",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  },
  widget = wibox.container.background,
}

M.search = wibox.widget {
  {
    markup = "\u{f002}",
    font = beautiful.icofontname .. "12",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  },
  widget = wibox.container.background,
}

M.search:buttons(gears.table.join(
  awful.button({}, 1, function()
    awful.spawn.with_shell("rofi -show drun -show-icons -theme apps")
  end)
))

M.launch:buttons(gears.table.join(
  awful.button({}, 1, function()
    dashboard.toggle()
  end)
))

return M
