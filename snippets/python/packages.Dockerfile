# Linters and Formatters
RUN mamba install -y black flake8 isort autoflake

# Utils
RUN mamba install -y tqdm jupyter notebook rich numpy scipy matplotlib pandas seaborn
RUN pip install ipympl

# Pytorch
RUN mamba install -y pytorch torchvision cudatoolkit=11.3 -c pytorch
RUN mamba install -y tensorboard pytorch-lightning
RUN pip install -U torch-tb-profiler

# OpenCV
ARG OPENCV_VERSION=$OPENCV_VERSION
ARG CUDA_ARCH=8.6
ARG NUMPY_VERSION=1.21.5
# RUN sudo apt-get -y install build-essential cmake unzip pkg-config screen \
# 	libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev \
# 	libjpeg-dev libpng-dev libtiff-dev \
# 	libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
# 	libxvidcore-dev libx264-dev \
# 	libopenblas-dev libatlas-base-dev liblapack-dev gfortran \
# 	libhdf5-serial-dev \
# 	libgtk-3-dev

RUN wget -q -O - https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz | tar -xzf - && \
	git clone https://github.com/opencv/opencv_contrib.git && \
	mkdir -p opencv-$OPENCV_VERSION/build && \
	cd opencv-$OPENCV_VERSION/build && \
	cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=ON \
    -D WITH_TBB=ON \
    -D WITH_CUDA=ON \
    -D WITH_CUDNN=OFF \
	-D OPENCV_DNN_CUDA=ON \
    -D BUILD_opencv_cudacodec=OFF \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
	-D CUDA_ARCH_BIN=$CUDA_ARCH \
    -D WITH_CUBLAS=1 \
    -D WITH_V4L=ON \
    -D WITH_QT=OFF \
    -D WITH_OPENGL=ON \
    -D WITH_GSTREAMER=ON \
	-D HAVE_opencv_python3=ON \
    -D PYTHON3_NUMPY_VERSION=$NUMPY_VERSION \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_PC_FILE_NAME=opencv.pc \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_PYTHON3_INSTALL_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D PYTHON_EXECUTABLE=$(which python3) \
    -D BUILD_EXAMPLES=ON .. && \
	sudo make -j$(nproc) install && \
	sudo ldconfig
RUN sudo rm -rf opencv-$OPENCV_VERSION opencv_contrib && \
    sudo apt-get install -y libgl1 libxrender1