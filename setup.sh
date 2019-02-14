#!/bin/bash

echo "Setting up the Plex Trailers Downloader"
#download python, youtube-dl, and tmdbsimple
echo "Downloading dependencies"
sudo apt-get install python
sudo -H pip install --upgrade youtube-dl
sudo pip install tmdbsimple
#enter The Movie Database API key
echo "To use the Plex Trailers Downloader, you will need an API key from The Movie Database."
echo "Follow these instructions to get an API key before continuing: https://developers.themoviedb.org/3/getting-started/introduction"
read -p "TMDB API KEY: " tmdb_api_key
#enter other user options
echo "Enter the maximum number of trailers to download"
read -p "Max number of trailers: " max_trailers
#confirm or change region settings
echo "Default region/language is United States English, you can either keep this or select a different region and language"
options="Keep Change"
select region_default in $options; do
	if [ "$region_default" == "Keep" ]; then
	language="en"
	region="US"
	query_region="usa"
	echo "Region and Language set to United States English"
	elif [ "$region_default" == "Change" ]; then
		echo "Enter the ISO 639-1 Language Code for the desired language https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes"
		read -p "ISO 639-1 Language Code: " language
		echo "Enter the ISO 3166-1 two character Region Code (for relese date queries) https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes"
		read -p "ISO 3166-1 Region Code (uppercase only): " region
		echo "Enter the ISO 3166-1 three character country name (for localized trailers)"
		read -p "3-Character Country Name: " query_region
		echo "Trailer language set to $language, region is $region and $query_region."
	else
		clear
		echo "Default region/language is United States English, you can either keep this or select a different region and language."
	fi
break
done
#enter directory path
echo "Enter the directory path of your movie trailers library (example: /mnt/drive/movie-trailers)"
read -p "Movie Trailers Directory: " trailers_dir
#write to script and config
sudo echo -e "[main]\ntmdb_api_key = $tmdb_api_key\n\n# Pass a ISO 639-1 value to display translated data for the fields that support it.\nlanguage = $language\n\n# Specify a ISO 3166-1 code to filter release dates. Must be uppercase.\nregion = $region\n\n# a string to append at the query for searching localized trailer. ie: \"<movie name> + trailer + <ita>\"\nquery_region = $query_region\n\n[trailer]\n# max number of trailers to download.\nmax_trailers = $max_trailers\n\n#legacy variable\nquantity = 3" > config.ini
sudo echo -e "#!/bin/bash" > download_trailers.sh
sudo echo -e "cd $trailers_dir" >> download_trailers.sh
sudo echo -e "/usr/bin/python $PWD/download_preroll_trailers.py" >> download_trailers.sh
#prompt to add custom playlist
echo "Add a YouTube channel or playlist to the weekly download queue?"
read -p "Y/N: " add_youtube
while [[ "$add_youtube" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
	do
	echo "Add a YouTube channel or playlist to the weekly download queue?"
	read -p "Y/N: " add_youtube
	done
while [[ "$add_youtube" == @(Y|y|Yes|yes|YES) ]]
	do
	#set download directory
	echo "Enter full watch directory path of desired Plex library (example: /mount/drive/commercials"
	read -p "Library Directory: " library_path
	#ask for link to youtube playlist
	echo "Paste a direct link to the desired YouTube channel or playlist."
	read -p "YouTube channel or playlist link: " youtube_link
	#check for 7 day limit
	echo "Restrict download videos to those uploaded within the last 7 days?"
	read -p "Y/N: " seven_day_limit
	while [[ "$seven_day_limit" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
			echo "Only download videos uploaded within the last 7 days?"
			read -p "Y/N: " seven_day_limit
		done
	#write to script
		echo -e "cd $library_path" >> download_trailers.sh
		if [[ "$seven_day_limit" != @(Y|y|Yes|yes|YES) ]]
			then
			echo -e "timeout --foreground 5m /usr/local/bin/youtube-dl -i -f mp4 --restrict-filenames --dateafter today-7days $youtube_link" >> download_trailers.sh
		else
			echo -e "/usr/local/bin/youtube-dl -f mp4 --restrict-filenames $youtube_link" >> download_trailers.sh
		fi
	#ask to do again (loop)
		echo "Add another YouTube channel or playlist to the weekly download queue?"
		read -p "Y/N: " add_youtube
		while [[ "$add_youtube" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
			echo "Add another YouTube channel or playlist to the weekly download queue?"
			read -p "Y/N: " add_youtube
		done
	done
#force plex rescan
sudo su -l plex -s /bin/bash -c "LD_LIBRARY_PATH=/usr/lib/plexmediaserver PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR='/var/lib/plexmediaserver/Library/Application Support' /usr/lib/plexmediaserver/Plex\ Media\ Scanner --scan --refresh"
#get pseudo channel info
#run pseudo channel rescan
echo "exit" >> download_trailers.sh
exit
