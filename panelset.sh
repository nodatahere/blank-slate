#!/bin/bash

#update panel
panel_archive=/home/$USER/Panel_Arrangement.tar.bz2; #path to the panel config archive
wget https://github.com/nodatahere/blank-slate/raw/master/Panel_Arrangement.tar.bz2 $panel_archive; #download panel config archive
python3 /usr/share/xfpanel-switch/xfpanel-switch/panelconfig.py save /home/$USER/Panel_Backup.tar.bz2; #back up panel settings
python3 /usr/share/xfpanel-switch/xfpanel-switch/panelconfig.py load $panel_archive; #load panel config from downloaded archive

exit;
