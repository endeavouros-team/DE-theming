#bin/bash

echo "******* Installing EndeavourOS Theming for XFCE4 *******"

echo "******* Getting theme packages installed now: *******" && sleep 1
    sudo pacman -S arc-gtk-theme arc-x-icons-theme lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm --needed

echo "******* setting up theme for Light-DM: *******" && sleep 1
    wget -q --timeout=10 https://github.com/endeavouros-team/EndeavourOS-archiso/raw/master/airootfs/etc/lightdm/lightdm-gtk-greeter.conf
        sudo cp  lightdm-gtk-greeter.conf /etc/lightdm/
        rm lightdm-gtk-greeter.conf
        sudo systemctl -f enable lightdm

echo "******* cloning dotfiles for EndeavourOS - XFCE4 Theming *******" && sleep 1
    wget https://raw.githubusercontent.com/endeavouros-team/liveuser-desktop-settings/master/dconf/mousepad.dconf
    dbus-launch dconf load / < mousepad.dconf
    rm mousepad.dconf
    git clone https://github.com/endeavouros-team/endeavouros-xfce4-theming.git
    cd DE-theming
    rm -rf ~/.config/Thunar ~/.config/qt5ct ~/.config/xfce4 ~/.cache
    cp -R XFCE/. ~/
    cp XFCE/.config/user-dirs.conf ~/.config/
    cd ..
    rm -rf endeavouros-xfce4-theming 

echo "******* All Done --- restarting System NOW! *******"
echo "******* Please login again and enjoy EndeavourOS Theming! *******"

    yad --title="Restarting System" \
        --text="All done --- please login again and enjoy XFCE4 with EndeavourOS Theming!" \
        --width=400 --height=100 \
        --button="Restart System":0

    sudo systemctl reboot

}

Main "$@"
