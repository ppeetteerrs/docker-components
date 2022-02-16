RUN mamba install -y pytorch torchvision cudatoolkit=11.3 -c pytorch
RUN mamba install -y tensorboard pytorch-lightning
RUN pip install -U torch-tb-profiler