from PIL import Image
import os

# 在此处修改视频帧率，用于计算每帧时间戳
framerate = 15

frames = {}

for file in os.listdir('images'):
    if file.endswith('.png'):
        fp = os.path.join('images', file)
        print(fp)

        seq = int(file.replace('out', '').replace('.png', ''))

        im = Image.open(fp, 'r')
        color_data = list(im.getdata())

        code = ''.join([f'|cFF{r:02X}{g:02X}{b:02X}■ |r' for r, g, b in color_data])

        frames[seq] = f"table.insert(videoFramesRaw, {{{(seq-1) / framerate}, '{code}'}})"

frames = dict(sorted(frames.items()))

with open('generated_frames_color.lua', 'w+', encoding='utf-8') as f:
    f.write('\n'.join([v for v in frames.values()]))
