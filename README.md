# Narration Video Maker
 Makes narration videos in a few clicks



I do a lot of voice narration of poetry and other sorts.  Decide to semi-automate it.  Only need to do audio recordings, then this script grabs each recording, finds random old GoPro footage, adds music, narration, and intro and outro animations.  It then creates a folder with it's thumbnail, final video, and raw audio.


Preqresites:
1.  Place all audio recordings (titled correctly with the piece) and put into "Input" folder
2.  Place your music catalogue into "Music" folder
3.  Place your into and outro videos into the "Intro-Outro" folder
4.  Place your photo archive into "Thumbnails" photo
5.  Place all raw footage material into "VideoSources" folder.
6.  Adjust filenames accordingly in the script (i.e. intro.mov and outro.mov)

To run, use create.sh as nonadmin.

What this script does in detail:
Uses the title of the audio file to create an output subfolder.  Checks the length, and finds old footage longer than that length, and it grabs a subset of equal length.  It then finds music that is long enough for that narration from your music catalogue.  It remuxes them into the new video piece, and it also adds the intro and outro video caps to the new video.  It places it all into the output subfolder with the original audio separately for records, and it also grabs a random photo from the photo archive and makes sure it is thumbnail dimensions.  The folder then is complete.