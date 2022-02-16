# Get mambaforge installer
RUN wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"

# Install in batch mode
RUN bash "Mambaforge-$(uname)-$(uname -m).sh" -b
RUN rm "Mambaforge-$(uname)-$(uname -m).sh"

# Automatically activate user environment
ENV PATH=/home/$USERNAME/mambaforge/bin:$PATH
RUN mamba init --all

# Disable mamba logo
RUN conda env config vars set MAMBA_NO_BANNER=1

# Disable conda prompt for starship
RUN if [ -x "$(command -v starship)" ]; then conda config --set changeps1 False; fi
