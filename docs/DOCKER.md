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

### 高级选项

#### 忽略特定目录

```bash
# 忽略单个目录
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run --ignore-dir "temp"

# 忽略多个目录
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run --ignore-dir "temp" --ignore-dir "sample" --ignore-dir "backup"
```

#### 限制目录大小

```bash
# 只处理小于1GB的目录
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run --max-dir-size "1GB"

# 只处理小于500MB的目录
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run --max-dir-size "512MB"
```

#### 限制文件大小

```bash
# 只处理小于10MB的残留文件
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run --max-file-size "10MB"

# 只处理小于100KB的残留文件
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run --max-file-size "100KB"
```

#### 组合选项

```bash
# 预览模式，忽略特定目录，并限制目录和文件大小
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run --ignore-dir "temp" --ignore-dir "sample" --max-dir-size "1GB" --max-file-size "10MB"

# 回收模式，忽略特定目录，并限制目录和文件大小
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  -v /path/to/recycle/directory:/data/recycle \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --recycle /data/recycle --ignore-dir "temp" --max-dir-size "2GB" --max-file-size "5MB"
```

### 大小单位说明

工具支持以下大小单位：

- **B** - 字节
- **KB** 或 **K** - 千字节 (1024字节)
- **MB** 或 **M** - 兆字节 (1024KB)
- **GB** 或 **G** - 吉字节 (1024MB)
- **TB** 或 **T** - 太字节 (1024GB)

如果不指定单位，默认为MB。

示例：
- `--max-dir-size "1.5GB"` - 1.5吉字节
- `--max-file-size "1024"` - 1024兆字节(默认单位)
- `--max-dir-size "500MB"` - 500兆字节
- `--max-file-size "10KB"` - 10千字节

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