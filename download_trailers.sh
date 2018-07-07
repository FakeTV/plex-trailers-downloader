#!/bin/bash

cd /PATH/TO/TRAILERS/LIBRARY

#Download Movie Trailers
/usr/bin/python /home/USER/plex-preroll-trailers/download_preroll_trailers.py
#Download Netrlix Trailers
youtube-dl -f mp4 https://www.youtube.com/playlist?list=PLvahqwMqN4M0UXgBYznO18lSYjzRj-gT-
youtube-dl -f mp4 https://www.youtube.com/playlist?list=PLvahqwMqN4M1QEN4SyuXrgO3_Wf3p6gj3
#UPDATE TRAILERS LIBRARY IN PLEX
sudo su -l plex -s /bin/bash -c "LD_LIBRARY_PATH=/usr/lib/plexmediaserver PLEX_MEDIA_SERVER_APPLICATION$
#UPDATE PSEUDO CHANNEL COMMERCIALS DATABASE
#update-c.sh needs to be on controller device with commands to execute rescan of commercials database
ssh 'USER@<CONTROLLER_IP' sudo /home/USER/channels/updatedb-c.sh
exit
