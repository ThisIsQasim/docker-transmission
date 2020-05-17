FROM debian:buster-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    transmission-remote-cli \
    transmission-daemon && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

### Install combustion theme
RUN apt-get update && apt-get install -y curl unzip &&\
    curl -LO https://github.com/Secretmapper/combustion/archive/release.zip &&\
    rm -rf /usr/share/transmission/web/* &&\
    unzip release.zip && mv combustion-release/* /usr/share/transmission/web/ &&\
    rm -rf combustion-release release.zip &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*
 
ADD main.sh /main.sh

RUN groupadd --gid 1001 transmission &&\
    useradd --system --uid 1001 --gid 1001 -M --shell /usr/sbin/nologin transmission &&\
    mkdir -p /downloads/incomplete && chown -R transmission:transmission /downloads && \
    chown -R transmission:transmission /etc/transmission-daemon /var/lib/transmission-daemon/

VOLUME /downloads

EXPOSE 9091
EXPOSE 6669/udp

USER transmission

CMD ["/main.sh"]
