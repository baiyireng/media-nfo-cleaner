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
    echo "  docker run [OPTIONS] baiyireng/media-nfo-cleaner:latest [视频目录] [选项]"
    echo
    echo "选项:"
    echo "  --dry-run           预览模式，不实际删除文件"
    echo "  --recycle [目录]    回收模式，将删除内容移动到指定目录"
    echo
    echo "示例:"
    echo "  # 预览模式"
    echo "  docker run -v /volume1/Video:/data/video baiyireng/media-nfo-cleaner:latest /data/video --dry-run"
    echo
    echo "  # 回收模式"
    echo "  docker run -v /volume1/Video:/data/video -v /volume1/homes/admin/recycle:/data/recycle baiyireng/media-nfo-cleaner:latest /data/video --recycle /data/recycle"
    exit 0
fi

# 默认参数
VIDEO_DIR=""
DRY_RUN=false
RECYCLE_MODE=false
RECYCLE_DIR=""

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --recycle)
            RECYCLE_MODE=true
            RECYCLE_DIR="$2"
            shift 2
            ;;
        *)
            if [ -z "$VIDEO_DIR" ]; then
                VIDEO_DIR="$1"
            fi
            shift
            ;;
    esac
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

# 设置回收目录
if [ "$RECYCLE_MODE" = true ]; then
    if [ -z "$RECYCLE_DIR" ]; then
        RECYCLE_DIR="/data/recycle"
    fi
    
    # 创建回收目录
    mkdir -p "$RECYCLE_DIR"
    
    # 构建命令
    CMD="python3 /app/video_library_cleaner.py '$VIDEO_DIR' --recycle '$RECYCLE_DIR'"
else
    # 构建命令
    if [ "$DRY_RUN" = true ]; then
        CMD="python3 /app/video_library_cleaner.py '$VIDEO_DIR' --dry-run"
    else
        CMD="python3 /app/video_library_cleaner.py '$VIDEO_DIR'"
    fi
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