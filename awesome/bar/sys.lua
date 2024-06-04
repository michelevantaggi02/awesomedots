local help = require("help")
local signals = require("signals")
local M = {}

-- Net
M.net = wibox.widget {
  font = beautiful.icofontname .. "12",
  align = 'center',
  markup = "\u{f1eb}",
  widget = wibox.widget.textbox,
}

-- Volume
M.vol = wibox.widget {
  font = beautiful.icofontname .. "12",
  align = 'center',
  widget = wibox.widget.textbox,
}

-- Battery
M.battery = wibox.widget {
  font = beautiful.icofontname .. "12",
  align = 'center',
  widget = wibox.widget.textbox,
}

local battery_val = ""
local battery_color = beautiful.fg
local battery_tooltip = awful.tooltip {
  margins = { left = dpi(12), right = dpi(12), bottom = dpi(12), },
  fg = battery_color,
  bg = beautiful.bg,
  preferred_alignments = "middle",
  mode = "outside",
  shape = help.prrect(beautiful.bar_br, false, false, true, true),
}

battery_tooltip:add_to_object(M.battery)
M.battery:connect_signal("mouse::enter", function()
  battery_tooltip.markup = help.fg(battery_val .. "%", battery_color, "bold")
end)

-- Clock
M.clock = wibox.widget {
  font = beautiful.barfont,
  format = help.fg("%H:%M", beautiful.fg, "bold"),
  refresh = 1,
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textclock
}

local cal_btn = function(icon, comm, margin)
  local button = wibox.widget {
    {
      {
        widget = wibox.widget.textbox,
        font = beautiful.icofont,
        markup = help.fg(icon, beautiful.fg, "normal"),
        halign = "center",
        align = 'center',
      },
      margins = margin,
      widget = wibox.container.margin,
    },
    bg = beautiful.bg2,
    buttons = { awful.button({}, 1, function()
      comm()
    end) },
    shape = gears.shape.circle,
    widget = wibox.container.background,
  }
  button:connect_signal("mouse::enter", function()
    button.bg = beautiful.bg3
  end)
  button:connect_signal("mouse::leave", function()
    button.bg = beautiful.bg2
  end)
  return button
end

local day = tonumber(os.date('%d'))
local month = tonumber(os.date('%m'))
local year = tonumber(os.date('%Y'))
local function deco_cell(widget, flag, date)
  if flag == "header" then
    widget:set_markup(help.fg(widget:get_text(), beautiful.pri, "bold"))
    return wibox.widget {
      nil, --cal_btn("\u{f0d9}", nil, { left = dpi(8), right = dpi(8) }),
      widget,
      nil, --cal_btn("\u{f0da}", nil, { left = dpi(8), right = dpi(8) }),
      layout = wibox.layout.align.horizontal
    }
  elseif flag == "month" then
    return widget
  elseif flag == "weekday" then
    local ret = wibox.widget {
      markup = help.fg(widget:get_text(), beautiful.fg, "bold"),
      halign = "center",
      widget = wibox.widget.textbox
    }
    return ret
  end
  local today = date.day == day and date.month == month and date.year == year
  local ret = wibox.widget {
    {
      {
        nil,
        {
          markup = today and help.fg(widget:get_text(), beautiful.bg, "bold") or
              help.fg(widget:get_text(), beautiful.fg, "normal"),
          halign = "center",
          widget = wibox.widget.textbox
        },
        nil,
        layout = wibox.layout.align.horizontal
      },
      widget = wibox.container.margin,
      margins = dpi(5),
    },
    bg     = today and beautiful.pri or beautiful.bg,
    shape  = help.rrect(dpi(5)),
    widget = wibox.container.background
  }
  return ret
end

M.cal = awful.popup {
  widget    = {
    {
      date         = os.date('*t'),
      font         = beautiful.font,
      week_numbers = false,
      start_sunday = false,
      spacing      = dpi(5),
      fn_embed     = deco_cell,
      widget       = wibox.widget.calendar.month,
    },
    margins = dpi(20),
    widget = wibox.container.margin
  },
  shape     = help.rrect(beautiful.br),
  bg        = beautiful.bg,
  fg        = beautiful.fg,
  visible   = false,
  ontop     = true,
  placement = function(c)
    (awful.placement.top_right)(c,
          { margins = { right = (beautiful.useless_gap * 4), top = beautiful.bar_width } })
  end,
}

awful.placement.bottom_left(pop,
  { margins = { left = beautiful.bar_width + (beautiful.useless_gap * 4), bottom = beautiful.useless_gap * 2 } })


M.cal.toggle = function()
  M.cal.visible = not M.cal.visible
end

M.clock:buttons(gears.table.join(
  awful.button({}, 1, function()
    M.cal.toggle()
  end)
))

M.vol:buttons(gears.table.join(
  awful.button({}, 1, function()
    signals.toggle_vol_mute()
  end)
))

awesome.connect_signal("net::value", function(status)
  if status == 1 then
    M.net.opacity = 1
  else
    M.net.opacity = 0.25
  end
end)

local shown = 40

local popText = wibox.widget({
  markup = "10",
  widget = wibox.widget.textbox,
  align = "center",
  font = beautiful.fontname .. "30"
})


local popBat = wibox({
  type = "popup",
  halign = "center",
  valign = "center",
  ontop = true,
  visible = false,
  bg = beautiful.bg,
  opacity = .8,
  height = dpi(200),
  width = dpi(200)
})

popBat:setup({
  {
    wibox.widget({
      markup = help.fg("\u{f071}", beautiful.err, "bold"),
      widget = wibox.widget.textbox,
      align = "center",
      font = beautiful.fontname .. "50"
    }),
    margins = {top = dpi(20), left = dpi(20), right = dpi(20)},
    widget = wibox.container.margin
  },
  popText,

  layout = wibox.layout.flex.vertical
})

awful.placement.centered(popBat)

popBat:buttons(gears.table.join(
  awful.button({}, 1, function()
    popBat.visible = false
  end)
))

awesome.connect_signal("bat::value", function(status, charge)
  local icon = "\u{e19c}"

  if charge >= 85 then
    icon = "\u{f240}"
  elseif charge >= 60 and charge < 85 then
    icon = "\u{f241}"
  elseif charge >= 35 and charge < 60 then
    icon = "\u{f242}"
  elseif charge >= 10 and charge < 35 then
    icon = "\u{f243}"
  else
    icon = "\u{f244}"
  end
  if status == "Charging" or status == "Full" then
    battery_color = beautiful.ok
    shown = 40
    if charge >= 90 then
      naughty.notify({
        title = "Battery charged",
        text = charge .. "% full",
        timeout = 4
      })
    end
  elseif charge < 20 and status == "Discharging" then
    battery_color = beautiful.err
    if charge <= shown / 2 then
      popBat.visible = true
      shown = shown / 2
    end 
  end
  icon = help.fg(icon, battery_color, "normal")
  M.battery.markup = icon
  popText.markup = help.fg(charge .. "%", beautiful.err, "bold")
  battery_val = charge
end)

awesome.connect_signal('vol::value', function(mut, vol)
  if mut == 0 then
    M.vol.opacity = 1
    M.vol.markup = "\u{f6a8}"
  else
    M.vol.opacity = 0.25
    M.vol.markup = "\u{f6a9}"
  end
end)

return M
