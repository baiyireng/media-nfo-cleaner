# 快速安装指南

## 远程一键安装

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/northsea4/mdcx-docker/main/install.sh)"
```

## Docker安装

```bash
# 拉取镜像
docker pull northsea4/dxp4800-video-cleaner:latest

# 运行预览模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  northsea4/dxp4800-video-cleaner:latest \
  /data/video --dry-run

# 运行回收模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  -v /volume1/homes/admin/recycle:/data/recycle \
  northsea4/dxp4800-video-cleaner:latest \
  /data/video --recycle /data/recycle
```

## 使用docker-compose

```bash
# 下载docker-compose.yml
curl -fsSL https://raw.githubusercontent.com/northsea4/mdcx-docker/main/docker/docker-compose.yml -o docker-compose.yml

# 启动服务（预览模式）
docker-compose up

# 修改命令为回收模式后再次启动
# 将command字段改为: ["/data/video", "--recycle", "/data/recycle"]
```