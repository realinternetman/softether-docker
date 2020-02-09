FROM centos:7

EXPOSE 500/udp 4500/udp

ARG DOWNLOAD_DIR
ARG GITHUB_URL
ARG REPSITORY_NAME

# Install Dependencies
WORKDIR $DOWNLOAD_DIR
RUN yum -y install git gcc make which openssl-devel readline-devel net-tools iptables-services

# Download Source Files
RUN git config --global http.postBuffer 500M && \
    git clone --depth 1 "$GITHUB_URL/$REPSITORY_NAME.git"

# Build
WORKDIR $DOWNLOAD_DIR/$REPSITORY_NAME
RUN ./configure && \
    make && \
    make install && \
    make clean

# Remove Source Files
WORKDIR $DOWNLOAD_DIR
RUN rm -rf $REPSITORY_NAME

# Setup
COPY scripts/vpn_hub_cmd.sh /usr/local/bin/vpn_hub_cmd
RUN chmod +x /usr/local/bin/vpn_hub_cmd

ENV TZ="Asia/Tokyo"
RUN echo $TZ > /etc/timezone

COPY scripts/vpn_setup.sh $DOWNLOAD_DIR
RUN chmod +x vpn_setup.sh

# Start Service
WORKDIR /usr/vpnserver/
ENTRYPOINT ["vpnserver", "execsvc"]