FROM ubuntu:20.04

WORKDIR /root

SHELL ["/bin/bash", "-c"]

COPY . /root

RUN basics/setup.sh

RUN user_mode/setup.sh

USER user

CMD "bash"