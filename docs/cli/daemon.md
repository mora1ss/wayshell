---
sidebar_position: 2
title: Wayshell daemon
sidebar_label: Wayshell daemon
slug: /cli/daemon
---

# Wayshell daemon

`wayshelld` is the background service daemon for the desktop shell.

## Options

- `-v, --verbose`: Enable verbose logging output.
- `-V, --version`: Print installed version and exit.
- `-h, --help`: Show usage help and exit.

## Commands

### `start`

- `wayshelld start`: Start the desktop shell and background services, including the [audio engine](/audio) (default command).

### `stop`

- `wayshelld stop`: Stop the running daemon and all background shell processes (`serpantinum-core screentime track`, `quickshell`).

### `status`

- `wayshelld status`: Check whether the daemon is currently running (exit code 0 if running, 1 if stopped).

## Autostart

Compositor autostart examples:

- Hyprland (`config/autostart.lua`): `hl.exec_cmd("wayshelld start")`
- Niri (`config/autostart.kdl`): `spawn-at-startup "wayshelld" "start"`
- Sway (`configDir/autostart`): `exec wayshelld start`
- Mango (`config/autostart.conf`): `exec_once=wayshelld start`
