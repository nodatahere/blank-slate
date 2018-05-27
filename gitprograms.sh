#!/bin/bash

git clone https://github.com/Bionus/imgbrd-grabber.git /home/$USER/imgbrd-grabber; #imageboard browser program, danbooru, etc
/home/$USER/imgbrd-grabber/build.sh; #build imgbrd-grabber
sudo ln -s /home/$USER/imgbrd-grabber/release/Grabber /usr/bin/imgbrd-grabber; #let grabber be run globally

exit;
