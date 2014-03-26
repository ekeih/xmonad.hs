# My xmonad.hs

## Introduction
After several years with awesome I switched to xmonad to try something new. And I love it. In my humble opinion it is much more awesome than awesome itself. But thats a matter of taste.

My configuration creates 18 workspaces in two rows. You can use Win+[1-9] to use the first row and Win+F[1-9] for the second one. You can also use Win+<Arrow-Keys> to move between workspaces in this grid.

This configuration does not provide a statusbar like xmobar or dzen2, instead the complete space is used by your windows. But it should be easy to add a statusbar, just check the xmonad website or other example configurations.

I also don't use a tray. If you need one you could try trayer or stalonetray.

I use the keybinding Win+s to access information that is usually provided by a statusbar or a tray. It spawns a dmenu with some shortcuts. Check ~/.xmonad/data/bin/menu for more information.


## Requirements (testet version)
* xmonad (0.11)
* xmonad-contrib (0.11.2)

## Used software
You don't need them to use my configuration but some keybindings and scripts depend on them.
* dmenu - a great menu to run commands
* i3lock - used to lock my screen
* urxvt - a terminal emulator
* terminator - a terminal emulator with support for tabs and tiling
* geany - a small graphical editor
* pcmanfm - a graphical file browser
* autorandr - automatic save and restore for monitor setups
* feh - set a desktop background
* scrot - a screenshot utility
* imagemagick - command line tool to manipulate images

### Install requirements on Archlinux
```bash
pacman -S xmonad xmonad-contrib
```

## Installation
    cd
    mv .xmonad .xmonad.bck
    git clone https://github.com/ekeih/xmonad.hs.git .xmonad

* Edit ~/.xmonad/xmonad.hs. Set confHomeDir = "/home/ekeih/" to your home directory.
* May adjust confTerminal.
* Explore the xmonad.hs file and scripts in ~/.xmonad/data/bin/ and adjust paths and stuff to your needs.
* Configure your loginmanager to start xmonad at login.
* Logout.
* Login.
* Press Win+Return to open a terminal.

If you never used a slim window manager before it will be some kind of shock. But give it a try. Over time it will give you an incredible customized configuration that fits your workflow better than every traditional environment could ever do.
