del /S /q .\images\*
ffmpeg -i "Touhou - Bad Apple.mp4" -vf scale=28:21,fps=15,hue=s=0 "images\out%%d.png"
pause