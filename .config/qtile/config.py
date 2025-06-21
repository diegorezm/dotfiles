# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, MODify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
import re
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from xcolors import xcolors


def guess_terminal() -> str:
    term_v = os.environ.get("TERMINAL")
    if(term_v is None):
        return "alacritty"
    return term_v


MOD = "mod4"
CMD_RUNNER = "dmenu_run -p 'Run:' "
FONT = "JetBrainsMono Nerd Font"
FILE_EXPLORER = "thunar"

terminal = guess_terminal()
home = os.path.expanduser("~")
scripts_dir = os.getenv("SCRIPTS_DIR") or os.path.join(home, "/.local/bin/scripts")
browser = os.getenv("BROWSER")
monitor = subprocess.run(
    "xrandr | grep -sw 'connected' | wc -l",
    shell=True,
    stdout=subprocess.PIPE,
    check=True,
    universal_newlines=True,
    stderr=subprocess.PIPE,
).stdout.strip()


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call(home)


colors = {
    "background": (
        xcolors["qtile.bg"] if "qtile.bg" in xcolors else "#000000"
    ),
    "foreground": (
        xcolors["qtile.fg"] if "qtile.fg" in xcolors else "#FFFFFF"
    ),
    "primary": (
        xcolors["qtile.pr"] if "qtile.pr" in xcolors else "#FFFFFF"
    ),
    "subtext": (
        xcolors["qtile.sb"] if "qtile.sb" in xcolors else "#FFFFFF"
    ),
}

print(colors["background"])

keys = [
    Key(
        [MOD],
        "s",
        lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="dropdown terminal",
    ),
    Key(
        [MOD],
        "a",
        lazy.group["scratchpad"].dropdown_toggle("pavucontrol"),
        desc="dropdown audio control",
    ),
    Key(
        [MOD],
        "e",
        lazy.group["scratchpad"].dropdown_toggle(FILE_EXPLORER),
        desc="Launch file manager",
    ),
    Key(
        [MOD], "m", lazy.group["scratchpad"].dropdown_toggle("spotify"), desc="spotify"
    ),
    Key([MOD], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([MOD], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([MOD], "j", lazy.layout.down(), desc="Move focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="Move focus up"),
    Key([MOD], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Moving out of range in Columns layout will create new column.
    Key(
        [MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [MOD, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([MOD], "f", lazy.window.toggle_fullscreen()),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([MOD, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [MOD, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([MOD, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([MOD, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    #   Ult keys
    Key([MOD], "F8", lazy.spawn("xbacklight -dec 10")),
    Key([MOD], "F9", lazy.spawn("xbacklight -inc 10")),
    Key([MOD], "F10", lazy.spawn("pamixer -d 10")),
    Key([MOD], "F11", lazy.spawn("pamixer -i 10")),
    Key([], "Print", lazy.spawn(scripts_dir + "/screenshot")),

    Key([MOD], "F1", lazy.spawn(scripts_dir + "/power_ctl")),
    Key(
        [MOD],
        "F2",
        lazy.spawn(terminal + " -e " + home + "/.local/bin/" + "wallpapercl"),
        desc="wallpaper script",
    ),
    Key([MOD], "F3", lazy.spawn(scripts_dir + "/tmux_sessions"), desc="Tmux sessions"),
    Key([MOD], "F4", lazy.spawn(scripts_dir + "/change_theme"), desc="Change the system theme."),

    Key([MOD], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([MOD, "shift"], "Return", lazy.spawn(terminal + " -e yazi"), desc="Launch yazi"),
    Key([MOD], "p", lazy.spawn("playerctl -p 'spotify' play-pause"), desc="Toggle mpd"),
    Key([MOD], "n", lazy.spawn("playerctl -p 'spotify' next"), desc="Change the music"),
    Key([MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([MOD, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key(
        [MOD], "d", lazy.spawn(CMD_RUNNER), desc="Spawn a command using a prompt widget"
    ),
    Key([MOD], "w", lazy.spawn(browser), desc="Browser window"),
    Key(
        [MOD],
        "c",
        lazy.spawn(scripts_dir + "/config_quick_search"),
        desc="config files",
    ),
    Key([MOD], "z", lazy.spawn(scripts_dir + "/dir_quick_search"), desc="config files"),
    # Switch focus of monitors
    Key([MOD], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([MOD], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
]


groups = [
    Group("1", layout="monadtall"),
    Group("2", layout="monadtall"),
    Group("3", layout="monadtall"),
    Group("4", layout="monadtall"),
    Group("5", layout="monadtall"),
    Group("6", layout="monadtall"),
    Group("7", layout="monadtall"),
    Group("8", matches=[Match(wm_class=re.compile(r"^(steam)$"))], layout="monadtall"),
    Group(
        "9", matches=[Match(wm_class=re.compile(r"^(discord)$"))], layout="monadtall"
    ),
]

for i in groups:
    keys.extend(
        [
            Key(
                [MOD],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [MOD, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )

scratch_args = {"height": 0.9, "width": 0.90, "x": 0.05, "y": 0.01, "on_focus_lost_hide": False}

groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown("term", terminal, **scratch_args),
            DropDown("pavucontrol", "pavucontrol", **scratch_args),
            DropDown("spotify", "spotify-launcher", **scratch_args),
            DropDown(FILE_EXPLORER, FILE_EXPLORER, **scratch_args),
        ],
    ),
)

layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": colors["primary"],
    "border_normal": colors["subtext"],
}

layouts = [
    layout.Columns(border_focus_stack=[colors["primary"], colors["background"]], border_width=4),
    layout.MonadTall(**layout_theme),
    layout.Stack(num_stacks=2),
    layout.RatioTile(**layout_theme),
    layout.Floating(
        float_rules=[
            *layout.Floating.default_float_rules,
            Match(wm_class="confirmreset"),  # gitk
            Match(wm_class="makebranch"),  # gitk
            Match(wm_class="maketag"),  # gitk
            Match(wm_class="ssh-askpass"),  # ssh-askpass
            Match(title="branchdialog"),  # gitk
            Match(title="pinentry"),  # GPG key password entry
        ],
        **layout_theme,
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    **layout_theme,
)


widget_defaults = dict(
    font=FONT,
    fontsize=13,
    padding=3,
)

extension_defaults = widget_defaults.copy()


def build_widgets():
    return {
        "GroupBox": [
            widget.GroupBox(
                highlight_method="line",
                rounded=False,
                margin_y=3,
                margin_x=0,
                padding_y=5,
                padding_x=3,
                borderwidth=3,
                background=colors["background"],
                highlight_color=colors["background"],
                inactive=colors["subtext"],
                active=colors["foreground"],
                disable_drag=True,
                other_current_screen_border=xcolors["*color5"],
                this_current_screen_border=xcolors["*color1"],
            ),
            widget.Spacer(length=8),
        ],
        "Mpris": [
            widget.Mpris2(
                name="spotify",
                objname="org.mpris.MediaPlayer2.spotify",
                foreground=colors["foreground"],
                format="{xesam:title} - {xesam:artist}",
                playing_text=" {track}",
                paused_text=" {track}",
                no_metadata_text="NO METADATA",
                scroll_chars=None,
                max_chars=80,
            )
        ],
        "Clock": [
            widget.Spacer(),
            widget.TextBox(
                text="",
                padding=-2,
                fontsize=25,
                foreground=xcolors["*color3"],
                background=xcolors["*color3"],
            ),
            widget.Clock(
                format=" %H:%M",
                background=xcolors["*color3"],
                foreground=colors["background"],
            ),
            widget.TextBox(
                text="",
                padding=-2,
                fontsize=25,
                foreground=xcolors["*color3"],
                background=xcolors["*color3"],
            ),
            widget.Spacer(),
        ],
        "Systray": [
            widget.Spacer(),
            widget.Systray(),
        ],
        "Updates": [
            widget.Spacer(length=3, background=colors["background"]),
            widget.TextBox(
                text="",
                padding=-2,
                fontsize=25,
                foreground=xcolors["*color9"],
                background=colors["background"],
            ),
            widget.CheckUpdates(
                update_interval=800,
                no_update_string="No updates",
                display_format="󰃘 {updates} ",
                padding=5,
                background=xcolors["*color9"],
                initial_text="Aguarde...",
                colour_have_updates=colors["foreground"],
                distro="Arch_checkupdates",
                mouse_callbacks={
                    "Button1": lazy.spawn("chk_up"),
                    "Button3": lazy.spawn(terminal + " -e sudo pacman -Syyu"),
                },
            ),
            widget.TextBox(
                text="",
                padding=-2,
                fontsize=25,
                foreground=xcolors["*color9"],
                background=colors["background"],
            ),
        ],
        "Volume": [
            widget.Spacer(length=3, background=colors["background"]),
            widget.TextBox(
                text="",
                padding=-2,
                fontsize=30,
                foreground=xcolors["*color6"],
                background=colors["background"],
            ),
            widget.Volume(
                background=xcolors["*color6"],
                foreground=colors["background"],
                emoji_list=["󰖁", "󰕿", "󰖀", "󰕾"],
                emoji=False,
                volume_app="pavucontrol",
                fmt="󰕾 {}",
            ),
            widget.TextBox(
                text="",
                padding=-2,
                fontsize=30,
                foreground=xcolors["*color6"],
                background=colors["background"],
            ),
        ],
        "Battery": [
            widget.Spacer(length=3, background=colors["background"]),
            widget.TextBox(
                text="",
                padding=-2,
                fontsize=30,
                foreground=xcolors["*color2"],
                background=colors["background"],
            ),
            widget.Battery(
                background=xcolors["*color2"],
                foreground=colors["background"],
                format="{char} {percent:2.0%}",
                charge_char="󰂄",
                discharge_char=" ",
                padding=2,
            ),
            widget.TextBox(
                text="",
                padding=-2,
                fontsize=30,
                foreground=xcolors["*color2"],
                background=colors["background"],
            ),
        ],
    }


def init_widgets_screen1():
    widget_map = build_widgets()
    return (
        widget_map["GroupBox"]
        + widget_map["Mpris"]
        + widget_map["Clock"]
        + widget_map["Systray"]
        + widget_map["Updates"]
        + widget_map["Volume"]
        + widget_map["Battery"]
    )


def init_widgets_screen2():
    widget_map = build_widgets()
    return (
        widget_map["GroupBox"]
        + widget_map["Clock"]
        + widget_map["Battery"]

    )


def init_screens():
    if monitor != "1":
        return [
            Screen(
                top=bar.Bar(
                    widgets=init_widgets_screen1(),
                    opacity=1.0,
                    size=22,
                    background=colors["background"],
                )
            ),
            Screen(
                top=bar.Bar(
                    widgets=init_widgets_screen2(),
                    opacity=1.0,
                    size=20,
                    background=colors["background"],
                )
            ),
        ]
    return [
        Screen(
            top=bar.Bar(
                widgets=init_widgets_screen1(),
                opacity=1.0,
                size=20,
                background=colors["background"],
            )
        )
    ]


screens = init_screens()

# Drag floating layouts.
mouse = [
    Drag(
        [MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 18

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
