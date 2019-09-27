# PVRTC Decoder
A PVRTC decoder for PIL.

The decoder uses PVRTDecompress from [PVRCore](https://github.com/powervr-graphics/Native_SDK/tree/master/framework/PVRCore) to decompress the data.


## Installation
- Cython required
### PIP
```
pip install pvrtc_decoder
```
### Manual
```cmd
python setup.py install
```


## Usage
do2bit_mode:
- 0 - PVRTC2 (8 bit)
- 1 - PVRTC4 (16 bit)

### PIL.Image decoder
```python
from PIL import Image
import pvrtc_decoder 
#needs to be imported once in the active code, so that the codec can register itself

raw_pvrtc_image_data : bytes
do2bit_mode = 0 # see above
img = Image.frombytes('RGBA', size, raw_pvrtc_image_data, 'pvrtc', (do2bit_mode))
```

### raw decoder
```python
from pvrtc_decoder import decompress_pvrtc, decompress_etc

# compressed PVRTC image bytes to RGBA bytes
rgba_data = decompress_pvrtc(compressed_data : bytes, do2bit_mode : int, width : int, height : int)

# compressed ETC image bytes to RGBA bytes
# mode seems to be unused, so use any value you want
rgba_data = decompress_etc(src_data : bytes, width : int, height : int, mode : int)
```