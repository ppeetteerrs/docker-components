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