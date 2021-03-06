FROM ubuntu:16.04
RUN apt update
RUN apt install -y wget git build-essential curl openssl libpcre3 libpcre3-dev libssl-dev

RUN git clone https://github.com/happyfish100/libfastcommon.git
RUN cd /libfastcommon && git checkout V1.0.43
RUN cd /libfastcommon && ./make.sh && ./make.sh install && cd ..

RUN git clone https://github.com/happyfish100/fastdfs.git
RUN cd /fastdfs && git checkout V6.06
RUN cd /fastdfs && ./make.sh && ./make.sh install && cd ..

RUN git clone https://github.com/happyfish100/fastdfs-nginx-module.git
RUN cd /fastdfs-nginx-module && git checkout V1.22
RUN cp /fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs

RUN wget http://nginx.org/download/nginx-1.16.1.tar.gz
RUN tar -zxvf nginx-1.16.1.tar.gz

RUN cd /nginx-1.16.1 && ./configure --add-module=/fastdfs-nginx-module/src
RUN cd /nginx-1.16.1 && make && make install

COPY script/*.sh  /script/ 
COPY ./config/nginx.conf /usr/local/nginx/conf/

CMD /script/start.sh
