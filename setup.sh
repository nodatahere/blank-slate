#!/bin/bash

#add any and all additional repos
sudo add-apt-repository ppa:nilarimogard/webupd8; #ppa for grive google drive sync program
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410; #keyserver for spotify package
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list; #spotify repo
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -; #playonlinux keyserv
sudo wget http://deb.playonlinux.com/playonlinux_xenial.list -O /etc/apt/sources.list.d/playonlinux.list; #playonlinux repo

#update all software
sudo apt update;
sudo apt upgrade -y;

#make sure all xfce4 plugins on my template system are installed on target system
sudo apt install -y xfce4-cpugraph-plugin xfce4-dict xfce4-indicator-plugin xfce4-mailwatch-plugin xfce4-netload-plugin xfce4-notes-plugin xfce4-places-plugin xfce4-power-manager-plugins xfce4-quicklauncher-plugin xfce4-sensors-plugin;
sudo apt install -y xfce4-systemload-plugin xfce4-verve-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin xfce4-diskperf-plugin

#install programs I use on all my systems
discordfile=/home/$USER/discord-0.0.4.deb; #set this to the path of your discord .deb file which you downloaded previously because discord's site lacks a direct download link that one can wget
sudo apt install -y git grive spotify playonlinux steam; #desktop programs
sudo apt install -y x11vnc ssh; #remote access programs

#programs that lack repos but have .deb files
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb; #because teamviewer is an ass to download
sudo dpkg -i teamviewer_amd64.deb; #seriously, teamviewer company, why can't you set up a repository?
sudo apt -f install -y; #because teamviewer deb doesn't call the dependencies properly
sudo dpkg -i $discordfile; #i also think discord should put up a repo
sudo apt -f install -y; #because dependencies always seem to have issues when installing from a .deb

#programs built from github
git clone https://github.com/Bionus/imgbrd-grabber.git /home/$USER/imgbrd-grabber; #imageboard browser program, danbooru, etc
/home/$USER/imgbrd-grabber/build.sh; #build imgbrd-grabber
sudo ln -s /home/brenden/imgbrd-grabber/release/Grabber /usr/bin/imgbrd-grabber; #let grabber be run globally

#create /storage
sudo mkdir /storage; #/storage is the mount point I use for extra internal drives, maintained as a folder of symlinks on my single-drive systems for consistency's sake
sudo chown -R $USER /storage/Google_Drive; #give user ownership of /storage

#set up grive to sync google google drive account at $drivefolder
drivefolder=/storage/Google_Drive;
mkdir $drivefolder;
#create sync script in drive folder
echo "#!/bin/bash" >> $drivefolder/sync.sh;
echo "#set folder to the path of your local google drive directory" >> $drivefolder/sync.sh;
echo "folder=/storage/Google_Drive;" >> $drivefolder/sync.sh;
echo "logname=$(hostname -f).log;" >> $drivefolder/sync.sh;
echo "logfile=$folder/$logname;" >> $drivefolder/sync.sh;
echo "echo \"Log file at \" $logfile;" >> $drivefolder/sync.sh;
echo "grive -P -p $folder -d -l $logfile;" >> $drivefolder/sync.sh;
echo "echo \"Log file at \" $logfile;" >> $drivefolder/sync.sh;
echo "sleep 5;" >>  $drivefolder/sync.sh;
echo "grive -P -p $folder;" >> $drivefolder/sync.sh;
echo "exit;" >> $drivefolder/sync.sh;
grive -a -p $drivefolder; #generate config files for grive


#configure aliases
echo "drivesync= '/storage/Google_Drive/sync.sh'" >> .bash_aliases;

#update panel
panel_archive=/home/$USER/Panel_Arrangement.tar.bz2; #path to the panel config archive
wget https://github.com/nodatahere/blank-slate/raw/master/Panel_Arrangement.tar.bz2 $panel_archive; #download panel config archive
tar cvfz /home/$USER/panel_backup.tgz /home/$USER/.config/xfce4/panel; #back up panel settings
rm -rf /home/$USER/.config/xfce4/panel/*; #wipe panel config directory
tar xvjC /home/$USER/.config/xfce4/panel -f $panel_archive; #extract new config
xfce4-panel -r; #restart panel to apply changes

#run ethersetup.sh from my LazyDevTools repo
xfce4-terminal -e "curl https://raw.githubusercontent.com/nodatahere/EthDevTools/master/ethersetup.sh | bash";

#update again and clean up
sudo apt update;
sudo apt upgrade;
sudo apt update;
sudo apt upgrade;
sudo apt autoremove;
exit;
