#!/bin/bash

# Create directories
storage_path_arry=($(echo $STORAGE_PATHS))
i=0
while [ $i -lt ${#storage_path_arry[@]} ]; do
    mkdir -p ${storage_path_arry[$i]}
    ((i++))
done

fdfs_trackerd /etc/fdfs/tracker.conf.sample_real start
fdfs_storaged /etc/fdfs/storage.conf.sample_real start

c/usr/local/nginx/sbin/nginx -s reload
