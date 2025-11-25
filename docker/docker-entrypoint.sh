#!/bin/bash
# Docker容器启动脚本

# 设置编码
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# 显示帮助信息
if [ $# -eq 0 ]; then
    echo "视频库清理工具 - Docker版本"
    echo
    echo "用法:"
    echo "  docker run [OPTIONS] baiyiren/media-nfo-cleaner:latest [视频目录] [选项]"
    echo
    echo "选项:"
    echo "  --dry-run               预览模式，不实际删除文件"
    echo "  --recycle [目录]        回收模式，将删除内容移动到指定目录"
    echo "  --archive [目录]         归档模式，将既无视频文件也无残留文件的目录移动到指定目录"
    echo "  --ignore-dir [目录]      指定要忽略的目录，可多次使用"
    echo "  --max-dir-size [大小]    限制处理的目录最大大小，支持KB, MB, GB等单位"
    echo "  --max-file-size [大小]    限制处理的文件最大大小，支持KB, MB, GB等单位"
    echo
    echo "示例:"
    echo "  # 预览模式"
    echo "  docker run -v /volume1/Video:/data/video baiyiren/media-nfo-cleaner:latest /data/video --dry-run"
    echo
    echo "  # 回收模式"
    echo "  docker run -v /volume1/Video:/data/video -v /volume1/homes/admin/recycle:/data/recycle baiyiren/media-nfo-cleaner:latest /data/video --recycle /data/recycle"
    echo
    echo "  # 忽略目录并限制大小"
    echo "  docker run -v /volume1/Video:/data/video baiyiren/media-nfo-cleaner:latest /data/video --ignore-dir \"temp\" --ignore-dir \"sample\" --max-dir-size 1GB"
    echo
    echo "  # 限制文件大小"
    echo "  docker run -v /volume1/Video:/data/video baiyiren/media-nfo-cleaner:latest /data/video --max-file-size 10MB"
    echo
    echo "  # 归档空目录"
    echo "  docker run -v /volume1/Video:/data/video -v /volume1/Archive:/data/archive baiyiren/media-nfo-cleaner:latest /data/video --archive /data/archive"
    exit 0
fi

# 默认参数
VIDEO_DIR=""
ARGS=""

# 解析参数，保留所有参数传递给Python脚本
while [[ $# -gt 0 ]]; do
    if [ -z "$VIDEO_DIR" ]; then
        VIDEO_DIR="$1"
    else
        # 将所有其他参数添加到ARGS变量中
        if [ -z "$ARGS" ]; then
            ARGS="$1"
        else
            ARGS="$ARGS $1"
        fi
    fi
    shift
done

# 检查视频目录是否指定
if [ -z "$VIDEO_DIR" ]; then
    echo "错误: 未指定视频目录"
    echo "使用 --help 查看使用说明"
    exit 1
fi

# 检查视频目录是否存在
if [ ! -d "$VIDEO_DIR" ]; then
    echo "错误: 视频目录 '$VIDEO_DIR' 不存在"
    exit 1
fi

# 构建命令
if [ -n "$ARGS" ]; then
    CMD="python3 /app/video_library_cleaner.py '$VIDEO_DIR' $ARGS"
else
    CMD="python3 /app/video_library_cleaner.py '$VIDEO_DIR'"
fi

# 显示模式信息
echo "==============================================="
echo "视频库清理工具 - Docker版本"
echo "==============================================="
echo "视频目录: $VIDEO_DIR"

if [ "$RECYCLE_MODE" = true ]; then
    echo "运行模式: 回收模式"
    echo "回收目录: $RECYCLE_DIR"
elif [ "$DRY_RUN" = true ]; then
    echo "运行模式: 预览模式"
else
    echo "运行模式: 直接删除模式"
fi

echo "==============================================="
echo

# 执行命令
eval $CMD