FROM ubuntu:latest
MAINTAINER Gian Costa <gcosta1992@gmail.com>

RUN apt-get update && \
    apt-get install -y vim git wget sudo curl

WORKDIR /
ADD fips.sh /

RUN chmod 777 /fips.sh && ./fips.sh

RUN rm -rf /dist
CMD ["/bin/bash"]
