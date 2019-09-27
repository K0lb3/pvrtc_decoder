from libc.stdint cimport uint8_t, uint32_t
from PIL import Image, ImageFile
import os, io

# link C++ functions
cdef extern from "src/PVRTDecompress.h" namespace "pvr":
	cdef uint32_t PVRTDecompressPVRTC(const void*compressedData, uint32_t do2bitMode, uint32_t xDim, uint32_t yDim,
	                                  uint8_t*outResultImage)
	cdef uint32_t PVRTDecompressETC(const void*srcData, uint32_t xDim, uint32_t yDim, void*dstData, uint32_t mode)

# define decoder
class PVRTCDecoder(ImageFile.PyDecoder):
	dstChannelBytes = 1
	dstChannels = 4
	
	def decode(self, buffer):
		if isinstance(buffer, (io.BufferedReader, io.BytesIO)):
			data = buffer.read()
		else:
			data = buffer
		do2bit_mode = self.args[0] if len(self.args) else 0
		self.set_as_raw(decompress_pvrtc(data, do2bit_mode, self.state.xsize, self.state.ysize))
		return -1, 0


def decompress_pvrtc(compressed_data : bytes, do2bit_mode : int, width : int, height : int) -> bytes:
	"""
	Decompresses PVRTC to RGBA 8888.
	:param compressed_data: - The PVRTC texture data to decompress
	:param do2bit_mode: Signifies whether the data is PVRTC2 (0) or PVRTC4 (1)
	:param width: X dimension of the texture
	:param height: Y dimension of the texture
	:returns: The decompressed texture data
	"""
	img = bytes(width * height * 4)
	PVRTDecompressPVRTC(<const uint8_t*> compressed_data, <uint32_t> do2bit_mode, <uint32_t> width, <uint32_t> height,
	                    <uint8_t*> img)
	if os.path.exists('log.txt'):
		os.unlink('log.txt')
	return img

def decompress_etc(src_data : bytes, width : int, height : int, mode : int = 0) -> bytes:
	"""
	Decompresses ETC to RGBA 8888.
	:param src_data: The ETC texture data to decompress
	:param width: X dimension of the texture
	:param height: Y dimension of the texture
	:param mode: The format of the data
	:returns: The decompressed texture data
	"""
	img = bytes(width * height * 4)
	PVRTDecompressETC(<const uint8_t*> src_data, <uint32_t> width, <uint32_t> height, <uint8_t*> img, <uint32_t> mode)
	if os.path.exists('log.txt'):
		os.unlink('log.txt')
	return img

# register decoder
if 'pvrtc' not in Image.DECODERS:
	Image.register_decoder('pvrtc', PVRTCDecoder)
	if os.path.exists('log.txt'):
		os.unlink('log.txt')
