EndeavourOS theming files and scripts for all the different DE's
# Only for testing purpose not for real use!

If you want to install original EndeavouOS xfce4 with theming you can do this like this:

``
wget https://raw.githubusercontent.com/endeavouros-team/DE-theming/master/xfce4-packages-list
sudo pacman -S --needed - < xfce4-packages.list
wget https://raw.githubusercontent.com/endeavouros-team/DE-theming/master/xfce.sh
sh xfce.sh
``
