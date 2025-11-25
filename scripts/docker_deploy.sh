#!/bin/bash

# 一键Docker部署脚本 for Linux/macOS
# 使用方法: ./docker_deploy.sh "/path/to/video/library" [选项]

# 检查参数
if [ -z "$1" ]; then
    echo ""
    echo "错误: 请指定视频库路径"
    echo "使用方法: $0 \"/path/to/video/library\" [选项]"
    echo "示例: $0 \"/volume1/Video\" --recycle \"/volume1/Recycle\""
    echo "      $0 \"/volume1/Video\" --dry-run --ignore-dir \"temp\" --max-size 1024"
    exit 1
fi

# 设置变量
VIDEO_PATH="$1"
IMAGE_NAME="baiyiren/media-nfo-cleaner:latest"
CONTAINER_NAME="media-nfo-cleaner"

# Docker容器内路径
DOCKER_VIDEO_PATH="/data/video"
DOCKER_RECYCLE_PATH="/data/recycle"

# 显示配置信息
echo ""
echo "======================================"
echo "  一键Docker部署 - 视频库清理工具"
echo "======================================"
echo ""
echo "视频库路径: $VIDEO_PATH"
echo "镜像名称: $IMAGE_NAME"
echo "容器名称: $CONTAINER_NAME"
echo ""

# 拉取最新镜像
echo "正在拉取最新镜像..."
docker pull "$IMAGE_NAME"
if [ $? -ne 0 ]; then
    echo "镜像拉取失败，请检查网络连接和Docker配置"
    exit 1
fi

# 构建运行命令
RUN_CMD="docker run -it --rm --name $CONTAINER_NAME -v \"$VIDEO_PATH:$DOCKER_VIDEO_PATH\""

# 解析其他参数
ARGS=""
shift  # 跳过第一个参数（视频路径）

RECYCLE_PATH=""
FOUND_RECYCLE=false

# 解析命令行参数
while [ $# -gt 0 ]; do
    case "$1" in
        --recycle)
            FOUND_RECYCLE=true
            ARGS="$ARGS --recycle $DOCKER_RECYCLE_PATH"
            shift
            if [ -z "$1" ]; then
                echo "错误: --recycle 需要指定回收目录路径"
                exit 1
            fi
            RECYCLE_PATH="$1"
            # 添加回收目录挂载
            RUN_CMD="$RUN_CMD -v \"$RECYCLE_PATH:$DOCKER_RECYCLE_PATH\""
            shift
            ;;
        *)
            # 其他参数直接传递
            ARGS="$ARGS $1"
            shift
            ;;
    esac
done

# 如果没有指定任何选项，默认使用预览模式
if [ -z "$ARGS" ]; then
    ARGS="--dry-run"
fi

# 构建完整命令
FULL_CMD="$RUN_CMD $IMAGE_NAME $DOCKER_VIDEO_PATH$ARGS"

# 执行容器运行
echo ""
echo "正在启动容器..."
echo ""
echo "运行命令: $FULL_CMD"
echo ""
eval "$FULL_CMD"

# 检查执行结果
if [ $? -eq 0 ]; then
    echo ""
    echo "容器执行完成！"
else
    echo ""
    echo "容器执行失败！"
    exit 1
fi