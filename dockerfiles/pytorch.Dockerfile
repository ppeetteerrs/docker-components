FROM nvcr.io/nvidia/pytorch:21.12-py3

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
ENV PATH=/home/user/mambaforge/bin:$PATH
RUN mamba init --all && \
	conda env config vars set MAMBA_NO_BANNER=1 && \
	conda config --set changeps1 False && \
	echo "conda activate user" >> ~/.bashrc && \
	echo "conda activate user" >> ~/.zshrc

## Change shell
SHELL ["conda", "run", "-n", "user", "/bin/bash", "-c"]

# Linters and Formatters
RUN mamba install -n base -y autoflake && \
	mamba install -y black flake8 isort tqdm jupyter notebook rich numpy scipy matplotlib pandas seaborn && \
	pip install ipympl

CMD "zsh"