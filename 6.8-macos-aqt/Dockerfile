# Image: stateoftheartio/qt6:6.8-macos-aqt

FROM ubuntu:20.04
MAINTAINER State Of The Art <docker@state-of-the-art.io> (@stateoftheartio)

# PIP requirement like "aqtinstall==2.0.6" or url with egg file
ARG AQT_VERSION="aqtinstall==3.2.0"
ARG OSXCROSS_URL=https://github.com/tpoechtrager/osxcross/archive/29fe6dd35522073c9df5800f8cd1feb4b9a993a8.tar.gz
ARG OSXCROSS_SHA256=4f0e8280eb98425a3cf620dc2de8725ef6a1cc02e8ea03a846b58b871ead1806
ARG SDK_URL=https://github.com/alexey-lysiuk/macos-sdk/releases/download/12.3/MacOSX12.3.tar.xz
ARG SDK_SHA256=91c03be5399be04d8f6b773da13045525e01298c1dfff273b4e1f1e904ee5484

ARG QT_VERSION=6.8.1
ARG QT_PATH=/opt/Qt

ARG ADDITIONAL_PACKAGES="sudo git openssh-client ca-certificates curl build-essential python3 locales genisoimage"

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    QT_VERSION=${QT_VERSION} \
    AQT_VERSION=${AQT_VERSION} \
    QT_PATH=${QT_PATH} \
    QT_MACOS=${QT_PATH}/${QT_VERSION}/macos \
    PATH=$PATH:${QT_PATH}/Tools/CMake/bin:${QT_PATH}/Tools/Ninja:${QT_PATH}/${QT_VERSION}/macos/bin:/opt/osxcross/bin

COPY get_qt.sh get_osxcross.sh install_packages.sh /tmp/

# Make scripts executable
RUN chmod +x /tmp/get_qt.sh /tmp/get_osxcross.sh /tmp/install_packages.sh

# Get Qt binaries with aqt
RUN /tmp/get_qt.sh

# Get osxcross
RUN /tmp/get_osxcross.sh

# Install the required packages
RUN /tmp/install_packages.sh

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user + sudo
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
