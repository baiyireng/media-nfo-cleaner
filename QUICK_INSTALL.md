# 快速安装指南

## 远程一键安装

**Linux/macOS用户**:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.sh)"
```

**Windows用户**:
1. 打开命令提示符（CMD）或PowerShell
2. 复制并运行以下命令：
```cmd
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat' -OutFile 'install.bat'; .\install.bat"
```

或者直接下载并运行 `install.bat` 文件:
https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat

## Docker安装

```bash
# 拉取镜像
docker pull baiyireng/media-nfo-cleaner:latest

# 运行预览模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  baiyireng/media-nfo-cleaner:latest \
  /data/video --dry-run

# 运行回收模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  -v /volume1/homes/admin/recycle:/data/recycle \
  baiyireng/media-nfo-cleaner:latest \
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