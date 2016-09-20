FROM ubuntu:16.04

ENV NODE_VERSION v6.3.0
ENV OPENSSL_FIPS_MODULE openssl-fips-2.0.12
ENV OPEN_SSL_CORE openssl-1.0.2h

RUN apt-get update && apt-get install -y vim git wget sudo curl

ADD fips.sh /
RUN chmod 777 /fips.sh && ./fips.sh

ADD test-fips.sh /
RUN chmod 777 /test-fips.sh && ./test-fips.sh

CMD ["/bin/bash"]
