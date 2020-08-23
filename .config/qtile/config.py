#   Imports
import psutil
import os
from libqtile.config import Key, Screen, Group, Drag, Click, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile import layout, bar, widget
import subprocess
from libqtile import hook
from typing import List  # noqa: F401

#   Variables
mod = "mod4"
term = "st"
home = os.path.expanduser('~')
nav = "xdg-open http://"

#   Colors
bg_bar='#002b36'
border_focused='#50fa7b'
border_else='#2e2e2e'
bg_widgets='#282828'
bg_workspaceat='#458588' #blocks

#   Keybinds
keys = [
    #   Manage windows (monadtall)
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod], "h", lazy.layout.grow(),lazy.layout.increase_nmaster()),
    Key([mod], "l", lazy.layout.shrink(),lazy.layout.decrease_nmaster()),
    Key([mod], "b", lazy.layout.normalize()),
    Key([mod], "o", lazy.layout.maximize()),
    Key([mod], "space", lazy.layout.flip()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod],"f",lazy.window.toggle_fullscreen()),
    #   Change monitor focus
    Key([mod],"period",lazy.next_screen()),
    Key([mod],"comma",lazy.prev_screen()),
    #   terminal
    Key([mod], "Return", lazy.spawn(term)),
    #   Change layout
    Key([mod], "Tab", lazy.next_layout()),
    #   Qtile control
    Key([mod, "mod1"], "r", lazy.restart()),
    Key([mod, "mod1"], "q", lazy.shutdown()),
    #   Spawn apps
    Key([mod], "d", lazy.spawn("dmenu_run -h 22 -p 'Run:'")),
    Key([mod],"c",lazy.spawn(term+" -e ncmpcpp")),
    Key([mod],"a",lazy.spawn(term+" -e vifm")),
    Key([mod],"e",lazy.spawn("code")),
    Key([mod],"w",lazy.spawn(nav)),
    Key(["control","mod1"],"t",lazy.spawn(home + "/.config/dmenu-scr/config.sh")),
    Key([],"F1",lazy.spawn(home + "/.config/dmenu-scr/power.sh")),
    Key([mod],"r",lazy.spawn(home + "/.config/dmenu-scr/screenshot.sh")),
    #   Media control
    Key([],"F11",lazy.spawn("amixer set Master 5%-")),
    Key([],"F12",lazy.spawn("amixer set Master 5%+")),
    Key([mod],"p",lazy.spawn("mpc toggle")),
    Key([mod],"n",lazy.spawn("mpc next")),
    #   Xbacklight
    Key([],"F8",lazy.spawn("xbacklight -dec 10")),
    Key([],"F9",lazy.spawn("xbacklight -inc 10")),
]

#   Workspaces
group_names = '1 2 3 4 5 6 7 8'.split()

groups = [Group(name, layout='monadtall') for name in group_names ]
for i, name in enumerate(group_names):
    indx = str(i + 1)
    keys += [
        Key([mod], indx, lazy.group[name].toscreen()),
        Key([mod, 'shift'], indx, lazy.window.togroup(name))]


def scrathterm():
    ScratchPad("scratchpad", [
            DropDown("term", "urxvt", opacity=0.8),
            DropDown("qshell", "urxvt -hold -e qshell",
                     x=0.05, y=0.4, width=0.9, height=0.6, opacity=0.9,
                     on_focus_lost_hide=True) ]),


layout_default = {
        "border_focus":  border_focused,
        "border_normal": border_else,
        "border_width": 3,
        "margin": 6
        }

#   Layouts
layouts = [
    layout.MonadTall(**layout_default),
    layout.MonadWide(**layout_default),
]

#   Widget default config
widget_defaults = dict(
    font='JetBrains Mono',
    fontsize=13,
    padding=2,
    background=bg_bar
)
extension_defaults = widget_defaults.copy()
simbolo='-'

#   Widgets
def init_widgets_list():
      widget_list = [
                widget.GroupBox(highlight_method='block',hide_unused=False,this_current_screen_border=bg_workspaceat,inactive='#bdae93',backgound=bg_widgets,this_screen_border='#2F4F4F'),
                widget.TextBox("|",padding=4,backgound=bg_widgets),
                widget.WindowName(for_current_screen=True),
                widget.TextBox("|",padding=4,backgound=bg_widgets),
                
                widget.TextBox("",padding=4,backgound=bg_widgets),
                widget.Pacman(backgound=bg_widgets,update_interval= 1800,execute=term),
                  
                widget.Sep(linewidth=0,padding=4),
                widget.TextBox(simbolo,padding=3,),
                
                widget.TextBox("VOL",padding=4,backgound=bg_widgets),
                widget.Volume(backgound=bg_widgets,volume_down_command='amixer set Master 5%-',volume_up_command='amixer set Master 5%+'),
                
                widget.Sep(linewidth=0,padding=4),
                widget.TextBox(simbolo,padding=3),
                
                widget.TextBox("",padding=4,backgound=bg_widgets),
                widget.CurrentLayout(padding=4,backgound=bg_widgets),
                
                widget.Sep(linewidth=0,padding=4),
                widget.TextBox(simbolo,padding=3),
                
                widget.TextBox("",padding=4,backgound=bg_widgets),
                widget.Clock(format='%a %I:%M %p',backgound=bg_widgets),
                widget.Systray(backgound=bg_widgets),
                ]
      return widget_list

#   Send widgets to multiple monitors
def init_widgets_screen1():
    widget_screen1=init_widgets_list()
    return widget_screen1

def init_widgets_screen2():
    widget_screen2=init_widgets_list()
    return widget_screen2

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=0.95, size=20))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

#   General config
auto_fullscreen = True
focus_on_window_activation = "smart"
dgroups_key_binder = None
main = None
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
dgroups_app_rules = []  #window rules

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
    {'wmclass':'mpv'},
    {'wmclass':'Lxpolkit'},

])


#   Autostart
# @hook.subscribe.startup_once
# def autostart():
#     home = os.path.expanduser('~/.config/qtile/autostart.sh')
#     subprocess.call([home])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
