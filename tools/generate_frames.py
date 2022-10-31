from PIL import Image
import os

# 在此处修改视频帧率，用于计算每帧时间戳
framerate = 15

alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

lookup_table = {}

for i in range(1, 5):
    for j in range(1, 5):
        for k in range(1, 5):
            lookup_table[f'{i}{j}{k}'] = alphabet[(i-1) * 16 + (j-1) * 4 + (k-1)]

frames = {}

for file in os.listdir('images'):
    if file.endswith('.png'):
        fp = os.path.join('images', file)
        print(fp)

        seq = int(file.replace('out', '').replace('.png', ''))

        im = Image.open(fp, 'r').convert('L')
        grayscale_data = list(im.getdata())

        code = ''
        for i in range(0, len(grayscale_data)):
            code += str(4 - grayscale_data[i] // 64)

        from textwrap import wrap

        code_list = wrap(code, 3)

        encoded_frame = ''

        for code in code_list:
            encoded_frame += lookup_table[code.ljust(3, '0')]

        frames[seq] = f"table.insert(videoFramesRaw, {{{(seq-1) / framerate}, '{encoded_frame}'}})"

frames = dict(sorted(frames.items()))

with open('generated_frames.lua', 'w+') as f:
    f.write('\n'.join([v for v in frames.values()]))
