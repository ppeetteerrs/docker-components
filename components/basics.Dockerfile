WORKDIR /root

SHELL ["/bin/bash", "-c"]

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y sudo nano git wget curl htop

COPY resources /resources
RUN chmod -R 777 /resources