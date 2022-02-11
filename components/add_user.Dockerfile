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