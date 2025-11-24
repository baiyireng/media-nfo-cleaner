# DXP4800 NAS视频库清理工具 - Linux/NAS系统设置指南

本文档介绍如何在DXP4800 NAS或其他基于Linux的NAS系统上部署和使用视频库清理工具。

## 系统要求

- DXP4800 NAS或兼容的Linux系统
- Python 3.x（大多数NAS系统已预装）
- SSH访问权限（推荐）

## 安装步骤

### 1. 连接到NAS

通过SSH连接到您的DXP4800 NAS：
```bash
ssh admin@[您的NAS IP地址]
```

### 2. 创建工作目录

```bash
# 创建工具目录
mkdir -p /volume1/homes/admin/video_cleaner
cd /volume1/homes/admin/video_cleaner
```

### 3. 上传文件

将以下文件上传到NAS上的工具目录：
- video_library_cleaner.py
- video_library_cleaner.sh
- recycle_video_cleaner.sh
- example_usage.sh

您可以使用SCP命令从本地上传：
```bash
scp video_library_cleaner.py admin@[您的NAS IP地址]:/volume1/homes/admin/video_cleaner/
scp video_library_cleaner.sh admin@[您的NAS IP地址]:/volume1/homes/admin/video_cleaner/
scp recycle_video_cleaner.sh admin@[您的NAS IP地址]:/volume1/homes/admin/video_cleaner/
scp example_usage.sh admin@[您的NAS IP地址]:/volume1/homes/admin/video_cleaner/
```

### 4. 设置执行权限

```bash
cd /volume1/homes/admin/video_cleaner
chmod +x *.sh
```

## 常见NAS目录结构

### DXP4800 NAS常见目录
- `/volume1/Video` - 主要视频目录
- `/volume1/Movies` - 电影目录
- `/volume1/TV Shows` - 电视剧目录
- `/volume1/Downloads` - 下载目录

### 其他NAS系统目录
- Synology DSM: `/volume1/video`, `/volume1/movies`
- QNAP QTS: `/share/CACHEDEV1_DATA/Multimedia/Videos`
- TrueNAS: `/mnt/tank/media/videos`

## 使用方法

### 1. 预览模式（推荐首先使用）

```bash
./video_library_cleaner.sh "/volume1/Video" --dry-run
```

### 2. 回收模式（推荐）

```bash
./recycle_video_cleaner.sh "/volume1/Video" "Recycle"
```

### 3. 直接删除模式（谨慎使用）

```bash
./video_library_cleaner.sh "/volume1/Video"
```

## 定时清理设置

您可以使用cron job设置定时清理任务：

1. 编辑crontab：
```bash
crontab -e
```

2. 添加定时任务（例如每月1号凌晨2点执行）：
```bash
0 2 1 * * /volume1/homes/admin/video_cleaner/recycle_video_cleaner.sh "/volume1/Video" "Recycle"
```

## NAS特定注意事项

1. **权限问题**：确保脚本有权限访问视频目录和创建回收站目录

2. **网络驱动器**：如果视频存储在网络挂载的驱动器上，确保挂载点正确

3. **资源限制**：大型视频库可能消耗较多系统资源，建议在低负载时段运行

4. **备份重要数据**：尽管有回收模式，仍建议定期备份重要数据

## 故障排除

### Python找不到错误

如果出现"Python not found"错误，可能需要安装Python：

```bash
# 对于大多数基于Debian的系统
sudo apt-get update
sudo apt-get install python3

# 对于大多数基于Red Hat的系统
sudo yum install python3

# 对于DSM (Synology)
sudo opkg install python3
```

### 权限问题

如果遇到权限问题，可以尝试：

```bash
# 获取目录所有权
sudo chown -R admin:users /volume1/homes/admin/video_cleaner

# 添加执行权限
chmod +x video_library_cleaner.sh
```

### 性能优化

对于大型视频库，可以考虑：

1. 限制扫描深度
2. 分批处理不同目录
3. 使用SSD缓存加速

## 通过Web界面访问

某些NAS系统允许通过Web界面访问shell：

1. 登录NAS管理界面
2. 找到终端或控制台选项
3. 上传并运行脚本

## 日志记录

要记录清理过程，可以重定向输出：

```bash
./recycle_video_cleaner.sh "/volume1/Video" "Recycle" > /volume1/homes/admin/video_cleaner/logs/$(date +%Y%m%d).log 2>&1
```