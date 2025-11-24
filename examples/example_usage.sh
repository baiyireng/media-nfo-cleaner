#!/bin/bash
# DXP4800 NAS视频库清理工具 - 示例用法 (Linux/Shell版本)

# 设置脚本编码为UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "DXP4800 NAS视频库清理工具 - 示例用法"
echo

# 检查脚本是否存在
if [ ! -f "scripts/video_library_cleaner.sh" ]; then
    echo "错误: 找不到video_library_cleaner.sh脚本"
    exit 1
fi

echo ============================================
echo 1. 预览模式检查/volume1/Video目录
echo ============================================
echo
./scripts/video_library_cleaner.sh "/volume1/Video" --dry-run
echo
read -p "按任意键继续..."
echo

echo ============================================
echo 2. 预览模式检查网络共享目录
echo ============================================
echo
./scripts/video_library_cleaner.sh "/share/Movies" --dry-run
echo
read -p "按任意键继续..."
echo

echo ============================================
echo 3. 回收模式清理/volume1/Video目录（推荐）
echo ============================================
echo
echo "使用回收模式，将删除的内容移动到指定目录，可恢复"
echo
./scripts/recycle_video_cleaner.sh "/volume1/Video" "VideoRecycle"
echo
read -p "按任意键继续..."
echo

echo ============================================
echo 4. 实际清理模式（仅在确认预览结果正确后使用）
echo ============================================
echo
echo "警告：此操作将永久删除文件，无法恢复！"
echo
read -p "确认执行实际清理？(输入YES继续): " confirm
if [ "$confirm" = "YES" ] || [ "$confirm" = "yes" ]; then
    ./scripts/video_library_cleaner.sh "/volume1/Video"
else
    echo "操作已取消"
fi
echo
read -p "按任意键继续..."
echo

echo ============================================
echo 5. 组合使用示例：先预览，再回收模式清理
echo ============================================
echo
echo "第一步：预览检查"
./scripts/video_library_cleaner.sh "/volume1/Video" --dry-run
echo
echo "第二步：回收模式清理"
./scripts/recycle_video_cleaner.sh "/volume1/Video" "VideoRecycle"
echo
echo "所有示例执行完毕！"
echo