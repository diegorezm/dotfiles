# IMPORT
from libqtile.dgroups import simple_key_binder
import os
import json
import subprocess
from libqtile import hook, widget
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy

with open("{}/.config/qtile/colors/colorscheme.json".format(os.getenv("HOME"))) as file:
    colors_json = json.load(file)

colors = colors_json


@lazy.function
def themeChanger(qtile):
    script = os.path.expanduser("~/.local/bin/changeTheme")
    return subprocess.Popen(script)


#   DEFINE VARIABLES
mod = "mod4"
terminal = os.getenv("TERMINAL")
home = os.path.expanduser('~')
nav = os.getenv("BROWSER")
# nav_app= "rofi -show drun -theme 'macchiato_styled' -show-icons"
nav_app = "dmenu_run -p 'Run:' "
main_font = "JetBrainsMono Nerd Font"
explorer = "pcmanfm"
monitor = subprocess.run("xrandr | grep -sw 'connected' | wc -l", shell=True,
                         stdout=subprocess.PIPE, universal_newlines=True, stderr=subprocess.PIPE).stdout.strip()


@hook.subscribe.startup_once
def autostart():
    changer = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([changer])


#   KEY BINDS
keys = [
    Key([mod], 's', lazy.group["scratchpad"].dropdown_toggle(
        'term'), desc="dropdown terminal"),
    Key([mod], 'a', lazy.group["scratchpad"].dropdown_toggle(
        'pavucontrol'), desc="dropdown audio control"),
    Key([mod], "e", lazy.group["scratchpad"].dropdown_toggle(
        explorer), desc="Launch file manager"),
    Key([mod], "m", lazy.group["scratchpad"].dropdown_toggle(
        "spotify"), desc="spotify"),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod], "f", lazy.window.toggle_fullscreen()),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    #   Ult keys
    Key([mod], "F8", lazy.spawn("xbacklight -dec 10")),
    Key([mod], "F9", lazy.spawn("xbacklight -inc 10")),
    Key([mod], "F10", lazy.spawn("pamixer -d 10")),
    Key([mod], "F11", lazy.spawn("pamixer -i 10")),
    Key([], "Print", lazy.spawn("screenshot.sh")),
    Key([mod], "F1", lazy.spawn("power.sh")),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "shift"], "Return", themeChanger(),
        desc="Change the theme of the entire system"),
    Key([mod], "p", lazy.spawn(
        "playerctl -p 'spotify' play-pause"), desc="Toggle mpd"),
    Key([mod], "n", lazy.spawn("playerctl -p 'spotify' next"),
        desc="Change the music"),
    # Key([mod], "m", lazy.spawn(f"{terminal} -e ncmpcpp"), desc="Open music player"),
    Key([mod], "F2", lazy.spawn("playlist_mpd"), desc="playlist"),
    Key([mod], "F3", lazy.spawn(
        "wallpaper_cl.AppImage"), desc="wallpaper script"),
    Key([mod], "F4", lazy.spawn("prjs.sh"), desc="for fun"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "d", lazy.spawn(nav_app),
        desc="Spawn a command using a prompt widget"),
    Key([mod], "w", lazy.spawn(nav), desc="Browser window"),
    Key([mod], "c", lazy.spawn("config.sh"), desc="config files"),
    Key([mod], "z", lazy.spawn("dirop.sh"), desc="config files"),
    # Switch focus of monitors
    Key([mod], "period", lazy.next_screen(),
        desc='Move focus to next monitor'),
    Key([mod], "comma", lazy.prev_screen(), desc='Move focus to prev monitor'),

]

groups = [
    Group("1", layout='monadtall'),
    Group("2", layout='monadtall'),
    Group("3", layout='monadtall'),
    Group("4", layout='monadtall'),
    Group("5", layout='monadtall'),
    Group("6", layout='monadtall'),
    Group("7", layout='monadtall'),
    Group("8", matches=[Match(wm_class=["discord"])], layout='floating'),
]

dgroups_key_binder = simple_key_binder(mod)

#   DropDown

groups.append(
    ScratchPad("scratchpad", [
        DropDown("term", terminal, height=0.6, width=0.80, x=0.1, y=0.2),
        DropDown("pavucontrol", "pavucontrol",
                 height=0.6, width=0.80, x=0.1, y=0.2),
        DropDown("spotify", "spotify-launcher",
                 height=0.80, width=0.85, x=0.1, y=0.1),
        DropDown(explorer, explorer, height=0.6, width=0.80, x=0.1, y=0.2),
    ]),

)


layout_theme = {"border_width": 2,
                "margin": 8,
                "border_focus": colors["color13"],
                "border_normal": colors["color8"],
                }

layouts = [
    layout.Columns(border_focus_stack=[
                   colors["color1"], colors["color9"]], border_width=4),
    layout.MonadTall(**layout_theme),
    layout.Stack(num_stacks=2),
    layout.RatioTile(**layout_theme),
    layout.Floating(**layout_theme)
    # layout.Max(),
]

widget_defaults = dict(
    font=main_font,
    fontsize=14,
    padding=2,
    foreground=colors["background"],
)
extension_defaults = widget_defaults.copy()

# Widgets


def init_widgets_list():

    widgets_list = [
        widget.CurrentLayoutIcon(
            foreground=colors["color8"],
        ),
        widget.Spacer(
            length=3,
        ),
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
            inactive=colors["color8"],
            disable_drag=True,
            other_current_screen_border=colors["color5"],
            this_current_screen_border=colors["color1"],
        ),
        widget.Spacer(
            length=8,
        ),
        #   widget.Mpd2(
        #     foreground=colors["foreground"],
        #     play_states={'pause':'  ','play':'','stop':'  '},
        #     max_chars=80,
        #     status_format='{play_status} {title}',
        #     color_progress=colors["color9"],
        #     no_connection='   no connection',
        #
        # ),
        widget.Mpris2(
            name='spotify',
            objname="org.mpris.MediaPlayer2.spotify",
            foreground=colors["foreground"],
            format='{xesam:title} - {xesam:artist}',
            playing_text=' {track}',
            paused_text=' {track}',
            no_metadata_text='NO METADATA',
            scroll_chars=None,
            max_chars=80,
        ),
        widget.Spacer(),
        widget.TextBox(
            text="",
            padding=-2,
            fontsize=25,
            foreground=colors["color3"],
            background=colors["color3"],
        ),
        widget.Clock(
            format=" %H:%M",
            background=colors["color3"],
        ),
        widget.TextBox(
            text="",
            padding=-2,
            fontsize=25,
            foreground=colors["color3"],
            background=colors["color3"],
        ),
        widget.Spacer(),
        widget.Systray(),
        widget.Spacer(
            length=3,
            background=colors["background"],
        ),
        widget.TextBox(
            text="",
            padding=-2,
            fontsize=25,
            foreground=colors["color9"],
            background=colors["background"],
        ),
        widget.CheckUpdates(
            update_interval=800,
            no_update_string='No updates',
            # font='JetBrains Mono ExtraBold',
            display_format="󰃘 {updates} ",
            padding=5,
            background=colors["color9"],
            initial_text="Aguarde...",
            colour_have_updates=colors["foreground"],
            distro="Arch_checkupdates",
            mouse_callbacks={'Button1': lazy.spawn('chk_up'), 'Button3': lazy.spawn(
                terminal + ' -e sudo pacman -Syyu')},
        ),
        widget.TextBox(
            text="",
            padding=-2,
            fontsize=25,
            foreground=colors["color9"],
            background=colors["background"],
        ),

        widget.Spacer(
            length=3,
            background=colors["background"],
        ),

        widget.TextBox(
            text="",
            padding=-2,
            fontsize=30,
            foreground=colors["color6"],
            background=colors["background"],
        ),
        # widget.PulseVolume(
        #     background=colors["color6"],
        #     fmt='󰕾 {}',
        #     volume_down_command="pamixer -d 10",
        #     volume_up_command="pamixer -i 10",
        #     volume_app="pavucontrol",
        # ),
        widget.Volume(
            background=colors["color6"],
            emoji_list=['󰖁', '󰕿', '󰖀', '󰕾'],
            emoji=False,
            volume_app="pavucontrol",
            fmt='󰕾 {}',
        ),


        widget.TextBox(
            text="",
            padding=-2,
            fontsize=30,
            foreground=colors["color6"],
            background=colors["background"],
        ),
        widget.Spacer(
            length=3,
            background=colors["background"],
        ),
        widget.TextBox(
            text="",
            padding=-2,
            fontsize=30,
            foreground=colors["color2"],
            background=colors["background"],
        ),

        widget.Battery(
            background=colors["color2"],
            format='{char} {percent:2.0%}',
            charge_char='󰂄',
            discharge_char=' ',
            padding=2,

        ),

        widget.TextBox(
            text="",
            padding=-2,
            fontsize=30,
            foreground=colors["color2"],
            background=colors["background"],
        ),


    ]

    return widgets_list


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    del widgets_screen1[4]
    del widgets_screen1[9:19]
    return widgets_screen1


def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2


def init_screens():
    if monitor != '1':
        return [Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1.0, size=20, background=colors["background"])),
                Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=1.0, size=22, background=colors["background"]))]
    else:
        return [Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1.0, size=20, background=colors["background"]))]


screens = init_screens()

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

#   IDK
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_width=3,
    border_focus=colors["color2"],
    border_normal=colors["color0"],
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="pavucontrol"),  # gitk
        Match(wm_class="Thunar"),  # gitk
        Match(wm_class="wallpapercl"),  # gitk
        Match(wm_class="tk"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="Sxiv"),  # gitk
        Match(wm_class="feh"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="discord"),  # ssh-askpass
        Match(wm_class="spotify"),  # ssh-askpass
        Match(wm_class="Galculator"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"
