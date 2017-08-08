# Dockerfile to install the latest version of RoonServer for Linux x86_64

# Using latest Fedora / CentOS / RedHat
FROM fedora:twenty five

# Based instructions from http://kb.roonlabs.com/LinuxInstall
MAINTAINER little.scarabee@outlook.fr

# Location of Roon's latest Linux installer
ENV ROON_INSTALLER roonserver-installer-linuxx64.sh
ENV ROON_INSTALLER_URL http://download.roonlabs.com/builds/${ROON_INSTALLER}

# Roon's startup script
ENV ROON_DATAROOT /var/roon
ENV ROON_ID_DIR /var/roon

# Install prerequisite packages for FEDORA / CENTOS
RUN dnf update \
	&& dnf install -y curl bzip2 libav-tools cifs-utils libasound2 \
	&& dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	&& dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
	&& dnf update \
	&& dnf install -y ffmpeg alsa-utils glibc
  
# Install prerequisite packages For DEBIAN / UBUNTU
RUN apt-get update \
	&& apt-get install -y curl bzip2 libasound2 \
	&& apt-get clean && apt-get autoclean

# Grab installer and script to run it
ADD ${ROON_INSTALLER_URL} /tmp
COPY run_installer.sh /tmp

# Fix installer permissions
RUN chmod 700 /tmp/${ROON_INSTALLER} /tmp/run_installer.sh

# Run the installer, answer "yes" and ignore errors
RUN /tmp/run_installer.sh

# Your Roon data will be stored in /var/roon; /music is for your music
VOLUME [ "/var/roon", "/music" ]

# This starts Roon when the container runs
ENTRYPOINT /opt/RoonServer/start.sh
