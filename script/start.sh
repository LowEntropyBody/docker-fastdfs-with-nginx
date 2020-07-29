#!/bin/bash

# Create directories
mkdir -p $TRACKER_PATH
mkdir -p $STORAGE_PATH

storage_path_arry=($(echo $STORAGE_PATHS))
i=0
while [ $i -lt ${#storage_path_arry[@]} ]; do
    mkdir -p ${storage_path_arry[$i]}
    ((i++))
done

# Show configurations
echo ----------------tracker.conf----------------------
cat /etc/fdfs/tracker.conf.sample_real
echo ----------------storage.conf----------------------
cat /etc/fdfs/storage.conf.sample_real
echo ----------------mod_fastdfs.conf----------------------
cat /etc/fdfs/mod_fastdfs.conf
echo ----------------nginx.conf----------------------
cat /usr/local/nginx/conf/nginx.conf

# Start fastdfs
echo ----------------start fastdfs---------------------
fdfs_trackerd /etc/fdfs/tracker.conf.sample_real start
fdfs_storaged /etc/fdfs/storage.conf.sample_real start

# Show fdfs
echo ------------show fastdfs thread-------------------
sleep 2
ps -ef | grep fdfs_

# Copy fastdf configurations
echo ----------- copy fastdf configurations ------------
cd /fastdfs/conf
cp http.conf mime.types /etc/fdfs

# Start nginx
echo ----------- start nginx ------------
cd /usr/local/nginx
./sbin/nginx
./sbin/nginx -s reload

# Show nginx thread
echo ------------show nginx thread-------------------
sleep 2
ps -ef | grep nginx
