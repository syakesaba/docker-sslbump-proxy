FROM debian
MAINTAINER SYA-KE <syakesaba@gmail.com>

ENV SQUID_DIR /usr/local/squid
ENV C_ICAP_DIR /usr/local/c-icap

RUN apt-get update && \
    apt-get -qq -y install openssl libssl-dev build-essential wget curl net-tools dnsutils tcpdump libcap-dev  && \
    apt-get clean

# squid 5.8
RUN wget http://www.squid-cache.org/Versions/v5/squid-5.8.tar.gz && \
    tar xzvf squid-5.8.tar.gz && \
    cd squid-5.8 && \
    ./configure --prefix=$SQUID_DIR --with-openssl --enable-ssl-crtd --with-large-files && \
    make -j4 && \
    make install

# c-icap 0.5.10
RUN wget https://jaist.dl.sourceforge.net/project/c-icap/c-icap/0.5.x/c_icap-0.5.10.tar.gz && \
    tar xzvf c_icap-0.5.10.tar.gz && \
    cd c_icap-0.5.10 && \
    ./configure --enable-large-files --enable-lib-compat --prefix=$C_ICAP_DIR && \
    make -j4 && \
    make install

EXPOSE 3128

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
