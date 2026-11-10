-- Hyprland Lua config — migrated from hyprland.conf (hyprlang) on 2026-08-27.
-- Refer to the wiki: https://wiki.hypr.land/Configuring/Start/
-- Your original config is preserved at hyprland.conf (loaded only if this file is absent).


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "",      mode = "preferred", position = "auto", scale = "auto" })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun -show-icons"
-- Floating TUI window (class tui-float gets floated + centered by a window rule)
local function tui(cmd) return terminal .. " --class tui-float -e " .. cmd end


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("mako")
    hl.exec_cmd("command -v swayosd-server >/dev/null && swayosd-server")            -- volume/brightness OSD
    hl.exec_cmd("wl-paste --type text --watch cliphist store")                       -- clipboard history
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("sleep 1 && wallpaper restore && wallpaper rotate 1800")             -- new wallpaper every 30 min
    hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 24")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- ~/.local/bin holds helper scripts (wallpaper, hypr-keys, wifi-tui) and claude; zshrc PATH isn't used by Hyprland
do
    local bin, path = os.getenv("HOME") .. "/.local/bin", os.getenv("PATH") or ""
    if not (":" .. path .. ":"):find(":" .. bin .. ":", 1, true) then
        hl.env("PATH", bin .. ":" .. path) -- only once, even across `hyprctl reload`
    end
end
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "catppuccin-mocha-dark-cursors")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(89b4faee)", "rgba(cba6f7ee)"}, angle = 45 }, -- Catppuccin blue -> mauve
            inactive_border = "rgba(45475aaa)", -- Catppuccin surface1
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a, -- rgba(1a1a1aee)
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "slave", -- new windows join the stack; the big window stays
    },

    misc = {
        force_default_wallpaper = 0, -- hyprpaper + ~/.local/bin/wallpaper handle wallpapers
        disable_hyprland_logo   = false,
    },
})

-- Bezier curves, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "eu",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Example per-device config
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Layout helpers: each workspace is dwindle (default) or master (SUPER+SHIFT+T toggles)
local function is_master()
    local ws = hl.get_active_workspace()
    return ws ~= nil and ws.tiled_layout == "master"
end
local function master_msg(msg) -- run a master-layout command, no-op on dwindle workspaces
    return function() if is_master() then hl.dispatch(hl.dsp.layout(msg)) end end
end
-- Every bind has a trailing comment: SUPER+K (hypr-keys) shows them as a cheat sheet.

-- Apps
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))      -- terminal (kitty)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))   -- file manager (Thunar)
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))          -- app launcher (rofi)
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("hypr-keys")) -- this cheat sheet (SUPER+/)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p clipboard -display-columns 2 | cliphist decode | wl-copy")) -- clipboard history
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("wallpaper next"))           -- next wallpaper
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("wallpaper random")) -- random wallpaper

-- System TUIs (floating)
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd(tui("wifi-tui"))) -- wifi (wlctl, or themed nmtui)
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(tui("bluetui")))  -- bluetooth (bluetui)
hl.bind(mainMod .. " + CTRL + A", hl.dsp.exec_cmd(tui("wiremix")))  -- audio mixer (wiremix)
hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd(tui("btop")))     -- system monitor (btop)

-- Session
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("pidof hypridle >/dev/null && loginctl lock-session || hyprlock")) -- lock screen
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd("wlogout"))  -- power menu
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")) -- log out of Hyprland

-- Screenshots (saved to ~/Pictures/Screenshots)
hl.bind("Print", hl.dsp.exec_cmd([[hyprshot -m region --raw | satty --filename - --output-filename "$HOME/Pictures/Screenshots/$(date +%F_%H-%M-%S).png" --copy-command wl-copy --early-exit]])) -- screenshot region -> annotate (satty)
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd([[hyprshot -m region --raw | satty --filename - --output-filename "$HOME/Pictures/Screenshots/$(date +%F_%H-%M-%S).png" --copy-command wl-copy --early-exit]])) -- screenshot region -> annotate (same as Print)
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m output -m active -o $HOME/Pictures/Screenshots")) -- screenshot whole screen (file + clipboard)
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))           -- screenshot region -> clipboard only
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m window -o $HOME/Pictures/Screenshots")) -- screenshot a window

-- Windows
hl.bind(mainMod .. " + C", hl.dsp.window.close())                                   -- close window
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))              -- toggle floating
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())                                  -- pseudo-tile (dwindle)
hl.bind(mainMod .. " + T", function() -- flip split (dwindle) / flip big window side (master)
    if is_master() then hl.dispatch(hl.dsp.layout("orientationcycle left right"))
    else hl.dispatch(hl.dsp.layout("togglesplit")) end
end)
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- fullscreen (hides bar)
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))  -- maximize (keeps bar)

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))   -- focus left
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))  -- focus right
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))     -- focus up
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))   -- focus down
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))   -- focus left (vim)
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))   -- focus down (vim)
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))     -- focus up (vim)
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))  -- focus right (vim)

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))  -- move window left
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))  -- move window right
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))  -- move window up
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))  -- move window down
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))  -- move window left (vim)
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))  -- move window down (vim)
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))  -- move window up (vim)
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))  -- move window right (vim)

-- Cycle windows on this workspace
hl.bind("ALT + Tab",         hl.dsp.window.cycle_next())                  -- next window
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))  -- previous window

-- Master layout (1 big + stack). SUPER+SHIFT+T switches this workspace dwindle <-> master
hl.bind(mainMod .. " + SHIFT + T", function() -- toggle this workspace: dwindle <-> master
    local ws = hl.get_active_workspace()
    if ws == nil or ws.id == nil then return end
    hl.workspace_rule({ workspace = tostring(ws.id), layout = is_master() and "dwindle" or "master" })
end)
hl.bind(mainMod .. " + Return", master_msg("swapwithmaster")) -- (master) focused window becomes the big one
hl.bind(mainMod .. " + period", master_msg("rollnext"))       -- (master) rotate: next window into the big spot
hl.bind(mainMod .. " + comma",  master_msg("rollprev"))       -- (master) rotate: previous window into the big spot
hl.bind(mainMod .. " + CTRL + right", function() -- big window wider (master) / grow window (dwindle)
    if is_master() then hl.dispatch(hl.dsp.layout("mfact +0.05"))
    else hl.dispatch(hl.dsp.window.resize({ x = 60, y = 0, relative = true })) end
end, { repeating = true })
hl.bind(mainMod .. " + CTRL + left", function() -- big window narrower (master) / shrink window (dwindle)
    if is_master() then hl.dispatch(hl.dsp.layout("mfact -0.05"))
    else hl.dispatch(hl.dsp.window.resize({ x = -60, y = 0, relative = true })) end
end, { repeating = true })

-- Groups (tabbed windows)
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())                            -- make/unmake a tab group
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.move({ into_group = "l" })) -- move window into the group on the left
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ into_group = "r" })) -- move window into the group on the right
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.move({ into_group = "u" })) -- move window into the group above
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.move({ into_group = "d" })) -- move window into the group below
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true })) -- take window out of its group
hl.bind(mainMod .. " + CTRL + Tab", hl.dsp.group.next())                       -- next tab in group
hl.bind(mainMod .. " + CTRL + SHIFT + Tab", hl.dsp.group.prev())               -- previous tab in group

-- Keyboard resize mode: mainMod + minus enters, arrows/hjkl resize, Escape/Enter exits
hl.bind(mainMod .. " + minus", hl.dsp.submap("resize")) -- resize mode (arrows/hjkl, Esc to exit)

hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true }) -- wider
    hl.bind("left",  hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true }) -- narrower
    hl.bind("up",    hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true }) -- shorter
    hl.bind("down",  hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true }) -- taller
    hl.bind("l",     hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true }) -- wider
    hl.bind("h",     hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true }) -- narrower
    hl.bind("k",     hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true }) -- shorter
    hl.bind("j",     hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true }) -- taller
    hl.bind("escape", hl.dsp.submap("reset")) -- leave resize mode
    hl.bind("return", hl.dsp.submap("reset")) -- leave resize mode
end)

-- Workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))       -- go to workspace
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i })) -- move window to workspace
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false })) -- send window to workspace (stay here)
end

hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" })) -- back to previous workspace
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))           -- show/hide scratchpad
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" })) -- move window to scratchpad

-- Agents scratchpad: Herdr in kitty. Super+A shows/hides it, starting Herdr first if it isn't running.
hl.bind(mainMod .. " + A", function() -- show/hide agents (herdr)
    if #hl.get_windows({ class = "herdr" }) == 0 then
        hl.exec_cmd("kitty --class herdr -e herdr")
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("agents"))
end)

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" })) -- next workspace
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" })) -- previous workspace

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true }) -- move window
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- resize window

-- Volume / brightness: swayosd shows an on-screen indicator; falls back to wpctl/brightnessctl
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise || wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true }) -- volume up
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower || wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true }) -- volume down
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle || wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true }) -- mute
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle || wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true }) -- mic mute
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise || brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true }) -- brightness up
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower || brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true }) -- brightness down

-- Lid: logind ignores lid-close on AC (keeps running), so lock + turn the laptop screen off here.
-- On battery logind still suspends (hypridle locks first).
hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd([[loginctl lock-session; hyprctl dispatch 'hl.dsp.dpms({ action = "off", monitor = "eDP-1" })']]), { locked = true }) -- lid closed: lock + screen off
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd([[hyprctl dispatch 'hl.dsp.dpms({ action = "on" })']]), { locked = true }) -- lid opened: screen on

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true }) -- next track
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- play/pause
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- play/pause
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true }) -- previous track


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Herdr (agents) always opens on the agents scratchpad
hl.window_rule({
    name      = "herdr-scratchpad",
    match     = { class = "^herdr$" },
    workspace = "special:agents silent",
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Floating TUIs (wifi/bluetooth/audio/btop) opened via tui()
hl.window_rule({
    name   = "tui-float",
    match  = { class = "^tui-float$" },
    float  = true,
    size   = "monitor_w*0.6 monitor_h*0.65",
    center = true,
})
