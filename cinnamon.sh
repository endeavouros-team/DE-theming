#bin/bash
echo "******* Getting theme packages installed now: *******" && sleep 1
sudo pacman -S arc-gtk-theme arc-x-icons-theme --noconfirm --needed
echo "******* setting up theme for Light-DM: *******" && sleep 1
wget https://raw.githubusercontent.com/endeavouros-team/EndeavourOS-archiso/master/airootfs/etc/lightdm/lightdm-gtk-greeter.conf
sudo cp lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
rm lightdm-gtk-greeter.conf
echo "******* cloning dotfiles for EndeavourOS - Cinnamon Theming *******" && sleep 1
git clone https://github.com/r2d2-joe/dotfiles.git
cd dotfiles
sudo cp -R endeavouros /usr/share/
rm -R ~/.cinnamon ~/.fontconfig ~/.icons ~/.local/share/cinnamon
rm ~/.config/dbus/user
cp -R CINNAMON/. ~/
dconf load / <cinnamon.dconf
cd ~/
sudo rm -R dotfiles
echo "******* All Done --- restarting Desktop Manager *******" && sleep 1
echo "******* Please login again and enjoy EndeavourOS Theming! *******" && sleep 3
sudo systemctl restart lightdm
