---
sidebar_position: 1
title: Hyprland
sidebar_label: Hyprland
slug: /configure/compositors/hyprland
---

# Hyprland

Configuration is stored in `~/.config/hypr`. The main file is `hyprland.lua`, which loads modules from the `config/` directory:

- `variables.lua` - modifier keys and default applications
- `env.lua` - environment variables
- `autostart.lua` - startup processes
- `monitors.lua` - display and resolution setup
- `settings.lua` - window decorations, blur, animations, and input
- `keybinds.lua` - keybindings for compositor actions and shell controls

## Autostart

The shell daemon and clipboard history are launched from `config/autostart.lua`:

```lua
hl.on("hyprland.start", function()
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("wayshelld start")
end)
```

`wayshelld start` also starts the [audio engine](/audio).

## Keybindings

Shell overlays and controls are bound in `config/keybinds.lua` using `wayshell msg toggle <module>`:

- `launcher` - application launcher
- `system` - system control panel
- `clipboard` - clipboard history
- `music` - media player
- `wallpaper` - wallpaper selector
- `calendar` - calendar popout
- `network` - wi-fi and network connections
- `volume` - audio output and input slider
- `settings` - cheat sheet for keybindings

Workspace switching is routed through the shell to update bar indicators:

```lua
for i = 1, 10 do
  hl.bind("SUPER + " .. (i % 10), hl.dsp.exec_cmd("wayshell msg workspace " .. i))
  hl.bind("SUPER + SHIFT + " .. (i % 10), hl.dsp.exec_cmd("wayshell msg workspace " .. i .. " move"))
end
```

Quick utility actions:
- Lock screen: `wayshell lock`
- Reload shell: `wayshell reload`
- Bar autohide: `wayshell msg bar autohide`
- Screenshots: `wayshell screenshot` (add `--edit`, `--full`, or `--full --edit`)
- Brightness: `wayshell brightness lower` and `wayshell brightness raise`
- Volume: `wayshell volume lower`, `wayshell volume raise`, and `wayshell volume mute-toggle`
