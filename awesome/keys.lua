local signals = require("signals")

-- Variables
local keys = {}

local mod = 'Mod4'
local tags = 5
keys.tags = tags

multiscreen = false;

-- Keybindings
keys.globalkeys = gears.table.join(
-- Awesome
  awful.key({ mod, 'Shift' }, 'r', awesome.restart),
  awful.key({ mod }, 'd', function() dashboard.toggle() end),

  --Hardware ( Laptop Users )
  awful.key({}, 'XF86MonBrightnessUp', function() awful.spawn.with_shell('brightnessctl set 5%+ -q') signals.bri() end),
  awful.key({}, 'XF86MonBrightnessDown', function() awful.spawn.with_shell('brightnessctl set 5%- -q') signals.bri() end),
  awful.key({}, 'XF86AudioRaiseVolume', function()
    awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ +5%')
    signals.vol()
  end)
  ,
  awful.key({}, 'XF86AudioLowerVolume', function()
    awful.spawn.with_shell('pactl set-sink-volume @DEFAULT_SINK@ -5%')
    signals.vol()
  end)
  ,
  awful.key({}, "XF86AudioMute", function()
    signals.toggle_vol_mute()
  end),

  -- Window management
  awful.key({ mod }, 'Tab', function() awful.client.focus.byidx(1) end),
  awful.key({ mod }, 't', function(c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" }),
  awful.key({ mod }, 'Right', function() awful.tag.incmwfact(0.025) end),
  awful.key({ mod }, 'Left', function() awful.tag.incmwfact(-0.025) end),
  awful.key({ mod }, 'Up', function() awful.client.incwfact(0.05) end),
  awful.key({ mod }, 'Down', function() awful.client.incwfact(-0.05) end),
  awful.key({ mod, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
    { description = "swap with next client by index", group = "client" }),
  awful.key({ mod, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
    { description = "swap with previous client by index", group = "client" }),
  awful.key({ mod, "Control" }, "j", function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),
  awful.key({ mod, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
    { description = "focus the previous screen", group = "screen" }),
  awful.key({ mod }, "j", function()
    awful.client.focus.bydirection("down")
  end),
  awful.key({ mod }, "h", function()
    awful.client.focus.bydirection("left")
  end),
  awful.key({ mod }, "k", function()
    awful.client.focus.bydirection("up")
  end),
  awful.key({ mod }, "l", function()
    awful.client.focus.bydirection("right")
  end),

  -- Opacity
  awful.key({ mod, "Control" }, "KP_Subtract", function()
    awful.spawn("picom-trans -c -o -3", false)
  end),
  awful.key({ mod, "Control" }, "KP_Add", function()
    awful.spawn("picom-trans -c -o +3", false)
  end),
  awful.key({ mod, "Control" }, "Return", function()
    awful.spawn("picom-trans -c -d", false)
  end),

  -- Applications
  awful.key({ mod }, 'Return', function() awful.util.spawn('kitty') end),
  awful.key({ mod }, 'e', function() awful.util.spawn('rofi -show drun -show-icons -theme apps') end),
  awful.key({ mod, "Shift" }, 'e',
    function()
      awful.util.spawn(
        "rofi -modi emoji -show emoji -emoji-format '<span size=\"xx-large\">{emoji}</span>' -emoji-mode copy -theme emoji")
    end)
  ,

  -- Screenshots
  awful.key({ mod, "Shift" }, 's',
    function() help.screenshot() end),

	-- Scorciatoie michi
    awful.key({ mod }, "F4", function() awful.spawn("shutdown now") end),
    awful.key({ mod }, "l", function() awful.spawn("betterlockscreen -l") end),
    awful.key({ mod, "Control" }, "r", awesome.restart),
    awful.key({ mod }, "F1", function() 
	multiscreen = not multiscreen;
	local schermo = "singolo.sh";
	if multiscreen then
		schermo = "fisso.sh";
	end
	local tutto = "/home/michi/.screenlayout/" .. schermo;
	awful.spawn.with_shell(tutto)
  end ),
	--awful.key({ mod }, "o", function(c) c:move_to_screen()  end),
	awful.key({ mod }, "u", function() awful.spawn("firefox unistudium.unipg.it/unistudium/my") end ),
	awful.key({ mod }, "w", function() awful.spawn("firefox web.whatsapp.com") end),
  awful.key({ mod }, "v", function() awful.spawn("vscodium") end),
  awful.key({ mod }, "o", function() awful.spawn("obsidian") end),
  awful.key({ mod }, "t", function() awful.spawn("thunar") end)

)

-- Keyboard Control
keys.clientkeys = gears.table.join(
  awful.key({ mod }, 'q', function(c) c:kill() end),
  awful.key({ mod }, 'm', function(c) c.minimized = true end),
  awful.key({ mod }, 'f', function(c)
    c.fullscreen = not c.fullscreen;
    c:raise()
  end),
  awful.key({ mod }, 's', function() awful.client.floating.toggle() end)
)

-- Mouse controls
keys.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c) client.focus = c end),
  awful.button({ mod }, 1, function() awful.mouse.client.move() end),
  awful.button({ mod }, 2, function(c) c:kill() end),
  awful.button({ mod }, 3, function() awful.mouse.client.resize() end)
)

for i = 1, tags do
  keys.globalkeys = gears.table.join(keys.globalkeys,
    -- View tag
    awful.key({ mod }, '#' .. i + 9,
      function()
        local tag = awful.screen.focused().tags[i]
        if tag then
          tag:view_only()
        end
      end),

    -- Move window to tag
    awful.key({ mod, 'Shift' }, '#' .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end))
end


keys.globalkeys = gears.table.join(keys.globalkeys, 

  awful.key( { mod, "Control" },  "Left", function ()

    local s = awful.screen.focused()

    s.tags[(s.selected_tag.index - 1) % (tags  + 1)]:view_only()
    
  end),

  awful.key( { mod, "Control" },  "Right", function ()

    local s = awful.screen.focused()

    s.tags[(s.selected_tag.index + 1) % (tags  + 1) ]:view_only()

    --s.selected_tag.viewnext(s)
    
  end)

)
-- Set globalkeys
root.keys(keys.globalkeys)

return keys
