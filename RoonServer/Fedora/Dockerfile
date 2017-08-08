# Dockerfile to install the latest version of RoonServer for Linux x86_64

# Using latest Fedora
FROM fedora:25

# Based instructions from http://kb.roonlabs.com/LinuxInstall
MAINTAINER little.scarabee@outlook.fr

# Location of Roon's latest Linux installer
ENV ROON_INSTALLER roonserver-installer-linuxx64.sh
ENV ROON_INSTALLER_URL http://download.roonlabs.com/builds/${ROON_INSTALLER}

# Roon's startup script
ENV ROON_DATAROOT /var/roon
ENV ROON_ID_DIR /var/roon

# Install prerequisite packages
RUN dnf update -y \
	&& dnf install -y curl bzip2 libav-tools cifs-utils libasound2 \
	&& dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	&& dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
	&& dnf update -y \
	&& dnf install -y ffmpeg alsa-utils glibc

# Grab installer and script to run it
RUN curl -url ${ROON_INSTALLER_URL} --output /tmp/${ROON_INSTALLER}

# Fix installer permissions
RUN chmod +x /tmp/${ROON_INSTALLER}

# Run the installer, answer "yes" and ignore errors
CMD printf "y\ny\n" | /tmp/${ROON_INSTALLER} && tail -f /dev/null

# Your Roon data will be stored in /var/roon; /music is for your music
VOLUME [ "/var/roon", "/music" ]

# This starts Roon when the container runs
ENTRYPOINT /opt/RoonServer/start.sh
