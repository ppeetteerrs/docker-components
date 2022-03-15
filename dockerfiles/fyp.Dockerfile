FROM nvidia/cuda:11.6.0-devel-ubuntu20.04

# Base
## Settings
WORKDIR /root
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

## Update
RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y sudo nano git wget curl htop build-essential cmake

## Copy
COPY resources /resources
RUN chmod -R 777 /resources

# Add User
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN echo "Adding user... NAME: $USERNAME - UID: $USER_UID - GID: $USER_GID"

RUN groupadd --gid $USER_GID $USERNAME && \
	useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
	echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
	chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

# Shell
## ZSH
RUN sudo apt-get install -y zsh && \
	sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
	echo "export HISTSIZE=1000000" >> ~/.zshrc && \
	echo "export SAVEHIST=1000000" >> ~/.zshrc && \
	echo "setopt EXTENDED_HISTORY" >> ~/.zshrc && \
	sed -i 's/plugins=(git)/plugins=(zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc

## Starship
RUN /resources/starship.sh

## Aliases
RUN cp /resources/aliases.bashrc ~/.aliases
RUN echo "source ~/.aliases" >> ~/.bashrc
RUN if [ -x "$(command -v zsh)" ]; then echo "source ~/.aliases" >> ~/.zshrc; fi

# Mamba
# Install mamba
RUN wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" && \
	bash "Mambaforge-$(uname)-$(uname -m).sh" -b && \
	rm "Mambaforge-$(uname)-$(uname -m).sh"

## Create user Python environment (copy from existing base if it exists)
RUN if [ ! -z $(which conda) ]; \
	then conda create -p ~/mambaforge/envs/user --clone base -y; \
	else ~/mambaforge/bin/mamba create -n user python=3.9 -y; \
	fi

## Automatically activate user environment, disable logo and disable conda prompt for starship
ENV PATH=/home/$USERNAME/mambaforge/bin:$PATH
RUN mamba init --all && \
	conda env config vars set MAMBA_NO_BANNER=1 && \
	conda config --set changeps1 False && \
	echo "conda activate user" >> ~/.bashrc && \
	echo "conda activate user" >> ~/.zshrc

## Change shell
SHELL ["conda", "run", "-n", "user", "/bin/bash", "-c"]

# Linters and Formatters
RUN mamba install -n base -y autoflake && \
	mamba install -y black flake8 isort tqdm jupyter notebook rich numpy=1.21.5 scipy matplotlib pandas seaborn && \
	pip install ipympl

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

# Training
RUN mamba install -y tensorboard pytorch-lightning python-dotenv python-lmdb pycuda && \
	mamba install -y -c simpleitk simpleitk && \
	mamba install -y -c rapidsai -c nvidia cusignal && \
	pip install -U torch-tb-profiler stylegan2_torch lpips torchgeometry deepdrr==1.1.0a4

CMD "zsh"