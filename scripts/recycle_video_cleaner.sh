#!/bin/bash
# DXP4800 NAS视频库清理工具 - 回收模式专用脚本 (Linux/Shell版本)

# 设置脚本编码为UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 检查Python是否安装
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        echo "错误: 未找到Python解释器，请先安装Python"
        exit 1
    else
        PYTHON_CMD="python"
    fi
else
    PYTHON_CMD="python3"
fi

VIDEO_DIR="$1"
RECYCLE_DIR="$2"

echo "DXP4800 NAS视频库清理工具 - 回收模式"
echo

# 显示帮助信息
if [ -z "$VIDEO_DIR" ]; then
    echo "使用方法:"
    echo "  $0 [视频目录路径] [回收站目录名]"
    echo
    echo "参数说明:"
    echo "  视频目录路径     - 要清理的视频库目录路径"
    echo "  回收站目录名     - 用于存放删除内容的目录名"
    echo
    echo "示例:"
    echo "  $0 \"/volume1/Video\" \"Recycle\"         -- 将清理内容移动到/volume1/Video/Recycle"
    echo "  $0 \"/volume1/Video\" \"/tmp/VideoRecycle\" -- 指定绝对路径"
    echo
    exit 1
fi

# 如果未指定回收目录，使用默认值
if [ -z "$RECYCLE_DIR" ]; then
    RECYCLE_DIR="RecycleBin"
fi

echo "视频目录: $VIDEO_DIR"
echo "回收目录: $RECYCLE_DIR"
echo
echo "正在运行回收模式清理脚本..."
echo "注意: 文件将被移动到回收站目录，而非永久删除"
echo

# 运行Python脚本
$PYTHON_CMD bin/video_library_cleaner.py "$VIDEO_DIR" --recycle "$RECYCLE_DIR"
echo
echo "按任意键继续..."
read -n 1