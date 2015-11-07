#!/usr/bin/env bash
#===============================================================================
#
#          FILE: ytaudio
#         USAGE: ./ytaudio.sh <youtube_url> 
#   DESCRIPTION: A wrapper script for youtube-dl that rips audio from Youtube 
#                URLs into mp3 and optionally normalizes the audio
#       OPTIONS: 
#  REQUIREMENTS: youtube-dl, curl, lame, mplayer, normalize-audio
#         NOTES: 
#        AUTHOR: C Hawley
#       CREATED: 2015-10
#      REVISION: Fri 06 Nov 2015 08:00:41 PM EST
#
#===============================================================================

set -o nounset                               # Treat unset variables as an error

# Check for empty argument
if [ -z "${1:-}" ]; then
	arg="undefined"
	echo "You must provide an Youtube URL"
	echo "USAGE: ytaudio.sh <youtube_url>"
	exit 1
else
	yurl=$1
fi

# Check for lame encoder
if [ ! $(command -v lame) ]; then
	echo "Lame encoder not found.  Exiting"
	exit 1
fi

# Check for mplayer
if [ ! $(command -v mplayer) ]; then
	echo "Mplayer not found.  Exiting"
	exit 1
fi

# Check for youtube-dl
if [ ! $(command -v youtube-dl) ]; then
    if [ ! $(command -v curl) ]; then
	    echo "Curl not found.  Exiting"
	    exit 1
    fi
	echo "installing youtube-dl from https://rg3.github.io/youtube-dl/download.html"
	sudo curl https://yt-dl.org/downloads/2015.10.09/youtube-dl -o /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
fi

yfullfilename="%(title)s.%(ext)s"
yfilename="%(title)s"

yurl="$1"

youtube-dl -F "$yurl" | grep audio | sort
echo ""
read -p "Download from which format? (# on the left) " format
ycontainer=$(youtube-dl -F "$yurl" | grep "$format" | awk '{print $2}')
yfile=$(youtube-dl -f "$format" --get-filename -o "%(title)s.%(ext)s" "$yurl")
ytitle=$(youtube-dl -f "$format" --get-filename -o "%(title)s" "$yurl")
echo "------------------------------------------------------"
echo "Downloading "$ycontainer" audio from "$yurl""

youtube-dl -f "$format" -o "%(title)s.%(ext)s" "$yurl"

echo "Download done, converting "$ycontainer" to MP3"

mplayer -vo null -vc dummy -af resample=44100 -ao pcm:waveheader "$yfile" && lame -m j -h --vbr-new -b 160 audiodump.wav -o "$(basename "$ytitle").mp3"

# Normalize audio if normalize-audio installed
if [ $(command -v normalize-audio) ]; then
	normalize-audio --peak "$ytitle".mp3
else
	echo "normalize-audio not installed.  Not normalizing"
fi

echo "------------"
echo "Cleaning up."
rm -f audiodump.wav
rm -f "$yfile"
