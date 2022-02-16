WORKDIR /root

SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y sudo nano git wget curl htop build-essential cmake

COPY resources /resources
RUN chmod -R 777 /resources