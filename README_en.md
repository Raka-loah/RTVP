# Bad Apple playing in WOW Chat Window

WOW 10.0 is here and I'm bored as feck so I managed to make an addon to play text-based Bad Apple video frames in WOW chat window.

### TL;DR Usage

1. `!RTVP` folder is the addon itself. Copy to where it belongs.
2. Boot up your WOW and create a chat window named `RTVP`. Unsubscribe every channel and system messages is advised. *Unsubscribe WOW even better.*
3. It should work if you reload UI now using  `/reload` , then type `/rtvp stage` and Enter.
4. There should be bunch of black and white squares in that  `RTVP` chat window now. Adjust the size of that window and make even and odd rows perfectly all black or all white.
5. Type `/rtvp play` and Enter to play the video. *P.s. Music not included, play it yourself in the background.*

### How can this work?

There are two basic functions for WOW chat windows (aka. Chat frames):

* ChatFrame:AddMessage(msg): Display `msg` to the chat window. Blizzard format color code (e.g. `|cFFFF0000RED TEXT|r` ) is supported.
* ChatFrame:Clear(): Clear the chat window.

With both of them, you can simply clear and display text and it will look like a video if you do that fast enough.

### Can you elaborate?

Based on my testing on Chinese client, chat windows can display up to 22 lines of text. Since the original Bad Apple video has 4:3 aspect ratio, I decided to use 28 pixel wide and 21 pixel high.

Chat window line spacing is really wide so I have to add an extra space to compensate.

Resolution is really low so frame rate is not that important, 15 frames per second is chosen (it's 30 fps for the original video). And that's ~3000 frames, a lot actually.

Since Bad Apple video is black and white, final text is down to 4 colors: white, light gray (#212121), dark gray(#424242) and black. Matching 0~255 grayscale every 64 levels.

#### Video to image

Every script I used to generate text video frames lies in `tools` folder. `ffmpeg` and Bad Apple video is not included, if you want to play another video, put `ffmpeg.exe` and video file inside.

Double click `video_to_image.bat` to generate 28x21 black and white images at 15 fps.

Well that's just `ffmpeg -vf scale=28:21,fps=15,hue=s=0` .

#### Image to text

`generate_frames.py` is my script generate text utilising the amazing `Pillow` library. It's really simple, just read grayscale level of every pixel (0-255) and categories them into 4 buckets (every 64 levels) matching 4 colors.

Since 28x21 is almost 600 characters and I'm bored as feck anyway, a compression "algorithm" is developed: 4 colors for every pixel, so 64 combinations every 3 pixels (4x4x4), and there is a 64-character long alphatbet called Base64 alphabet (A-Z a-z 0-9 + /), very convenient right? Now every video frame is just ~200 characters long.

Run the script to get a `generated_frames.lua` with a lot `table.insert` in it. Paste all of those to the corresponding space in `video_frames.lua` and voila!

#### The Addon itself

is just reading all these mess, decompress them, replace every pixel with squares with color, and display them in the chat window at the right timestamp.
