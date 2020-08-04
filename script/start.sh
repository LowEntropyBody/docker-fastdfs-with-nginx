#!/bin/bash

# Create directories
mkdir -p $TRACKER_PATH
mkdir -p $STORAGE_PATH
mkdir -p /tmp/client

storage_path_arry=($(echo $STORAGE_PATHS))
i=0
while [ $i -lt ${#storage_path_arry[@]} ]; do
    mkdir -p ${storage_path_arry[$i]}
    ((i++))
done

# Generate configurations
/script/gen_config.sh -s /etc/fdfs/storage.conf.sample -t /etc/fdfs/tracker.conf.sample -c /etc/fdfs/client.conf.sample

# Show configurations
echo ----------------tracker.conf----------------------
cat /etc/fdfs/tracker.conf.sample_real
echo ----------------storage.conf----------------------
cat /etc/fdfs/storage.conf.sample_real
echo ----------------client.conf----------------------
cat /etc/fdfs/client.conf.sample_real

# Start fastdfs
echo ----------------start fastdfs---------------------
fdfs_trackerd /etc/fdfs/tracker.conf.sample_real start
fdfs_storaged /etc/fdfs/storage.conf.sample_real start

# Show fdfs
echo ------------show fastdfs thread-------------------
sleep 2
ps -ef | grep fdfs_

# Test upload
echo Waiting 120s....
sleep 120
tracker_ip=${TRACKER_ADDRESS%%:*}
echo 'You are successful, please go to https://github.com/LowEntropyBody to follow author 'LowEntropyBody' in github! ' > test.txt
storage_key=`fdfs_upload_file /etc/fdfs/client.conf.sample_real test.txt`
echo You are successful, storage key is $storage_key

while true; do
sleep 1
done
