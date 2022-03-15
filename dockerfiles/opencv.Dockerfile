FROM ppeetteerrs/python:latest

# OpenCV
ARG OPENCV_VERSION=4.5.5
ARG CUDA_ARCH=8.6
ARG NUMPY_VERSION=1.21.5

RUN wget -q -O - https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz | tar -xzf - && \
	git clone https://github.com/opencv/opencv_contrib.git && \
	mkdir -p ~/opencv-$OPENCV_VERSION/build && \
	cd ~/opencv-$OPENCV_VERSION/build && \
	cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D WITH_TBB=ON \
    -D WITH_CUDA=OFF \
    -D WITH_CUDNN=OFF \
	-D OPENCV_DNN_CUDA=OFF \
    -D BUILD_opencv_cudacodec=OFF \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=0 \
	-D CUDA_ARCH_BIN=$CUDA_ARCH \
    -D WITH_CUBLAS=0 \
    -D WITH_V4L=ON \
    -D WITH_QT=OFF \
    -D WITH_OPENGL=ON \
    -D WITH_GSTREAMER=ON \
	-D HAVE_opencv_python3=ON \
    -D PYTHON3_NUMPY_VERSION=$NUMPY_VERSION \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_PC_FILE_NAME=opencv.pc \
    -D OPENCV_ENABLE_NONFREE=OFF \
    -D OPENCV_PYTHON3_INSTALL_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D PYTHON3_EXECUTABLE=$(which python3) \
    -D BUILD_EXAMPLES=OFF .. && \
	sudo make -j$(nproc) install && \
	sudo ldconfig && \
    sudo rm -rf ~/opencv-$OPENCV_VERSION ~/opencv_contrib && \
    sudo apt-get install -y libgl1 libxrender1

CMD "zsh"