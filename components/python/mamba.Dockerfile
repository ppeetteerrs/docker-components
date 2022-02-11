ENV CONDA_ENV=${USERNAME:-base}

# Get mambaforge installer
RUN wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"

# Install in batch mode
RUN bash "Mambaforge-$(uname)-$(uname -m).sh" -b
RUN rm "Mambaforge-$(uname)-$(uname -m).sh"

# Clone existing base environment(s) into user environment (e.g. NVIDIA's pytorch environments)
RUN if [ ! -z $(which conda) ]; then conda create -p ~/mambaforge/envs/$(whoami) --clone base -y; else ~/mambaforge/bin/mamba create -n $(whoami) --clone base -y; fi

# Init shells and add to docker path
RUN ~/mambaforge/bin/mamba init --all
ENV PATH=/home/$USERNAME/mambaforge/bin:$PATH

# Automatically activate user environment
RUN echo "conda activate $(whoami)" >> ~/.bashrc
RUN if [ -x "$(command -v zsh)" ]; then echo "conda activate $(whoami)" >> ~/.zshrc; fi

# Disable mamba logo
RUN conda env config vars set MAMBA_NO_BANNER=1

# Disable conda prompt for starship
RUN if [ -x "$(command -v starship)" ]; then conda config --set changeps1 False; fi
