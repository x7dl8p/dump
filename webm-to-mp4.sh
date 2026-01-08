webm-to-mp4.sh

VIDEOS_DIR="$HOME/Videos/Screencasts"
NOTIFY_TIMEOUT=5000

LATEST_WEBM=$(find "$VIDEOS_DIR" -maxdepth 1 -name "*.webm" -type f -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)

if [ -z "$LATEST_WEBM" ]; then
    notify-send "Not Found" "No WebM files found in Videos folder" -t $NOTIFY_TIMEOUT -u normal
    exit 1
fi

FILENAME=$(basename "$LATEST_WEBM" .webm)
OUTPUT_MP4="${VIDEOS_DIR}/${FILENAME}.mp4"

notify-send "In Progress" "Converting: $FILENAME.webm → $FILENAME.mp4" -t $NOTIFY_TIMEOUT -u normal

if ffmpeg -i "$LATEST_WEBM" -c:v h264_nvenc -preset p1 -r 24 -c:a aac "$OUTPUT_MP4" -y 2>/tmp/ffmpeg_error.log; then
    rm "$LATEST_WEBM"
    notify-send "Done !" "✓ Conversion complete!\nSaved: $FILENAME.mp4\nDeleted: $FILENAME.webm" -t $NOTIFY_TIMEOUT -u normal
else
    notify-send "Error !" "✗ Conversion failed!\nCheck /tmp/ffmpeg_error.log for details" -t $NOTIFY_TIMEOUT -u critical
    exit 1
fi
