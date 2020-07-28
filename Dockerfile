FROM nginx
RUN wget ``https://github.com/happyfish100/libfastcommon/archive/V1.0.7.tar.gz
RUN tar -zxvf V1.0.7.tar.gz
RUN cd libfastcommon-1.0.7 && ./make.sh && ./make.sh install && cd ..
RUN wget https://github.com/happyfish100/fastdfs/archive/V5.05.tar.gz
RUN tar -zxvf V5.05.tar.gz
RUN cd fastdfs-5.05 && ./make.sh && ./make.sh install && cd ..
