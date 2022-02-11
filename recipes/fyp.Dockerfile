FROM ppeetteerrs/pytorch

RUN mamba install -y opencv pycuda nibabel pydicom python-dotenv
RUN mamba install -y -c rapidsai -c nvidia cusignal
RUN mamba install -y -c simpleitk simpleitk
RUN pip install -U stylegan2_torch deepdrr lpips torchgeometry

CMD "zsh"