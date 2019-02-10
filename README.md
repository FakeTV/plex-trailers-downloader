# Plex-Trailers-Downloader
A set of scripts to automatically download new movie trailers and other videos, and add them to your Plex library

## Why
For use in seeding Pseudo Channel with fresh commercials to be mixed in between scheduled programming

## Requirements
The heart of the scripts is written in python, so they can work on all platform that have python installed. However there are 2 bash script for Linux/Ubuntu, but they are so simple that can be adapted for other OS.

 - Python 2.x
 - [tmdbsimple](https://github.com/celiao/tmdbsimple/blob/master/README.rst)
```
pip install tmdbsimple
```
 - TheMovieDB API key
 - [youtube-dl](https://github.com/rg3/youtube-dl/blob/master/README.md#installation)
```
sudo -H pip install --upgrade youtube-dl
```
 - FFmpeg
## How it works
The script ***download_preroll_trailers.py*** connect to TheMovieDB.org, select a user defined numbers of movies that, for your country, **are in theaters or are upcoming**, orders them by popularity and **download from YouTube** the **trailers** associated (retrieved from TheMovieDB API), write a JSON file with the filenames of the downloaded trailers.

The script ***mix_preroll_trailers.py*** load from the JSON file the filenames of the downloaded trailers, select randomly a user defined number of trailers to play within Plex and create a text file with the selected number of videos.

The script ***concat_preroll_trailers.sh***  takes the chosen videos from the text file and merge them with FFmpeg.

The script ***download_preroll_trailers.sh*** simply remove the old downloaded videos and execute the *download_preroll_trailers.py*.

## Settings
Edit the *config.ini* file, see comments in file.

## Usage
- *Clone* and *cd* to the repository directory
- `sudo chmod +x *.sh`
- ``` crontab -e ``` for add the bash scripts to *CRON*. Personally i use:

 `0 3 * * fri path/to/download_preroll_trailers.sh  # once a week download trailers`

 `30 3 * * * /path/to/concat_preroll_trailers.sh     # once a day mix the trailers that will be played into Plex.`
- Go to *Plex Settings > Server > Extras* click on the *Show Advanced* and into *"Cinema Trailers pre-roll video"* set */path/to/plex-preroll-trailers/preroll_trailers.mp4*
- Enable in the Plex clients the option to show trailer.
