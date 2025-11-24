# DXP4800 NAS 视频库清理工具

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-blue.svg)](https://github.com/northsea4/mdcx-docker)
[![Python Version](https://img.shields.io/badge/python-3.6%2B-green.svg)](https://python.org)

一个用于清理DXP4800 NAS视频库中残留文件（.nfo、预览图、缩略图等）的智能工具，支持安全预览、回收模式和直接删除多种清理方式。

## 主要特点

- 🔍 **智能识别**：自动识别.nfo文件及其关联视频
- 🗂️ **目录处理**：处理根目录和子目录中的残留文件
- 🛡️ **安全预览**：支持预览模式，安全检查待删除内容
- ♻️ **回收模式**：将删除内容移动到指定目录，避免永久丢失
- 🖥️ **跨平台**：支持Windows和Linux/NAS系统
- 🐳 **Docker支持**：提供Docker容器化部署
- 🚀 **一键安装**：支持远程一键安装脚本

## 快速开始

### 远程一键安装（推荐）

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/northsea4/mdcx-docker/main/install.sh)"
```

### 本地快速安装

#### Windows系统
```cmd
# 克隆仓库
git clone https://github.com/northsea4/mdcx-docker.git
cd mdcx-docker

# 运行安装脚本
scripts\run_video_cleaner.bat --help
```

#### Linux/NAS系统
```bash
# 克隆仓库
git clone https://github.com/northsea4/mdcx-docker.git
cd mdcx-docker

# 运行安装脚本
chmod +x install/install_for_nas.sh
./install/install_for_nas.sh
```

### Docker部署

```bash
# 拉取镜像
docker pull northsea4/dxp4800-video-cleaner:latest

# 运行容器（挂载视频目录）
docker run -it --rm \
  -v /volume1/Video:/data/video \
  -v /volume1/homes/admin/video_cleaner/recycle:/data/recycle \
  northsea4/dxp4800-video-cleaner:latest \
  /data/video --recycle /data/recycle
```

## 使用示例

### 预览模式（推荐首先使用）

**Windows**:
```cmd
scripts\run_video_cleaner.bat "D:\Video" --dry-run
```

**Linux/NAS**:
```bash
scripts/video_library_cleaner.sh "/volume1/Video" --dry-run
```

### 回收模式（安全删除）

**Windows**:
```cmd
scripts\run_video_cleaner.bat "D:\Video" --recycle "Recycle"
```

**Linux/NAS**:
```bash
scripts/recycle_video_cleaner.sh "/volume1/Video" "RecycleBin"
```

### Docker模式

```bash
# 预览模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  northsea4/dxp4800-video-cleaner:latest \
  /data/video --dry-run

# 回收模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  -v /volume1/homes/admin/recycle:/data/recycle \
  northsea4/dxp4800-video-cleaner:latest \
  /data/video --recycle /data/recycle
```

## 项目结构

```
dxp4800-video-cleaner/
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

## 贡献

欢迎提交问题报告、功能请求和代码贡献！

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 免责声明

使用本工具前请务必备份重要数据。尽管提供了预览和回收模式，但作者不对任何数据丢失负责。