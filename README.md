# docker-fastdfs-with-nginx
利用Docker在单台机器上构建Fastdfs, 并同时启动Nginx

## 修改fdfs配置

开始编辑：
```shell
vim config/fdfs.conf
```

配置列表：
```shell
# 配置tracker的地址，必须是外部地址
TRACKER_ADDRESS='192.168.50.11:22122'
# tracker基础数据存储位置
TRACKER_PATH='/fastdfs/tracker'
# storage基础数据存储位置
STORAGE_PATH='/fastdfs/storage'
# storage下载端口
STORAGE_PORT='23000'
# storage 数据存储路径（建议一个硬盘一个路径）
STORAGE_PATHS='/fastdfs/storage_path0 /fastdfs/storage_path1'
# 存储预留空间
RESERVED_STORAGE_SPACE='0.5%'
```

## 生成compose文件
```shell
sudo ./script/build_compose.sh
```

## 启动
启动：
```shell
sudo docker-compose up -d
```

查看日志：
```shell
sudo docker logs nginx-fastdfs-0.1.0 -f
```


## 开放端口

开放Tracker端口
```shell
sudo ufw allow 22122
```

开放Storage端口
```shell
sudo ufw allow 23000
```

开放Nginx端口
```shell
sudo ufw allow 8888
```

## 浏览器下载测试
打开浏览器测试下面链接，注意要替换$tracker_ip与$storage_key（参考启动之后的日志中出现）

http://$tracker_ip:8888/$storage_key

## 觉得好用的话，请星一下支持一波，如有疑问请在issue提出~~~~
