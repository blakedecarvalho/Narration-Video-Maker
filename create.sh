for i in /Input/*
do
	AUDIO=$i
	AUDIOEXTENSION=$(basename "$AUDIO")
	AUDIONAME="${AUDIOEXTENSION%.*}"
	echo "the audio name is $AUDIONAME"
	AUDIOLENGTHfloat=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$AUDIO" )
	AUDIOLENGTH=$((${AUDIOLENGTHfloat%.*} + 1))
	echo "Audio length of recording is ${AUDIOLENGTH} seconds"
	VIDEO=$(find "/VideoSources" -type f \( -iname "*.mp4" -o -iname "*.mov" \) -not -iname "*._*" | shuf -n 1)
	echo "Video is ${VIDEO}"
	VIDEOLENGTHfloat=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${VIDEO}")
	VIDEOLENGTH=$((${VIDEOLENGTHfloat%.*} + 1))
	echo "Video length is ${VIDEOLENGTH} seconds"
	while [[ $AUDIOLENGTH -gt $VIDEOLENGTH ]]
		do
			echo "Video found is too short for audio, searching for another..."
			VIDEO=$(find "VideoSources" -type f \( -iname "*.mp4" -o -iname "*.mov" \) -not -iname "*._*" | shuf -n 1)
			VIDEOLENGTHfloat=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${VIDEO}")
			VIDEOLENGTH=$((${VIDEOLENGTHfloat%.*} + 1)) 
		done
	echo "Found long enough video, which is ${VIDEO} at a length of ${VIDEOLENGTH} seconds"
	echo "Making main video"
	START=$(( $VIDEOLENGTH - $(( $RANDOM % $(( $VIDEOLENGTH - $AUDIOLENGTH )) + $AUDIOLENGTH )) ))
	echo "Start is $START"
	mkdir "/Output/${AUDIONAME}"
	ffmpeg -ss $START -i "$VIDEO" -i "$AUDIO" -t $AUDIOLENGTH -filter_complex [0:v]scale=-2:720[Scaled] -map [Scaled] -map 1:a -c:a aac -b:a 256k "./Staging/center.mp4" -y
	sleep 2
	echo "Adding Intro and Outro"
	ffmpeg -i "/Intro-Outros/intro.mov" -i "./Staging/center.mp4" -i "/Intro-Outros/outro.mov" \
	-filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0]concat=n=3:v=1:a=1[outv][outa]" \
	-map "[outv]" -map "[outa]" ./Staging/capped.mp4 -y
	sleep 2
	echo "Adding music "
	MUSIC=$(find "/Music" -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -not -iname "*._*" | shuf -n 1)
	MUSICLENGTHfloat=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${MUSIC}")
	MUSICLENGTH=$((${MUSICLENGTHfloat%.*} + 1))
	echo "Music length is ${MUSICLENGTH} seconds"
	while [[ $AUDIOLENGTH -gt $(( $MUSICLENGTH + 5 )) ]]
		do
			echo "Video found is too short for audio, searching for another..."
			MUSIC=$(find "music" -type f \( -iname "*.mp3" -o -iname "*.m4a" \) -not -iname "*._*" | shuf -n 1)
			MUSICLENGTHfloat=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${MUSIC}")
			MUSICLENGTH=$((${MUSICLENGTHfloat%.*} + 1))
		done
	ffmpeg -i ./Staging/capped.mp4 -itsoffset 00:00:05 -i "${MUSIC}" \
	-filter_complex "[0:a][1:a]amix=weights='4 0.25':duration=shortest[a]" -map 0:v -map "[a]" \
	-c:v copy -async 1 "./Output/${AUDIONAME}/${AUDIONAME}.mp4" -y
	ffmpeg -i /Thumbnails/$((RANDOM%33649+1)).jpg -vf scale=1280:720 "./Output/${AUDIONAME}/${AUDIONAME}cover.jpg" -y
	echo "cover thumbnail created"
	sleep 2
	echo "moved thumbnail image into correct spot"
	sleep 2
	echo "Cleaning up"
	mv "${AUDIO}" "./Output/${AUDIONAME}/${AUDIONAME}.mp3"
	echo "All done.  Enjoy the show."
done
