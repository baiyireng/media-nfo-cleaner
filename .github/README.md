# DXP4800 NAS视频库清理工具

## 概述

这是一个用于清理DXP4800 NAS视频库中残留文件的智能工具，支持.nfo文件、预览图、缩略图等辅助文件的清理。

## 快速开始

### 远程一键安装

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/northsea4/mdcx-docker/main/install.sh)"
```

### Docker安装

```bash
docker pull northsea4/dxp4800-video-cleaner:latest
docker run -it --rm \
  -v /volume1/Video:/data/video \
  northsea4/dxp4800-video-cleaner:latest \
  /data/video --dry-run
```

## 主要特点

- 🔍 **智能识别**：自动识别.nfo文件及其关联视频
- 🛡️ **安全预览**：支持预览模式，安全检查待删除内容
- ♻️ **回收模式**：将删除内容移动到指定目录，避免永久丢失
- 🖥️ **跨平台**：支持Windows和Linux/NAS系统
- 🐳 **Docker支持**：提供Docker容器化部署

## 使用示例

### 预览模式（推荐首先使用）

```bash
# Linux/NAS
./scripts/video_library_cleaner.sh "/volume1/Video" --dry-run

# Windows
scripts\run_video_cleaner.bat "D:\Video" --dry-run
```

### 回收模式（安全删除）

```bash
# Linux/NAS
./scripts/recycle_video_cleaner.sh "/volume1/Video" "RecycleBin"

# Windows
scripts\run_video_cleaner.bat "D:\Video" --recycle "Recycle"
```

## 文档

- [基本使用指南](docs/README_video_cleaner.md)
- [NAS设置指南](docs/README_NAS_Setup.md)
- [多平台支持](docs/README_MultiPlatform.md)
- [贡献指南](CONTRIBUTING.md)

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。