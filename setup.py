import os
from setuptools import Extension, setup

try:
	from Cython.Build import cythonize
except ImportError:
	cythonize = None



extensions = [
	Extension(
		name="pvrtc_decoder",
		version="1.0",
		author="K0lb3",
		author_email="",
		description="A PVRTC decoder for PIL",
		long_description=open('README.md', 'rt', encoding='utf8').read(),
		long_description_content_type="text/markdown",
		url="https://github.com/K0lb3/pvrtc_decoder",
		download_url="https://github.com/K0lb3/pvrtc_decoder/tarball/master",
		keywords=['PVRTC', 'PVRT', 'decoder', "PIL", "Pillow", "texture"],
		classifiers=[
			"License :: OSI Approved :: MIT License",
			"Operating System :: OS Independent",
			"Intended Audience :: Developers",
			"License :: OSI Approved :: MIT License",
			"Programming Language :: Python",
			"Programming Language :: Python :: 3",
			"Programming Language :: Python :: 3.6",
			"Programming Language :: Python :: 3.7",
			"Topic :: Multimedia :: Graphics",
		],
		sources=[
			"pvrtc_decoder.pyx",
			'src/PVRTDecompress.cpp',
		],
		language="c++",
		include_dirs=[
			"src"
		],
		install_requires=[
			"cython"
		],
	)
]
if cythonize:
	extensions = cythonize(extensions)

setup(ext_modules=extensions)
