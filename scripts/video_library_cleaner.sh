#!/bin/bash
# 视频库清理工具 - Linux/Shell版本

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

echo "视频库清理工具"
echo

# 显示帮助信息
if [ $# -eq 0 ]; then
    echo "使用方法:"
    echo "  $0 [视频目录路径] [选项]"
    echo
    echo "参数说明:"
    echo "  视频目录路径     - 要清理的视频库目录路径"
    echo "  --dry-run        - 预览模式，只显示将要删除的目录而不实际删除"
    echo "  --recycle [目录] - 回收模式，将删除内容移动到指定目录"
    echo
    echo "示例:"
    echo "  $0 \"/volume1/Video\"                     -- 直接清理"
    echo "  $0 \"/volume1/Video\" --dry-run           -- 预览模式"
    echo "  $0 \"/volume1/Video\" --recycle \"Recycle\" -- 回收模式"
    echo
    exit 1
fi

# 运行Python脚本
echo "正在运行视频库清理脚本..."
$PYTHON_CMD bin/video_library_cleaner.py "$@"
echo
echo "按任意键继续..."
read -n 1