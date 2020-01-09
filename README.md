EndeavourOS theming files and scripts for all the different DE's
# Only for testing purpose not for real use!

![xfce4-endeavouros.png](https://raw.githubusercontent.com/endeavouros-team/DE-theming/master/xfce4-endeavouros.png)
If you want to install original EndeavourOS xfce4 with theming you can do it like this:


`wget https://raw.githubusercontent.com/endeavouros-team/DE-theming/master/xfce4-packages-list`

`sudo pacman -S --needed - < xfce4-packages.list`

`wget https://raw.githubusercontent.com/endeavouros-team/DE-theming/master/xfce.sh`

`sh xfce.sh`

After rebooted and you see a working theming you must remove this file:


**~/.config/user-dirs.conf** --> as it will give issues on changing theme or if you want to set back to some default setting.

`rm ~/.config/user-dirs.conf`


