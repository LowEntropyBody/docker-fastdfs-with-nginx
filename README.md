# docker-fastdfs-with-nginx
Use Docker to build Fastdfs on a single machine and start Nginx at the same time

## Modify the fdfs configuration

Start editing:
```shell
vim config/fdfs.conf
```

Configuration list：
```shell
# Configure the tracker address, it must be an external address (does not support DNS)
TRACKER_ADDRESS='192.168.50.11:22122'
# Tracker basic data storage location
TRACKER_PATH='/fastdfs/tracker'
# Storage basic data storage location
STORAGE_PATH='/fastdfs/storage'
# Storage download port
STORAGE_PORT='23000'
# storage data storage path (recommended for one hard disk, one path)
STORAGE_PATHS='/fastdfs/storage_path0 /fastdfs/storage_path1'
# Storage reserved space
RESERVED_STORAGE_SPACE='0.5%'
```

## Generate compose file
```shell
sudo ./script/build_compose.sh
```

## Lanuch
Lanuch：
```shell
sudo docker-compose up -d
```

Logs：
```shell
sudo docker logs nginx-fastdfs-0.1.0 -f
```

## Open ports

Open tracker port
```shell
sudo ufw allow 22122
```

Open storage port
```shell
sudo ufw allow 23000
```

Open nginx port
```shell
sudo ufw allow 8888
```

## Browser download test
Wait 2 minutes, open the browser to test the link below, pay attention to replace $tracker_ip and $storage_key (refer to the log after startup)

http://$tracker_ip:8888/$storage_key

## If you find it easy to use, please star this repo. If you have any questions, please raise it in the issue~~~~
