FROM debian:stable-slim
MAINTAINER SYA-KE <syakesaba@gmail.com>

ENV SQUID_DIR /usr/local/squid
ENV C_ICAP_DIR /usr/local/c-icap

RUN apt-get update && \
    apt-get -qq -y install openssl libssl-dev build-essential wget curl net-tools dnsutils tcpdump libcap-dev  && \
    apt-get clean

ARG squid_version="6.6"
RUN wget http://www.squid-cache.org/Versions/v6/squid-${squid_version}.tar.gz && \
    tar xzvf squid-${squid_version}.tar.gz && \
    cd squid-${squid_version} && \
    ./configure --prefix=$SQUID_DIR --with-openssl --enable-ssl-crtd --with-large-files && \
    make -j4 && \
    make install

ARG c_icap_version="0.6.2"
RUN wget https://jaist.dl.sourceforge.net/project/c-icap/c-icap/0.6.x/c_icap-${c_icap_version}.tar.gz && \
    tar xzvf c_icap-${c_icap_version}.tar.gz && \
    cd c_icap-${c_icap_version} && \
    ./configure --enable-large-files --enable-lib-compat --prefix=$C_ICAP_DIR && \
    make -j4 && \
    make install

EXPOSE 3128

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
