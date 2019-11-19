#!/bin/bash

# EndeavourOS Theming installer
#
# Usage: $0 <DE-name>

Debug() {
    case "$DEBUGGING" in
        [yY]* | 1 | true | enable* | on) echo "$@" >&2 ;;
    esac
}

Dexe() {          # debug and execute
    Debug "$1"
    $1
}

MSG() {
    local title="$1"
    local text="$2"
    yad --title="$title" --text="$text" \
        --width=500 --height=100 --button=yad-quit:0
}

DIE() {
    MSG "Error" "$progname: $1"
    test -n "$workdir" && rm -rf $workdir
    exit 1
}

UserFiles_XFCE()
{
    local mousepaddconf=https://github.com/endeavouros-team/liveuser-desktop-settings/raw/master/dconf/mousepad.dconf
    Dexe "wget -q --timeout=10 $mousepaddconf" || DIE "sorry, unable to fetch mousepad.dconf."
    Dexe "rm -f ~/.config/dconf/user"
    Dexe "rm -rf ~/.config/Thunar ~/.config/qt5ct ~/.config/xfce4 ~/.cache"
    Dexe "cp -R $dotfiles_dirname/XFCE/. ~/"
    Debug "dconf load / < mousepad.dconf"
    dconf load / < mousepad.dconf
    # dbus-launch dconf load / < mousepad.dconf   # why this ???
}

UserFiles_CINNAMON()
{
    rm -f ~/.config/dconf/user
    rm -rf ~/.cinnamon ~/.fontconfig ~/.icons ~/.local/share/cinnamon
    cp -R $dotfiles_dirname/CINNAMON/. ~/
    dconf load / < $dotfiles_dirname/cinnamon.dconf
}

Main() {
    local DE="$1"
    local DEBUGGING=no
    test "$DE" = "XFCE" && DEBUGGING=yes                 # TODO: remove this line !!!
    local progname="eos-theming.sh"
    case "$DE" in
        XFCE | CINNAMON) ;;
        "") DIE "give desktop name (one of: XFCE, CINNAMON)." ;;
        *) DIE "unsupported desktop '$DE'" ;;
    esac
    local dotfiles_dirname=DE-theming
    local dotfiles=https://github.com/endeavouros-team/$dotfiles_dirname.git
    local greeter=https://github.com/endeavouros-team/EndeavourOS-archiso/raw/master/airootfs/etc/lightdm/lightdm-gtk-greeter.conf
    local greeterfile=$(basename $greeter)
    local packages=()
    local required_pkgs=(
        arc-gtk-theme
        arc-x-icons-theme
        lightdm
        lightdm-gtk-greeter
        lightdm-gtk-greeter-settings
    )
    local sudo_cmds=":"            # initial command does nothing!
    local workdir=$(mktemp -d)
    local xx

    ## Common sudo commands:

    # Check which of the required packages is not installed.
    for xx in "${required_pkgs[@]}" ; do
        pacman -Q $xx >& /dev/null || packages+=("$xx")
    done

    pushd $workdir >/dev/null           # do everything here at temporary folder

    echo "Fetching $DE theming files."
    Dexe "wget -q --timeout=10 $greeter"       || DIE "sorry, unable to fetch $greeterfile."

    Debug "git clone $dotfiles"
    git clone $dotfiles >& /dev/null           || DIE "sorry, unable to fetch theming dotfiles."

    # Now we have all the required files.

    if [ -n "$packages" ] ; then
        sudo_cmds+="; pacman -S ${packages[*]} --noconfirm >& /dev/null"      # install required packages
    fi
    diff $greeterfile /etc/lightdm/$greeterfile >& /dev/null || {
        sudo_cmds+="; cp $PWD/$greeterfile /etc/lightdm/"                     # put greeter in place
    }
    if [ ! -d /usr/share/endeavouros ] ; then
        sudo_cmds+="; mkdir -p /usr/share/endeavouros"                        # make sure folder exists
    fi
    for xx in $PWD/$dotfiles_dirname/endeavouros/* ; do
        diff $xx /usr/share/endeavouros >& /dev/null || {
            sudo_cmds+="; cp $xx /usr/share/endeavouros"                      # put pictures in place
        }
    done

    ## DE specific sudo commands:

    case "$DE" in
        XFCE)
            sudo_cmds+="; chmod 0644 /usr/share/endeavouros/*.png"
            sudo_cmds+="; rm -f /usr/share/backgrounds/xfce/xfce-stripes.png"
            sudo_cmds+="; ln -s /usr/share/endeavouros/endeavouros-wallpaper.png /usr/share/backgrounds/xfce/xfce-stripes.png"
            ;;
    esac

    ## Now run all sudo commands:

    if [ -n "$sudo_cmds" ] ; then
        echo "Installing system files."
        Debug "su -c \"$sudo_cmds\""
        su -c "$sudo_cmds"
    fi

    ## DE specific user commands:

    echo "Installing $DE user files."
    case "$DE" in
        XFCE)     UserFiles_XFCE ;;
        CINNAMON) UserFiles_CINNAMON ;;
    esac

    popd >/dev/null

    # cleanup
    rm -rf $workdir

    echo "All done -- you must reboot now to have the default EndeavourOS $DE Theming!"
}

Main "$@"
