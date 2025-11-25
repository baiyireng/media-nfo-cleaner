# 平台启动命令速查表

## Windows

### 安装
```cmd
# 远程安装
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat' -OutFile 'install.bat'; .\install.bat"

# 本地安装
git clone https://github.com/baiyireng/media-nfo-cleaner.git
cd media-nfo-cleaner
scripts\run_video_cleaner.bat --help
```

### 启动
```cmd
# 预览模式
scripts\run_video_cleaner.bat "D:\Video" --dry-run

# 回收模式
scripts\run_video_cleaner.bat "D:\Video" --recycle "D:\Video\Recycle"

# 直接删除
scripts\run_video_cleaner.bat "D:\Video"

# 便捷启动（安装后）
quick-start.bat
```

### Docker 启动
```cmd
# 一键Docker部署
scripts\docker_deploy.bat "D:\Video"

# 回收模式
scripts\docker_deploy.bat "D:\Video" "D:\Recycle"

# 手动Docker启动
docker run --rm -v "D:\Video":/data/video baiyiren/media-nfo-cleaner:latest /data/video --dry-run
docker run --rm -v "D:\Video":/data/video -v "D:\Recycle":/data/recycle baiyiren/media-nfo-cleaner:latest /data/video --recycle /data/recycle
```

### 注意事项
- 路径使用反斜杠 `\`
- 空格路径需要双引号
- 需要Python环境
- 可能需要管理员权限

---

## Linux/NAS

### 安装
```bash
# 远程安装
bash -c "$(curl -fsSL https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.sh)"

# 本地安装
git clone https://github.com/baiyireng/media-nfo-cleaner.git
cd media-nfo-cleaner
chmod +x install/install_for_nas.sh
./install/install_for_nas.sh
```

### 启动
```bash
# 预览模式
./scripts/video_library_cleaner.sh "/volume1/Video" --dry-run

# 回收模式
./scripts/recycle_video_cleaner.sh "/volume1/Video" "/volume1/Video/RecycleBin"

# 直接删除
./scripts/video_library_cleaner.sh "/volume1/Video"

# 便捷启动（安装后）
./quick-cleaner
```

### Docker 启动
```bash
# 一键Docker部署
./scripts/docker_deploy.sh "/volume1/Video"

# 回收模式
./scripts/docker_deploy.sh "/volume1/Video" "/volume1/Recycle"

# 手动Docker启动
docker run --rm -v /volume1/Video:/data/video baiyiren/media-nfo-cleaner:latest /data/video --dry-run
docker run --rm -v /volume1/Video:/data/video -v /volume1/Recycle:/data/recycle baiyiren/media-nfo-cleaner:latest /data/video --recycle /data/recycle
```

### 注意事项
- 路径使用正斜杠 `/`
- 需要Python3环境
- 确保脚本有执行权限
- 可能需要sudo权限
- Docker中路径映射需要使用绝对路径

---

## macOS

### 安装
```bash
# 安装Homebrew（如果未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装Python3（如果未安装）
brew install python3

# 远程安装工具
bash -c "$(curl -fsSL https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.sh)"
```

### 启动
```bash
# 预览模式
./scripts/video_library_cleaner.sh "/Users/username/Movies" --dry-run

# 回收模式
./scripts/recycle_video_cleaner.sh "/Users/username/Movies" "/Users/username/Movies/Recycle"
```

### Docker 启动
```bash
# 一键Docker部署
./scripts/docker_deploy.sh "/Users/username/Movies"

# 回收模式
./scripts/docker_deploy.sh "/Users/username/Movies" "/Users/username/Movies/Recycle"

# 手动Docker启动
docker run --rm -v /Users/username/Movies:/data/video baiyiren/media-nfo-cleaner:latest /data/video --dry-run
docker run --rm -v /Users/username/Movies:/data/video -v /Users/username/Movies/Recycle:/data/recycle baiyiren/media-nfo-cleaner:latest /data/video --recycle /data/recycle
```

### 注意事项
- 路径使用正斜杠 `/`
- 可能需要安装Python3
- 文件权限可能需要调整
- Docker中路径映射需要使用绝对路径

---

## Docker 通用

### 安装
```bash
# 拉取镜像
docker pull baiyiren/media-nfo-cleaner:latest

# 使用docker-compose
curl -fsSL https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/docker/docker-compose.yml -o docker-compose.yml
```

### 启动
```bash
# 预览模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run

# 回收模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  -v /volume1/homes/admin/recycle:/data/recycle \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --recycle /data/recycle

# docker-compose
docker-compose up
```

### 注意事项
- 确保挂载的本地目录存在
- 回收目录挂载点必须存在
- Windows下Docker路径使用正斜杠

---

## 常用参数

### 通用参数
- `--dry-run`：预览模式，只显示不执行
- `--recycle [目录]`：回收模式，指定回收目录
- `--max-depth [数字]`：限制递归深度
- `--help`：显示帮助信息

### 示例组合
```bash
# 限制递归2层，预览模式
python3 bin/video_library_cleaner.py "/volume1/Video" --dry-run --max-depth 2

# 使用绝对路径作为回收目录
python3 bin/video_library_cleaner.py "/volume1/Video" --recycle "/tmp/recycle"
```

---

## 定时清理

### Linux/macOS（crontab）
```bash
# 编辑crontab
crontab -e

# 添加每月1号凌晨2点执行
0 2 1 * * /path/to/media-nfo-cleaner/scripts/recycle_video_cleaner.sh '/volume1/Video' '/volume1/Video/Recycle' >> /var/log/video-cleaner.log 2>&1
```

### Windows（任务计划程序）
```cmd
# 创建月度任务
schtasks /create /tn "VideoCleaner" /tr "C:\path\to\media-nfo-cleaner\scripts\run_video_cleaner.bat" /sc monthly /d 1 /st 02:00 /ru SYSTEM
```

---

## 故障排除

| 问题 | Windows解决方案 | Linux解决方案 |
|------|----------------|---------------|
| 命令未找到 | 检查PATH环境变量 | 使用which命令确认 |
| 权限不足 | 以管理员身份运行 | 使用sudo或检查文件权限 |
| Python缺失 | 安装脚本会自动下载 | 安装python3包 |
| 磁盘空间不足 | 清理磁盘或更换回收目录 | 使用df检查空间 |
| 网络连接失败 | 检查防火墙设置 | 使用ping测试连接 |
| 路径错误 | 使用绝对路径 | 使用ls检查路径 |
| 文件名有空格 | 用双引号包围路径 | 使用转义字符 |

---

## 更多信息

- [项目主页](https://github.com/baiyireng/media-nfo-cleaner)
- [完整文档](https://github.com/baiyireng/media-nfo-cleaner/tree/main/docs)
- [问题反馈](https://github.com/baiyireng/media-nfo-cleaner/issues)