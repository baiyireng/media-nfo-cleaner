# DXP4800 NAS视频库清理工具

这个工具用于清理DXP4800 NAS服务器上视频库中的残留文件，包括.nfo文件、预览图、缩略图等辅助文件。

## 跨平台支持

本工具支持多种操作系统：
- **Windows**：使用.bat批处理文件
- **Linux/NAS**：使用.sh Shell脚本（适用于DXP4800等基于Linux的NAS系统）

## 功能特点

- 自动识别.nfo文件（包括根目录下的.nfo文件）
- 检查.nfo文件对应的视频文件是否存在（支持相对路径和绝对路径）
- 确认目录中没有其他视频文件后才删除残留目录
- 支持预览模式，可以安全地查看将要删除的内容
- 智能处理根目录及其同级目录下的.nfo文件
- **新增回收模式**：将删除内容移动到指定目录而非永久删除
- 自动忽略回收站目录，避免循环处理

## 使用方法

### Windows系统

#### 方法一：使用批处理文件（推荐）

```bash
run_video_cleaner.bat "视频目录路径" [选项]
```

示例：
```bash
# 预览模式（安全查看将要删除的目录）
run_video_cleaner.bat "D:\Video" --dry-run

# 直接删除模式
run_video_cleaner.bat "D:\Video"

# 回收模式（移动到指定目录）
run_video_cleaner.bat "D:\Video" --recycle "Recycle"
```

#### 方法二：直接运行Python脚本

```bash
python video_library_cleaner.py "视频目录路径" [选项]
```

示例：
```bash
# 预览模式
python video_library_cleaner.py "D:\Video" --dry-run

# 直接删除模式
python video_library_cleaner.py "D:\Video"

# 回收模式
python video_library_cleaner.py "D:\Video" --recycle "Recycle"
```

### Linux/NAS系统

#### 方法一：使用Shell脚本（推荐）

```bash
./video_library_cleaner.sh "视频目录路径" [选项]
```

示例：
```bash
# 预览模式（安全查看将要删除的目录）
./video_library_cleaner.sh "/volume1/Video" --dry-run

# 直接删除模式
./video_library_cleaner.sh "/volume1/Video"

# 回收模式（移动到指定目录）
./video_library_cleaner.sh "/volume1/Video" --recycle "Recycle"
```

#### 方法二：使用专用回收模式脚本

```bash
./recycle_video_cleaner.sh "视频目录路径" [回收目录]
```

示例：
```bash
# 使用默认回收目录
./recycle_video_cleaner.sh "/volume1/Video"

# 指定回收目录
./recycle_video_cleaner.sh "/volume1/Video" "VideoRecycle"
```

#### 方法三：直接运行Python脚本

```bash
python3 video_library_cleaner.py "视频目录路径" [选项]
```

> **注意**：详细NAS安装和设置说明请参考 [README_NAS_Setup.md](README_NAS_Setup.md)

## 安全措施

1. **预览模式**：建议首先使用`--dry-run`选项预览将要删除的内容
2. **回收模式**：使用`--recycle`选项将删除内容移动到指定目录，避免永久丢失
3. **多重检查**：脚本会确认以下条件后才删除目录：
   - 目录中存在.nfo文件
   - .nfo文件对应的视频文件不存在
   - 目录中没有其他视频文件
4. **自动排除回收站**：脚本会自动忽略回收站目录，避免循环处理
5. **冲突处理**：回收站中存在同名文件时自动重命名，避免覆盖

## 支持的视频格式

脚本支持大多数常见视频格式：
- .mp4, .mkv, .avi, .mov, .wmv, .flv, .webm, .m4v
- .3gp, .mpg, .mpeg, .ts, .m2ts, .rm, .rmvb
- .divx, .xvid, .f4v, .asf, .vob, .ogv

## 检查逻辑

脚本会按以下逻辑处理文件和目录：

1. **根目录处理**：
   - 检查根目录下的每个.nfo文件
   - 查找同名的视频文件（不同扩展名）
   - 从.nfo文件内容中提取视频路径信息
   - 确认视频文件不存在后删除.nfo文件

2. **子目录处理**：
   - 扫描所有子目录中的.nfo文件
   - 检查目录中是否存在任何视频文件
   - 确认.nfo文件对应的视频不存在
   - 满足条件后删除整个目录

3. **路径解析**：
   - 支持.nfo文件中记录的相对路径和绝对路径
   - 自动尝试多种视频扩展名匹配
   - 智能处理各种文件名变化

## 识别的残留文件类型

- .nfo文件
- 各种预览图和缩略图（poster.jpg, fanart.jpg等）
- 媒体信息文件
- 压缩文件
- 其他辅助文件

## 注意事项

1. 在使用实际清理模式前，强烈建议先使用预览模式
2. 如果不确定，请先备份重要数据
3. 脚本需要Python 3.x环境
4. 路径中包含空格时，请使用双引号包围路径

## 故障排除

如果遇到问题，请检查：
1. Python是否正确安装
2. 脚本是否有足够的权限访问目标目录
3. 路径是否正确且存在

## 许可证

此工具为开源软件，可自由使用和修改。