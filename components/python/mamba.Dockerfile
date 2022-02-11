ENV CONDA_ENV=${USERNAME:-base}

# # Include CUDA binaries in PATH
ENV PATH=/opt/conda/bin:$PATH

# Clone base environment
RUN conda init --all

RUN if [ ! -z $USERNAME ]; then conda create -n $CONDA_ENV --clone base; fi
RUN echo "conda activate $CONDA_ENV" >> ~/.bashrc
RUN if [ -x "$(command -v zsh)" ]; then echo "conda activate $CONDA_ENV" >> ~/.zshrc; fi

RUN conda install -y mamba -n $CONDA_ENV -c conda-forge
RUN conda run -n $CONDA_ENV bash -c "mamba init --all"
