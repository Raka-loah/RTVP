# 用于生成插件当中那串用于解压视频帧的代码的代码 XD

alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
lookup_table = ''

for i in range(1, 5):
    for j in range(1, 5):
        for k in range(1, 5):
            print(f"lookupTable['{alphabet[(i-1) * 16 + (j-1) * 4 + (k-1)]}'] = sct['{i}'] .. sct['{j}'] .. sct['{k}']")
