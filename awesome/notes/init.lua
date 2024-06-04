local sig = require("signals")

local icon = wibox.widget {
  align  = 'left',
  valign = 'center',
  font   = beautiful.fontname .. "16",
  fg     = beautiful.fg,
  widget = wibox.widget.textbox
}


local notes = wibox({
  type    = "popup",
  halign  = "left",
  valign  = "center",
  ontop   = false,
  visible = true,
  fg      = beautiful.pri,
  height  = dpi(200),
  width   = dpi(350),
  opacity = 0.75
})

awful.placement.top_right(notes, { margins = { right = beautiful.useless_gap * 4, top = beautiful.useless_gap * 4 + beautiful.bar_width} })


gears.timer {
  timeout = 60,
  call_now = true,
  autostart = true,
  callback = function()
    awful.spawn.easy_async_with_shell(
      "curl -s $LINK$(date -I).json | jq .\"[]?\"",
      function(out)
        icon.markup = "> " .. out:gsub("[", ""):gsub("]", ""):gsub("\"", ""):gsub("\n", "\n> ")
        local _, count = string.gsub(out, "\n", "")
        notes.height = dpi((count + 7) * 20)
        notes.visible = true
      end
    )
  end
}

notes:setup({
  {
    wibox.widget {
      align = "center",
      valign = "top",
      font = beautiful.fontname .. "20",
      markup = "Oggi",
      widget = wibox.widget.textbox
    },
    margins = { top = dpi(12), bottom = dpi(12) },
    widget = wibox.container.margin
  },
  {
    icon,
    margins = { left = dpi(12) },
    widget = wibox.container.margin
  },
  layout = wibox.layout.fixed.vertical
})


local temps = wibox({
  type    = "popup",
  halign  = "center",
  valign  = "center",
  ontop   = false,
  visible = true,
  fg      = beautiful.pri,
  height  = dpi(200),
  width   = dpi(350),
  opacity = 0.75
})


local function temp_bar(name, val, max)
  return {
    {
      {
        widget = wibox.widget.textbox,
        text = name,
        align = "center",
        font = beautiful.fontname .. "11",
      },
      {

        {
          id        = name .. "-bar",
          max_value = max,
          value     = val,
          shape     = help.rrect(beautiful.br),
          widget    = wibox.widget.progressbar,
        },
        forced_height = 100,
        forced_width  = 10,
        direction     = 'east',
        layout        = wibox.container.rotate,
        widget        = wibox.widget.wibox,
        align         = "center"
      },

      {
        id = name .. "-text",
        widget = wibox.widget.textbox,
        text = val .. " C",
        align = "center",
        font = beautiful.fontname .. "11",
      },
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = { left = dpi(12), right = dpi(12) },
  }
end

temps:setup({
  {
    wibox.widget {
      align = "center",
      valign = "top",
      font = beautiful.fontname .. "20",
      markup = "Temps",
      widget = wibox.widget.textbox
    },
    margins = { top = dpi(12), bottom = dpi(12) },
    widget = wibox.container.margin
  },
  {
    temp_bar("Core 0", 10, 100),
    temp_bar("Core 1", 20, 100),
    temp_bar("Core 2", 30, 100),
    temp_bar("Core 3", 40, 100),
    layout = wibox.layout.fixed.horizontal,
  },
  layout = wibox.layout.fixed.vertical
})

awful.placement.bottom_right(temps,
  { margins = { right = beautiful.useless_gap * 4, bottom = beautiful.useless_gap * 4 } })

gears.timer {
  timeout = 5,
  call_now = true,
  autostart = true,
  callback = function()
    for i = 0, 3 do
      local text = "Core " .. i
      awful.spawn.easy_async_with_shell(
        "sensors -u 2>> /dev/null | grep \"" .. text .. "\" -A 3 | grep -o \"input: [0-9]*\" | grep -o \"[0-9]*\"",
        function(out)
          temps:get_children_by_id(text .. "-text")[1].text = out .. "°C"
          temps:get_children_by_id(text .. "-bar")[1].value = tonumber(out)
        end
      )
    end
  end
}


local bats = wibox({
  type    = "popup",
  halign  = "left",
  valign  = "center",
  ontop   = false,
  visible = true,
  fg      = beautiful.pri,
  height  = dpi(200),
  width   = dpi(350),
  opacity = 0.75
})

local graph = wibox.widget({
  max_value = 100,
  forced_height = dpi(200),
  step_width = 3,
  step_spacing = 1,
  widget = wibox.widget.graph

})

bats:setup(
  {
    {
      wibox.widget {
        align = "center",
        valign = "top",
        font = beautiful.fontname .. "20",
        markup = "Bat",
        widget = wibox.widget.textbox
      },
      margins = { top = dpi(12), bottom = dpi(12) },
      widget = wibox.container.margin
    },

    {
      graph,
      margins = dpi(12),

      widget = wibox.container.margin
    },
    layout = wibox.layout.fixed.vertical
  }
)

awesome.connect_signal("bat::value", function(status, val)
  graph:add_value(val)
end)

awful.placement.right(bats, { margins = { right = beautiful.useless_gap * 4 } })
--awful.placement.stretch_down(graph)

local files = wibox({
  type    = "popup",
  halign  = "left",
  valign  = "center",
  ontop   = false,
  visible = true,
  fg      = beautiful.pri,
  height  = dpi(600),
  width   = dpi(300),
  opacity = 0.75
})

local function create_file(name)
  icon = "folder"

  if name.find(".") then
    icon = "file"
  end
  return {
    {
      {
        widget = wibox.widget.textbox,
        text = icon,

      },
      {
        widget = wibox.widget.textbox,
        text = name
      },

      layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    margins = { left = dpi(10), right = dpi(10) }
  }
end

local item_list = { layout = wibox.layout.fixed.vertical, id = "item_list" }
local indx = 0


files:setup({
  {
    wibox.widget {
      align = "center",
      valign = "top",
      font = beautiful.fontname .. "20",
      markup = "Listaw",
      widget = wibox.widget.textbox
    },
    margins = { top = dpi(12), bottom = dpi(12) },
    widget = wibox.container.margin
  },
  {
    item_list,
    margins = { left = dpi(12) },
    widget = wibox.container.margin
  },
  layout = wibox.layout.fixed.vertical
})

gears.timer {
  timeout = 1,
  call_now = true,
  autostart = true,
  callback = function()
    awful.spawn.easy_async_with_shell("ls ~/Scrivania | col",
      function(out)
        indx = 0
        for line in out:gmatch("([^\n]*)\n?") do
          item_list[indx] = create_file(line)
          indx = indx + 1
        end

        files:get_children_by_id("item_list")[1] = item_list
      end)
  end
}

awful.placement.left(files)
