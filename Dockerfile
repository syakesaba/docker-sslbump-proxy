FROM debian:latest
MAINTAINER SYA-KE

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
    make install && \
    cd /usr/local/squid && \
    openssl req -new -newkey rsa:2048 -nodes -days 3650 -x509 -keyout myCA.pem -out myCA.crt -subj "/C=JP/ST=Ikebukuro/L=Tokyo/O=Dollers/OU=Dollers Co.,Ltd./CN=squid.local" && \
    openssl x509 -in myCA.crt -outform DER -out myCA.der && \
    mkdir -p ./var/lib && \
    ./libexec/ssl_crtd -c -s ./var/lib/ssl_db && \
    mkdir -p ./var/cache

# c-icap 0.5.2
RUN wget https://downloads.sourceforge.net/project/c-icap/c-icap/0.5.x/c_icap-0.5.2.tar.gz && \
    tar xzvf c_icap-0.5.2.tar.gz && \
    cd c_icap-0.5.2 && \
    ./configure --enable-large-files --enable-lib-compat --prefix=$C_ICAP_DIR && \
    make -j4 && \
    make install && \
    mkdir -p $C_ICAP_DIR/share/c_icap/templates && \
    mkdir -p $C_ICAP_DIR/var/log && \
    mkdir -p $C_ICAP_DIR/var/run/c-icap

EXPOSE 3128

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
