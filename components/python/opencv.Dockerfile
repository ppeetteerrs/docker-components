RUN wget -q -O - https://github.com/opencv/opencv/archive/4.5.5.tar.gz | tar -xzf - && \
	git clone https://github.com/opencv/opencv_contrib.git && \
	mkdir -p opencv-4.5.5/build && \
	cd opencv-4.5.5/build && \
	cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=ON \
    -D WITH_TBB=ON \
    -D WITH_CUDA=OFF \
    -D BUILD_opencv_cudacodec=OFF \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D WITH_V4L=ON \
    -D WITH_QT=OFF \
    -D WITH_OPENGL=ON \
    -D WITH_GSTREAMER=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_PC_FILE_NAME=opencv.pc \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_PYTHON3_INSTALL_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D PYTHON_EXECUTABLE=$(which python3) \
    -D BUILD_EXAMPLES=ON .. && \
	sudo make -j8 install && \
	sudo ldconfig && \
    cd ../.. && \
    rm -rf opencv-4.5.5 opencv_contrib
RUN mamba install -y numpy=1.22 && \
    sudo apt-get install -y libgl1 libxrender1