from pvrtc_decoder import *

data = open('SpriteAtlasTexture-SoldierSkinIcon (Group 2)-256x256-fmt32', 'rb').read()
img = Image.frombytes('RGBA', (256,256), data, 'pvrtc', (0))
rgba = decompress_pvrtc(data, 0, 256, 256)
img.show()
input()