del /S /q .\images\*
ffmpeg -i input.mp4 -vf scale=28:21,fps=15 "images\out%%d.png"
pause