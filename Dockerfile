FROM debian:latest
MAINTAINER SYA-KE <syakesaba@gmail.com>

ENV SQUID_DIR /usr/local/squid
ENV C_ICAP_DIR /usr/local/c-icap

RUN apt-get update && \
    apt-get -qq -y install openssl libssl-dev build-essential wget curl net-tools dnsutils tcpdump && \
    apt-get clean

# squid 3.5.26
RUN wget http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.26.tar.gz && \
    tar xzvf squid-3.5.26.tar.gz && \
    cd squid-3.5.26 && \
    ./configure --prefix=$SQUID_DIR --enable-ssl --with-openssl --enable-ssl-crtd --with-large-files --enable-auth && \
    make -j4 && \
    make install

# c-icap 0.5.2
RUN wget https://downloads.sourceforge.net/project/c-icap/c-icap/0.5.x/c_icap-0.5.2.tar.gz && \
    tar xzvf c_icap-0.5.2.tar.gz && \
    cd c_icap-0.5.2 && \
    ./configure --enable-large-files --enable-lib-compat --prefix=$C_ICAP_DIR && \
    make -j4 && \
    make install

EXPOSE 3128

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
