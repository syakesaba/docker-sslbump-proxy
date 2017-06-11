docker-sslbump-proxy
======================
squid + c-icap

Baseimage
======================
debian:latest

Usage
======================
```sh
git clone <https://github.com/syakesaba/docker-sslbump-proxy.git>
cd docker-sslbump-proxy
docker build . -t sslbump-proxy
docker run -ti -p 3128:3128 sslbump-proxy
#C-p q to detach, or
#docker run -d -p 3128:3128 sslbump-proxy
```

Usage (Proxy)
======================
Pick your fakeroot-cert and import it into your web browsers.  
FILE PATH: /usr/local/squid/myCA.der  
Or normally access some HTTPS webpages and "Trust Cert". 

Note
======================
Make sure your proxy safe.  
To prevent unwanted use, firewalls or some squid-acls should be applied.  
See: <entrypoint.sh>.   

License
======================
MIT License  
see: <LICENSE>

