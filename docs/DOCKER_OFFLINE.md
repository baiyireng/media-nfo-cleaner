# Docker 离线部署指南

本指南说明如何在离线环境中使用视频库清理工具的Docker镜像。

## 加载离线镜像

如果您已经下载了`media-nfo-cleaner-latest.tar`文件，可以使用以下命令加载Docker镜像：

```bash
docker load -i media-nfo-cleaner-latest.tar
```

加载完成后，可以使用以下命令验证镜像是否加载成功：

```bash
docker images | grep media-nfo-cleaner
```

预期输出：
```
baiyireng/media-nfo-cleaner     latest    a22bc704be3d    1 minutes ago    288MB
```

## 使用离线镜像

### 预览模式（推荐先使用）

```bash
# Windows CMD
docker run --rm -v "D:\Path\To\Videos":/data/video baiyireng/media-nfo-cleaner:latest /data/video --dry-run

# Linux/macOS
docker run --rm -v /path/to/videos:/data/video baiyireng/media-nfo-cleaner:latest /data/video --dry-run
```

### 回收模式

```bash
# Windows CMD
docker run --rm -v "D:\Path\To\Videos":/data/video -v "D:\Path\To\Recycle":/data/recycle baiyireng/media-nfo-cleaner:latest /data/video --recycle /data/recycle

# Linux/macOS
docker run --rm -v /path/to/videos:/data/video -v /path/to/recycle:/data/recycle baiyireng/media-nfo-cleaner:latest /data/video --recycle /data/recycle
```

### 直接删除模式（谨慎使用）

```bash
# Windows CMD
docker run --rm -v "D:\Path\To\Videos":/data/video baiyireng/media-nfo-cleaner:latest /data/video

# Linux/macOS
docker run --rm -v /path/to/videos:/data/video baiyireng/media-nfo-cleaner:latest /data/video
```

## 注意事项

1. **路径映射**：确保Docker容器中的路径`/data/video`正确映射到您的主机视频目录。

2. **Windows路径**：在Windows CMD中使用双引号包围路径，并使用反斜杠`\`。在PowerShell中可能需要不同的路径格式。

3. **权限问题**：确保Docker容器有足够权限访问和修改映射的目录。如遇权限问题，可以添加`--user`参数：
   ```bash
   docker run --rm --user $(id -u):$(id -g) -v /path/to/videos:/data/video baiyireng/media-nfo-cleaner:latest /data/video --dry-run
   ```

4. **回收目录**：使用回收模式时，确保回收目录存在并有足够空间。

5. **预览模式**：在首次使用时，强烈建议使用`--dry-run`选项预览将要删除的文件。

## 自定义Docker Compose

如果您希望使用Docker Compose，可以创建以下`docker-compose.yml`文件：

```yaml
version: '3.8'

services:
  media-nfo-cleaner:
    image: baiyireng/media-nfo-cleaner:latest
    container_name: media-nfo-cleaner
    volumes:
      - /path/to/your/video/library:/data/video
      - /path/to/recycle/directory:/data/recycle  # 可选，用于回收模式
    environment:
      - PYTHONUNBUFFERED=1
    command: ["/data/video"]  # 默认命令参数，可以修改为 --dry-run 或 --recycle /data/recycle
```

然后使用以下命令运行：

```bash
# 预览模式
docker-compose run --rm media-nfo-cleaner /data/video --dry-run

# 回收模式
docker-compose run --rm media-nfo-cleaner /data/video --recycle /data/recycle

# 直接删除
docker-compose run --rm media-nfo-cleaner /data/video
```

## 故障排除

### 镜像加载失败

如果加载镜像时遇到问题，请确认：

1. `media-nfo-cleaner-latest.tar`文件存在且未损坏
2. Docker服务正在运行
3. 有足够的磁盘空间

### 容器启动失败

如果容器启动失败，请检查：

1. 路径映射是否正确
2. 目录是否存在
3. 是否有足够的权限

### 路径问题（Windows）

在Windows中，如果遇到路径问题，可以尝试：

1. 使用PowerShell而不是CMD
2. 使用双正斜杠：`//d/path/to/videos`
3. 使用Docker for Windows的路径格式：`/d/path/to/videos`

## 获取帮助

要查看完整的帮助信息：

```bash
docker run --rm baiyireng/media-nfo-cleaner:latest
```

或者访问项目主页获取更多帮助和文档。