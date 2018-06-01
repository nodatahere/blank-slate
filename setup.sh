#!/bin/bash

#add any and all additional repos
sudo add-apt-repository ppa:alessandro-strada/ppa; #adds oacmlfuse google drive client ppa
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90; #keyserver for spotify package
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list; #spotify repo
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -; #playonlinux keyserv
sudo wget http://deb.playonlinux.com/playonlinux_xenial.list -O /etc/apt/sources.list.d/playonlinux.list; #playonlinux repo
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -; #docker gpg key
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"; #add docker repo



#update all software
sudo apt update;
sudo apt upgrade -y;

#make sure all xfce4 plugins on my template system are installed on target system
sudo apt install -y xfce4-cpugraph-plugin xfce4-dict xfce4-indicator-plugin xfce4-mailwatch-plugin xfce4-netload-plugin xfce4-notes-plugin xfce4-places-plugin xfce4-power-manager-plugins xfce4-quicklauncher-plugin xfce4-sensors-plugin;
sudo apt install -y xfce4-systemload-plugin xfce4-verve-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin xfce4-diskperf-plugin xfpanel-switch;

sudo apt install python3; #make sure additional prereqs are installed

#install programs I use on all my systems
discordfile=/home/$USER/Downloads/discord-0.0.5.deb; #set this to the path of your discord .deb file which you downloaded previously because discord's site lacks a direct download link that one can wget

sudo apt install -y git google-drive-ocamlfuse spotify-client playonlinux steam vlc redshift redshift-gtk lshw-gtk libreoffice; #desktop programs
sudo apt install -y x11vnc ssh; #remote access programs

#programs that lack repos but have .deb files
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb; #because teamviewer is an ass to download
sudo dpkg -i teamviewer_amd64.deb; #seriously, teamviewer company, why can't you set up a repository?
sudo apt -f install -y; #because teamviewer deb doesn't call the dependencies properly
sudo dpkg -i $discordfile; #i also think discord should put up a repo
sudo apt -f install -y; #because dependencies always seem to have issues when installing from a .deb

#programs built from github
wget https://raw.githubusercontent.com/nodatahere/blank-slate/raw/master/gitprograms.sh -O /home/$USER/gitprograms.sh;
chmod +x /home/$USER/gitprograms.sh;
bash /home/$USER/gitprograms.sh;
rm /home/$USER/gitprograms.sh;

#create /storage
sudo mkdir /storage; #/storage is the mount point I use for extra internal drives, maintained as a folder of symlinks on my single-drive systems for consistency's sake
sudo chown -R $USER /storage/Google_Drive; #give user ownership of /storage

#set up grive to sync google google drive account at $drivefolder (default path /storage/Google_Drive, edit the line below this to change)
drivefolder=/storage/Google_Drive;
mkdir $drivefolder;
#create sync script in drive folder
echo "#!/bin/bash" >> $drivefolder/sync.sh;
echo "set -e" >> $drivefolder/sync.sh;
echo "#set folder to the path of your local google drive directory" >> $drivefolder/sync.sh;
echo "#authorize your Google Drive account with 'google-drive-ocamlfuse -label [label]" >> $drivefolder/sync.sh;
echo "mount=/storage/Google_Drive; \#mount point for the account" >> $drivefolder/sync.sh;
echo "label= ; \#set this to the label you set in the commented instructions" >> $drivefolder/sync.sh;
echo "function cleanup{" >> $drivefolder/sync.sh;
echo "    fusermount -u $mount;" >> $drivefolder/sync.sh;
echo "}" >> $drivefolder/sync.sh;
echo "trap cleanup EXIT" >> $drivefolder/sync.sh;
echo "google-drive-oacmlfuse -label $label $mount;" >> $drivefolder/sync.sh;
echo "echo \"Sync process started. Kill this process to Stop Sync.\";" >> $drivefolder/sync.sh;
echo "sleep infinity;" >> $drivefolder/sync.sh;

sudo chown -R $USER /storage;

#configure aliases
echo "drivesync='/storage/Google_Drive/sync.sh'" >> /home/$USER/.bash_aliases; #.bash_aliases file for all alias commands

#allow non-root user to use docker
sudo usermod -aG ${USER};

#update panel
wget https://raw.githubusercontent.com/nodatahere/blank-slate/master/panelset.sh -O /home/$USER/panelset.sh;
chmod +x /home/$USER/panelset.sh;
bash /home/$USER/panelset.sh;
rm /home/$USER/panelset.sh;

#update again and clean up
sudo apt update;
sudo apt upgrade;
sudo apt update;
sudo apt upgrade;
sudo apt autoremove;

#run ethersetup.sh from my EthDevTools repo
wget https://raw.githubusercontent.com/nodatahere/EthDevTools/master/ethersetup.sh -O /home/$USER/ethersetup.sh;
chmod +x ethersetup.sh;
bash /home/$USER/ethersetup.sh;
rm /home/$USER/ethersetup.sh;

exit;
