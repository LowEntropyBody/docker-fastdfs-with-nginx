FROM ubuntu:16.04
RUN apt update
RUN apt install -y wget git build-essential curl openssl libpcre3 libpcre3-dev libssl-dev

RUN git clone https://github.com/happyfish100/libfastcommon.git
RUN cd /libfastcommon && git checkout V1.0.43
RUN cd /libfastcommon && ./make.sh && ./make.sh install && cd ..

RUN git clone https://github.com/happyfish100/fastdfs.git
RUN cd /fastdfs && git checkout V6.06
RUN cd /fastdfs && ./make.sh && ./make.sh install && cd ..

COPY script/*.sh  /script/ 

CMD /script/start.sh
