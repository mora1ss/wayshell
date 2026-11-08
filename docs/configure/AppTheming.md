---
sidebar_position: 2
title: App theming
sidebar_label: App theming
slug: /configure/app-theming
---

# App theming

Wayshell can recolor other apps with the same palette as the shell, whether it comes from the wallpaper (Matugen) or from a preset. Open **Settings → Theme → App theming**. The page lists the apps that are currently themed. Add another one from **Add app**, or remove one with the delete button on its tile.

**Add app** only offers apps that are installed. Nothing is installed for you, and an app that is switched on but not installed is skipped.

On by default: **Kitty**, **Cava**, **GTK** and **Qt**. Everything else is opt-in.

## How it works

Every time the colors change, Wayshell renders each enabled app's template with [matugen](https://github.com/InioX/matugen) into a separate theme file, such as `~/.config/kitty/themes/wayshell.conf`. It then adds a single include line to the app's own config so the app loads that file.

Your config files are never overwritten. The lines Wayshell adds are wrapped in markers:

```
# >>> wayshell theme >>>
include themes/wayshell.conf
# <<< wayshell theme <<<
```

If one of your existing lines would override the theme (for example another `theme =` line), it is commented out as `# wayshell-disabled: ...`.

When you switch an app off, Wayshell removes its block, restores the lines it commented out, deletes the generated theme file and puts back any setting values it changed. A config file it had to create is removed again if nothing else was added to it.

When a config can't be edited safely, for example because it is a read-only file managed by Home Manager or its structure is unusual, nothing is changed. A warning button appears on the app's tile. Click it to see what went wrong and the exact line to add yourself, with buttons to copy it and to open the folder.

Apps are only reloaded when their colors actually changed. A broken template only affects its own app, never the shell or other apps.

## Built-in apps

| App | Theme file | Config change |
| :--- | :--- | :--- |
| GTK 3 / 4 | `~/.config/gtk-{3,4}.0/wayshell.css` | `@import` at the top of `gtk.css`; sets `color-scheme` and, if [adw-gtk3](https://github.com/lassekongo83/adw-gtk3) is installed, `gtk-theme` |
| Qt | `~/.config/qt{5,6}ct/colors/wayshell.conf` | `color_scheme_path` and `custom_palette` in `qt5ct.conf` / `qt6ct.conf`. Needs qt6ct (or qt5ct) and `QT_QPA_PLATFORMTHEME=qt6ct` |
| KDE apps | `~/.local/share/color-schemes/Wayshell.colors` | Color groups and `ColorScheme` in `kdeglobals` |
| Kitty | `~/.config/kitty/themes/wayshell.conf` | `include` in `kitty.conf` |
| Alacritty | `~/.config/alacritty/themes/wayshell.toml` | `import` under `[general]` |
| Foot | `~/.config/foot/themes/wayshell` | `include=` in `foot.ini` |
| Ghostty | `~/.config/ghostty/themes/wayshell` | `theme = wayshell` |
| WezTerm | `~/.config/wezterm/colors/wayshell.toml` | `config.color_scheme` before `return config` |
| Konsole | `~/.local/share/konsole/Wayshell.colorscheme` | None, pick it in your profile |
| Rio | `~/.config/rio/themes/wayshell.toml` | `theme = "wayshell"` |
| Helix | `~/.config/helix/themes/wayshell.toml` | `theme = "wayshell"` |
| VS Code (also VSCodium, Code - OSS, Cursor) | `~/.cache/wayshell/apps/vscode.json` | Colors, token colors and the matching default theme in `User/settings.json`. Only plain JSON is edited: a file with comments gets a warning instead |
| Emacs | `wayshell-theme.el` in `~/.config/emacs`, `~/.emacs.d` or `~/.config/doom/themes` | None, run `M-x load-theme wayshell` |
| Obsidian | `.obsidian/snippets/wayshell.css` in every vault | Adds the snippet to `enabledCssSnippets` in the vault's `appearance.json` |
| Neovim | `~/.config/nvim/colors/wayshell.lua` | None, run `:colorscheme wayshell` |
| Vim | `~/.vim/colors/wayshell.vim` | None, run `:colorscheme wayshell` |
| Kakoune | `~/.config/kak/colors/wayshell.kak` | `colorscheme wayshell` in `kakrc` |
| Micro | `~/.config/micro/colorschemes/wayshell.micro` | None, run `> set colorscheme wayshell` |
| Sublime Text | `~/.config/sublime-text/Packages/User/Wayshell.sublime-color-scheme` | None, pick it in the color scheme selector |
| Btop | `~/.config/btop/themes/wayshell.theme` | `color_theme` in `btop.conf` |
| Cava | `~/.config/cava/themes/wayshell` | `theme` under `[color]` |
| Fastfetch | `~/.config/fastfetch/wayshell.jsonc` | None, run `fastfetch -c wayshell` |
| Fish | `~/.config/fish/conf.d/wayshell.fish` | None, loaded by new shells |
| Bat | `~/.config/bat/themes/wayshell.tmTheme` | `--theme="wayshell"` in `bat/config`; runs `bat cache --build` |
| Yazi | `~/.config/yazi/flavors/wayshell.yazi/` | `dark` and `light` under `[flavor]` in `theme.toml` |
| Lazygit | `~/.cache/wayshell/apps/lazygit.yml` | A `gui.theme` block in `config.yml`. If it already has a `gui:` section, a warning shows the block to add |
| Starship | `~/.cache/wayshell/apps/starship.toml` | `palette = "wayshell"` and a `[palettes.wayshell]` table in `starship.toml` |
| fzf | `~/.config/fzf/wayshell.sh` (and a Fish `conf.d` snippet) | Sources the snippet from `~/.bashrc` and `~/.zshrc` if they exist |
| lsd | `~/.config/lsd/wayshell.yaml` | `color.theme` in `config.yaml` |
| Superfile | `~/.config/superfile/theme/wayshell.toml` | `theme` in `config.toml` |
| Glow | `~/.config/glow/wayshell.json` | `style` in `glow.yml` |
| Atuin | `~/.config/atuin/themes/wayshell.toml` | `name` under `[theme]` in `config.toml` |
| k9s | `~/.config/k9s/skins/wayshell.yaml` | None, set `skin: wayshell` in your k9s config |
| Claude Code | `~/.claude/themes/wayshell.json` | None, pick it with `/theme` |
| tmux | `~/.config/tmux/wayshell.conf` | `source-file` in `tmux.conf` |
| Zellij | `~/.config/zellij/themes/wayshell.kdl` | `theme "wayshell"` |
| Zathura | `~/.config/zathura/wayshell` | `include wayshell` |
| Fuzzel | `~/.config/fuzzel/wayshell.ini` | `include=` in `fuzzel.ini` |
| Rofi | `~/.local/share/rofi/themes/wayshell.rasi` | `@theme "wayshell"` |
| Wofi | `~/.config/wofi/wayshell.css` | `@import` at the top of `style.css` |
| Vicinae | `~/.local/share/vicinae/themes/wayshell.toml` | None, pick it in the settings |
| Firefox (userChrome; also LibreWolf, Floorp) | `chrome/wayshell.css` in every profile | `@import` in `chrome/userChrome.css` and the `toolkit.legacyUserProfileCustomizations.stylesheets` pref in `user.js` |
| Zen Browser | `chrome/wayshell.css` in every profile | Same as Firefox |
| Halloy | `~/.config/halloy/themes/wayshell.toml` | `theme` in `config.toml` |
| aerc | `~/.config/aerc/stylesets/wayshell` | `styleset-name` under `[ui]` in `aerc.conf` |
| spotify-player | A `[[themes]]` entry in `theme.toml` | `theme` in `app.toml` |

Compositor borders are never themed. They stay in your compositor config.

## Customizing a built-in app

Press the edit button on an app's tile. Its files are copied to `${XDG_CONFIG_HOME:-~/.config}/wayshell/matugen/apps/<app>/` and the folder opens. The folder button at the top of the page opens the parent folder.

- The template files use matugen syntax, such as `{{colors.primary.default.hex}}`, `{{colors.surface.default.hex_stripped}}` or `{{mode}}`. They are rendered again on every color change.
- `app.json` describes where the theme file goes and which line is added to the app's config. It usually doesn't need changes.
- The reset button restores the built-in version. Your copy is kept in `~/.local/state/wayshell/matugen/backup/`.

Only built-in apps can be customized this way. Folders with other names are ignored.

## Command line

```sh
wayshell info theme apps
wayshell set theme app <id> [on|off|toggle]
```
