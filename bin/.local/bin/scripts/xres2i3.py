#!/usr/bin/env python3
"""
xres2i3.py — pull dwm.background / dwm.foreground / dwm.selbackground /
dwm.selforeground / color1 (red) out of an Xresources file and emit an
i3 config snippet (window colors + bar colors) using exactly those.

Usage:
    ./xres2i3.py ~/.Xresources > ~/.config/i3/theme.conf
"""
import re, sys

def parse_xresources(path):
    colors = {}
    pat = re.compile(r'^\*?\.?([\w.]+)\s*:\s*(#[0-9a-fA-F]{3,6})')
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('!'):
                continue
            m = pat.match(line)
            if m:
                key, val = m.groups()
                colors[key.lower()] = val
    return colors

def main():
    if len(sys.argv) != 2:
        sys.exit(f"usage: {sys.argv[0]} <Xresources-file>")
    c = parse_xresources(sys.argv[1])

    bg = c.get('dwm.background')
    fg = c.get('dwm.foreground')
    sel_bg = c.get('dwm.selbackground')
    sel_fg = c.get('dwm.selforeground')
    red = c.get('color1')

    missing = [name for name, val in
               [('dwm.background', bg), ('dwm.foreground', fg),
                ('dwm.selbackground', sel_bg), ('dwm.selforeground', sel_fg),
                ('color1', red)]
               if val is None]
    if missing:
        sys.exit(f"error: could not find in Xresources: {', '.join(missing)}")

    print(f"""\
set $bg      {bg}
set $fg      {fg}
set $sel_bg  {sel_bg}
set $sel_fg  {sel_fg}
set $red     {red}

# class                 border    backgr.   text     indicator  child_border
client.focused           $sel_bg   $sel_bg   $sel_fg  $sel_bg    $sel_bg
client.focused_inactive  $bg       $bg       $fg      $bg        $bg
client.unfocused         $bg       $bg       $fg      $bg        $bg
client.urgent            $red      $red      $fg      $red       $red
client.placeholder       $bg       $bg       $fg      $bg        $bg

client.background        $bg

bar {{
    position top
    status_command SCRIPT_DIR=~/.local/bin/scripts/status/ i3blocks
    colors {{
        statusline $fg
        background $bg
        # workspaces section
        #                    border    background  text
        focused_workspace    $sel_bg   $sel_bg     $sel_fg
        inactive_workspace   $bg       $bg         $fg
        active_workspace     $bg       $bg         $fg
        urgent_workspace     $red      $red        $fg
    }}
}}
""")

if __name__ == '__main__':
    main()
