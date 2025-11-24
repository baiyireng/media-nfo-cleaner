# 视频库清理工具

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue.svg)](https://github.com/baiyireng/media-nfo-cleaner)
[![Python Version](https://img.shields.io/badge/python-3.6%2B-green.svg)](https://python.org)

一个用于清理视频库中残留文件（.nfo、预览图、缩略图等）的智能工具，支持安全预览、回收模式和直接删除多种清理方式。适用于NAS系统、个人电脑和服务器。

## 主要特点

- 🔍 **智能识别**：自动识别.nfo文件及其关联视频
- 🗂️ **目录处理**：处理根目录和子目录中的残留文件
- 🛡️ **安全预览**：支持预览模式，安全检查待删除内容
- ♻️ **回收模式**：将删除内容移动到指定目录，避免永久丢失
- 🖥️ **跨平台**：支持Windows、Linux、macOS和NAS系统
- 🐳 **Docker支持**：提供Docker容器化部署
- 🚀 **一键安装**：支持远程一键安装脚本

## 快速开始

### 一键Docker部署

我们提供了一键Docker部署脚本，支持Windows和Linux/macOS系统，自动处理镜像拉取、容器运行等所有步骤。

#### Windows系统

```cmd
# 添加执行权限（如果需要）
# 右键点击CMD或PowerShell，选择"以管理员身份运行"

# 便捷启动脚本
scripts\\docker_deploy.bat "D:\\Video"

# 回收模式
scripts\\docker_deploy.bat "D:\\Video" "D:\\Recycle"
```

#### Linux/macOS系统

```bash
# 添加执行权限
chmod +x scripts/docker_deploy.sh

# 便捷启动脚本
./scripts/docker_deploy.sh "/volume1/Video"

# 回收模式
./scripts/docker_deploy.sh "/volume1/Video" "/volume1/Recycle"
```

### 远程一键安装（推荐）

**Linux/macOS用户**:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.sh)"
```

**Windows用户**:
1. 打开命令提示符（CMD）
2. 复制并运行以下命令：

```cmd
# 下载安装脚本
curl -L -o install.bat https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat

# 运行安装脚本
start install.bat
```

或者使用PowerShell（推荐）：

```powershell
# 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 下载并运行安装脚本（推荐使用WebClient确保UTF-8编码）
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wc = New-Object System.Net.WebClient
$wc.Encoding = [System.Text.Encoding]::UTF8
$wc.DownloadFile('https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.ps1', 'install.ps1')
.\install.ps1
```

或者直接下载并运行 `install.bat` 或 `install.ps1` 文件:
- https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat
- https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.ps1

### 本地安装

#### Windows系统
```cmd
# 克隆仓库
git clone https://github.com/baiyireng/media-nfo-cleaner.git
cd media-nfo-cleaner

# 直接运行安装脚本
scripts\run_video_cleaner.bat --help
```

#### Linux/NAS系统
```bash
# 克隆仓库
git clone https://github.com/baiyireng/media-nfo-cleaner.git
cd media-nfo-cleaner

# 运行安装脚本
chmod +x install/install_for_nas.sh
./install/install_for_nas.sh
```

### 手动Docker方式

如果您更喜欢手动操作，也可以使用以下命令：

```bash
# 拉取镜像
docker pull baiyiren/media-nfo-cleaner:latest

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
```

详细Docker使用指南请参考：[Docker部署指南](docs/DOCKER.md)

## 平台特定启动命令

### Windows系统

#### 预览模式
```cmd
# 方法1: 使用安装脚本
scripts\run_video_cleaner.bat "D:\Video" --dry-run

# 方法2: 直接运行Python
python bin\video_library_cleaner.py "D:\Video" --dry-run

# 方法3: 使用便捷启动脚本（安装后可用）
quick-start.bat
```

#### 回收模式
```cmd
# 使用安装脚本
scripts\run_video_cleaner.bat "D:\Video" --recycle "Recycle"

# 使用便捷启动脚本
quick-start.bat
```

#### 注意事项（Windows）
- 路径中使用反斜杠 `\` 或双引号包围路径
- 建议使用CMD而不是PowerShell运行批处理脚本
- 某些防病毒软件可能会误报，需要添加到白名单
- 长路径可能需要使用引号包围

### Linux/NAS系统

#### 预览模式
```bash
# 方法1: 使用安装脚本
./scripts/video_library_cleaner.sh "/volume1/Video" --dry-run

# 方法2: 直接运行Python
python3 bin/video_library_cleaner.py "/volume1/Video" --dry-run

# 方法3: 使用便捷启动脚本（安装后可用）
./quick-cleaner
```

#### 回收模式
```bash
# 使用安装脚本
./scripts/recycle_video_cleaner.sh "/volume1/Video" "RecycleBin"

# 直接运行Python
python3 bin/video_library_cleaner.py "/volume1/Video" --recycle "/volume1/Video/RecycleBin"
```

#### 注意事项（Linux/NAS）
- 路径中使用正斜杠 `/`
- 确保脚本有执行权限：`chmod +x scripts/*.sh`
- 处理大目录时可能需要使用`nice`命令降低优先级
- 确保有足够磁盘空间用于回收目录

### macOS系统

#### 预览模式
```bash
# 使用安装脚本
./scripts/video_library_cleaner.sh "/Users/username/Movies" --dry-run

# 直接运行Python
python3 bin/video_library_cleaner.py "/Users/username/Movies" --dry-run
```

#### 回收模式
```bash
# 使用安装脚本
./scripts/recycle_video_cleaner.sh "/Users/username/Movies" "MediaRecycle"
```

#### 注意事项（macOS）
- 可能需要安装Python 3.x: `brew install python3`
- 路径中的空格需要使用引号包围
- 文件权限可能需要调整：`chmod +x scripts/*.sh`

### Docker模式

#### 预览模式
```bash
docker run -it --rm \
  -v /volume1/Video:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run
```

#### 回收模式
```bash
docker run -it --rm \
  -v /volume1/Video:/data/video \
  -v /volume1/homes/admin/recycle:/data/recycle \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --recycle /data/recycle
```

#### docker-compose方式
```bash
# 下载docker-compose.yml
curl -fsSL https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/docker/docker-compose.yml -o docker-compose.yml

# 修改命令为回收模式后启动
docker-compose up
```

#### 注意事项（Docker）
- 确保挂载的本地目录存在且权限正确
- Windows下Docker路径使用正斜杠 `/`
- 回收目录挂载点必须存在

## 高级用法

### 定时清理（Linux/macOS）
```bash
# 添加到crontab，每月1号凌晨2点执行
echo "0 2 1 * * /path/to/media-nfo-cleaner/scripts/recycle_video_cleaner.sh '/volume1/Video' '/volume1/Video/Recycle' >> /var/log/video-cleaner.log 2>&1" | crontab -
```

### 定时清理（Windows）
```cmd
# 创建任务计划程序任务，每月1号凌晨2点执行
schtasks /create /tn "VideoCleaner" /tr "C:\path\to\media-nfo-cleaner\scripts\run_video_cleaner.bat" /sc monthly /d 1 /st 02:00
```

### 递归深度限制
```bash
# 仅处理2层深的目录
python3 bin/video_library_cleaner.py "/volume1/Video" --max-depth 2 --dry-run
```

## 项目结构

```
media-nfo-cleaner/
├── bin/                    # 核心二进制和脚本文件
│   └── video_library_cleaner.py
├── scripts/                # 平台特定运行脚本
│   ├── run_video_cleaner.bat
│   ├── recycle_video_cleaner.bat
│   ├── video_library_cleaner.sh
│   └── recycle_video_cleaner.sh
├── install/                # 安装和部署脚本
│   ├── install_for_nas.sh
│   └── create_nas_package.sh
├── examples/               # 使用示例
│   ├── example_usage.bat
│   └── example_usage.sh
├── docs/                   # 文档
│   ├── README_video_cleaner.md
│   ├── README_NAS_Setup.md
│   └── README_MultiPlatform.md
├── docker/                 # Docker相关文件
│   ├── Dockerfile
│   └── docker-compose.yml
├── install.sh              # 远程安装脚本
├── install.bat              # Windows批处理安装脚本
├── install.ps1              # PowerShell安装脚本
└── README.md               # 主要说明文档
```

## 支持的视频格式

- .mp4, .mkv, .avi, .mov, .wmv, .flv, .webm, .m4v
- .3gp, .mpg, .mpeg, .ts, .m2ts, .rm, .rmvb
- .divx, .xvid, .f4v, .asf, .vob, .ogv

## 识别的残留文件类型

- .nfo文件
- 预览图和缩略图（poster.jpg, fanart.jpg等）
- 媒体信息文件
- 压缩文件
- 其他辅助文件

## 文档

- [基本使用指南](docs/README_video_cleaner.md)
- [NAS设置指南](docs/README_NAS_Setup.md)
- [多平台支持](docs/README_MultiPlatform.md)
- [Windows安装指南](WINDOWS_INSTALL.md)

## 贡献

欢迎提交问题报告、功能请求和代码贡献！

1. Fork 本仓库
2. 创建功能分支：`git checkout -b feature/AmazingFeature`
3. 提交更改：`git commit -m 'Add some AmazingFeature'`
4. 推送到分支：`git push origin feature/AmazingFeature`
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 免责声明

使用本工具前请务必备份重要数据。尽管提供了预览和回收模式，但作者不对任何数据丢失负责。