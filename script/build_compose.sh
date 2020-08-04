#!/bin/bash
scriptdir=$(cd `dirname $0`;pwd)
basedir=$(cd $scriptdir/..;pwd)

. $basedir/config/fdfs.conf

cat << EOF > $basedir/docker-compose.yml
version: '2.0'
services:
  fastdfs:
    image: 'lowentropybody/fastdfs:0.1.0'
    network_mode: host
    volumes:
      - '$TRACKER_PATH:$TRACKER_PATH'
      - '$STORAGE_PATH:$STORAGE_PATH'
$(for el in $STORAGE_PATHS; do echo "      - '$el:$el'"; done)
    environment:
        TRACKER_ADDRESS: '$TRACKER_ADDRESS'
        TRACKER_PATH: '$TRACKER_PATH'
        STORAGE_PATH: '$STORAGE_PATH'
        STORAGE_PORT: '$STORAGE_PORT'
        STORAGE_PATHS: '$STORAGE_PATHS'
        RESERVED_STORAGE_SPACE: '$RESERVED_STORAGE_SPACE'
    container_name: fastdfs-0.1.0
EOF