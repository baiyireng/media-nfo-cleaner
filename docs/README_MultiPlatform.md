# DXP4800 NAS视频库清理工具 - 多平台支持

## 概述

本工具支持多个操作系统平台，包括Windows和Linux/NAS系统，方便在不同环境下使用。

## 文件说明

### 核心文件
- `video_library_cleaner.py` - 主要的Python清理脚本（跨平台）

### Windows平台文件
- `run_video_cleaner.bat` - Windows批处理脚本
- `example_usage.bat` - Windows示例用法脚本

### Linux/NAS平台文件
- `video_library_cleaner.sh` - Linux Shell脚本
- `recycle_video_cleaner.sh` - 回收模式专用脚本
- `example_usage.sh` - Linux示例用法脚本
- `install_for_nas.sh` - NAS系统安装脚本
- `create_nas_package.sh` - 创建NAS部署包脚本

### 文档文件
- `README_video_cleaner.md` - 主要使用说明
- `README_NAS_Setup.md` - NAS系统详细设置指南
- `README_MultiPlatform.md` - 本多平台支持说明

## 平台特定使用方法

### Windows系统

1. 直接双击运行批处理文件
2. 在命令提示符中运行批处理文件
3. 在PowerShell中运行批处理文件

```cmd
# 示例
run_video_cleaner.bat "D:\Video" --dry-run
```

### Linux/NAS系统

1. 通过SSH连接到NAS
2. 上传文件到NAS
3. 设置执行权限并运行

```bash
# 设置权限
chmod +x *.sh

# 运行示例
./video_library_cleaner.sh "/volume1/Video" --dry-run
```

## 快速部署到NAS

### 方法一：使用安装脚本（推荐）

1. 上传所有文件到NAS
2. 运行安装脚本：
```bash
chmod +x install_for_nas.sh
./install_for_nas.sh
```

### 方法二：使用部署包

1. 在本地创建部署包：
```bash
chmod +x create_nas_package.sh
./create_nas_package.sh
```

2. 上传生成的.tar.gz文件到NAS
3. 在NAS上解压并安装：
```bash
tar -xzf dxp4800_video_cleaner_*.tar.gz
cd dxp4800_video_cleaner
chmod +x *.sh
./install_for_nas.sh
```

## 常见NAS系统路径

### DXP4800
- 视频: `/volume1/Video`
- 电影: `/volume1/Movies`
- 电视剧: `/volume1/TV Shows`

### Synology DSM
- 视频: `/volume1/video`
- 电影: `/volume1/movies`
- 家庭视频: `/volume1/homes/username/video`

### QNAP QTS
- 视频: `/share/CACHEDEV1_DATA/Multimedia/Videos`
- 电影: `/share/Multimedia/Movies`

### TrueNAS
- 视频: `/mnt/tank/media/videos`
- 电影: `/mnt/tank/media/movies`

## 平台差异说明

### 路径分隔符
- Windows: 使用反斜杠 `\` 作为路径分隔符
- Linux/NAS: 使用正斜杠 `/` 作为路径分隔符

### 权限模型
- Windows: 基于NTFS权限
- Linux/NAS: 基于Unix权限（读/写/执行）

### 脚本执行
- Windows: 使用.bat文件，由cmd.exe执行
- Linux/NAS: 使用.sh文件，由bash执行

### Python命令
- Windows: 通常使用 `python` 命令
- Linux/NAS: 通常使用 `python3` 命令

## 故障排除

### Windows平台
1. 确保Python已安装并添加到PATH
2. 可能需要以管理员身份运行
3. 检查防病毒软件是否阻止脚本执行

### Linux/NAS平台
1. 确保Python3已安装
2. 检查脚本是否有执行权限
3. 检查目录访问权限
4. 查看系统日志获取更多错误信息

## 定制与扩展

### 添加新的文件类型
修改`VIDEO_EXTENSIONS`变量，添加新的视频文件扩展名。

### 自定义检查逻辑
修改`check_video_exists`函数，实现特定的文件存在性检查逻辑。

### 添加新的清理规则
扩展`process_directory`函数，添加新的清理条件和操作。

## 版本控制

建议在不同平台使用同一版本的工具文件，以确保行为一致。

## 技术支持

如遇到问题，请检查：
1. Python版本兼容性
2. 文件权限设置
3. 路径格式是否正确
4. 系统日志中的错误信息