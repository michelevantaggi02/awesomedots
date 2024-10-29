local sys = require("bar.sys")
local oth = require("bar.oth")
local key = require("bar.key")

local tags = function(s)
  return wibox.widget {
    require("bar.tag")(s),
    widget = wibox.container.margin,
    margins = { left = dpi(18), right = dpi(18), top = dpi(4), bottom = dpi(4) }
  }
end
local function create_main(s)
  return wibox.widget { {
    {
      oth.launch,
      -- oth.search,
      tags(s),
      spacing = dpi(20),
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    margins = { left = dpi(20) },
    shape = help.prrect(beautiful.bar_br, false, false, true, true),
    bg = beautiful.bg,
  },
    widget = wibox.container.background,
    shape = help.prrect(beautiful.bar_br, false, false, true, false),
    bg = beautiful.bg,
  }
end


local sys = wibox.widget { {
  {
    {
      --sys.net,
      {
        widget = wibox.widget.systray,
      },
      key,
      sys.vol,
      sys.battery,
      spacing = dpi(20),
      layout = wibox.layout.fixed.horizontal,
    },
    oth.sep,
    sys.clock,
    layout = wibox.layout.fixed.horizontal,
  },
  widget = wibox.container.margin,
  margins = { right = dpi(20), left = dpi(20) },
},
  widget = wibox.container.background,
  shape = help.prrect(beautiful.bar_br, false, false, false, true),
  bg = beautiful.bg,
}

local function custom_titlebar(s)
  return awful.widget.tasklist {
    screen          = s,
    filter          = awful.widget.tasklist.filter.currenttags,
    layout          = wibox.layout.fixed.horizontal,
    style           = {
      spacing = 1,
    },

    widget_template = {
      {
        {
          id = "text_role",
          widget = wibox.widget.textbox
        },
        widget = wibox.container.margin,
        margins = { right = dpi(12), left = dpi(12) }
      },

      bg = beautiful.bg,
      shape = help.prrect(beautiful.bar_br, false, false, true, true),
      widget = wibox.container.background,
    }
  }
end

awful.screen.connect_for_each_screen(function(s)
  awful.wibar({
    position     = "top",
    bg           = "#00000000",
    fg           = beautiful.fg,
    width        = s.geometry.width,
    border_width = 0,
    --height = beautiful.bar_width,--s.geometry.height,-- - beautiful.useless_gap * 4,
    margins      = { top = 0 }, --beautiful.useless_gap * 2 },
    --shape = help.prrect(beautiful.bar_br, false, false, true, true),
    screen       = s
  }):setup {
    create_main(s),
    custom_titlebar(s),
    sys,
    expand = "none",
    layout = wibox.layout.align.horizontal,
  }
end)
