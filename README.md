<img style="float:right; padding 0px 0px 10px 10px;" alt="linux" src="http://i.imgur.com/DhIX0Vn.png"</img>
# ytaudio

Created: Fri 06 Nov 2015 08:04:58 PM EST

Updated: Fri 06 Nov 2015 08:19:31 PM EST

## Summary

This is a Linux shell script that uses youtube-dl to rip just the audio from youtube videos into mp3 format.

REQUIREMENTS: youtube-dl (which requires python), curl, lame, mplayer, normalize-audio

USAGE:

    ./ytaudio.sh <youtube_url>

The script will then go out and grab the available audio containers from the video.  Choose the one you want to convert
(HINT: I try to pick the highest bitrate audio format - usually 141).  

It will then download the audio, convert it to VBR MP3 and normalize it.

I tried to have the script check that all available programs are installed (except youtube-dl itself, which the script
will grab and install for you (sudo required) if you don't have it)

If you don't have one of the required apps, the script will tell you and fail.  

Typically, installing the required programs are as easy as:

    sudo apt-get install curl mplayer lame normalize-audio

if you're using Debian/Ubuntu.  Use your local package manager if you're using something else.

---

TODO: figure out how to deal with URLs with no suitable audio formats

---

## Reference(s):

Thanks to the creators of [youtube-dl](https://rg3.github.io/youtube-dl/) for the awesome utility!
