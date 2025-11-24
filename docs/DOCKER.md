# Docker 部署指南

本指南说明如何使用Docker部署视频库清理工具。

## 一键Docker部署

我们提供了一键Docker部署脚本，简化了部署流程。

### Windows系统

```cmd
# 添加执行权限（如果需要）
# 右键点击CMD或PowerShell，选择"以管理员身份运行"

# 便捷启动脚本
scripts\\docker_deploy.bat "D:\\Video"

# 回收模式
scripts\\docker_deploy.bat "D:\\Video" "D:\\Recycle"
```

### Linux/macOS系统

```bash
# 添加执行权限
chmod +x scripts/docker_deploy.sh

# 便捷启动脚本
./scripts/docker_deploy.sh "/volume1/Video"

# 回收模式
./scripts/docker_deploy.sh "/volume1/Video" "/volume1/Recycle"
```

## 构建Docker镜像

### 从源代码构建

1. 克隆代码仓库：
```bash
git clone https://github.com/baiyireng/media-nfo-cleaner.git
cd media-nfo-cleaner
```

2. 构建Docker镜像：
```bash
docker build -t baiyiren/media-nfo-cleaner:latest -f docker/Dockerfile .
```

3. 或者使用Docker Compose构建：
```bash
docker-compose --profile build build
```

### 从Docker Hub拉取（如果已发布）

```bash
docker pull baiyiren/media-nfo-cleaner:latest
```

## 使用Docker镜像

### 预览模式（推荐先使用此模式检查将要删除的文件）

```bash
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run
```

### 回收模式（将删除的文件移动到回收目录）

```bash
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  -v /path/to/recycle/directory:/data/recycle \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --recycle /data/recycle
```

### 直接删除模式（谨慎使用）

```bash
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video
```

### 使用Docker Compose

1. 修改`docker-compose.yml`中的卷路径：
```yaml
volumes:
  - /your/actual/video/path:/data/video
  - /your/actual/recycle/path:/data/recycle  # 可选
```

2. 使用预览模式运行：
```bash
docker-compose run --rm media-nfo-cleaner /data/video --dry-run
```

3. 使用回收模式运行：
```bash
docker-compose run --rm media-nfo-cleaner /data/video --recycle /data/recycle
```

4. 使用直接删除模式运行：
```bash
docker-compose run --rm media-nfo-cleaner /data/video
```

## 注意事项

1. **路径映射**：确保Docker容器中的路径`/data/video`正确映射到您的主机视频目录。

2. **权限问题**：确保Docker容器有足够权限访问和修改映射的目录。

3. **回收目录**：使用回收模式时，确保回收目录存在并有足够空间。

4. **预览模式**：在首次使用时，强烈建议使用`--dry-run`选项预览将要删除的文件。

5. **NAS系统**：在NAS系统上使用时，请确保Docker服务已正确安装并配置了适当的卷权限。

## 故障排除

### 权限问题

如果遇到权限问题，可以尝试：

```bash
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  --user $(id -u):$(id -g) \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run
```

### 日志查看

查看详细日志：

```bash
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run --verbose
```

### 交互模式

进入容器进行调试：

```bash
docker run --rm -it \
  -v /path/to/your/video/library:/data/video \
  --entrypoint /bin/bash \
  baiyiren/media-nfo-cleaner:latest
```