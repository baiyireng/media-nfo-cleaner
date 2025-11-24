#!/bin/bash

# 一键Docker部署脚本 for Linux/macOS
# 使用方法: ./docker_deploy.sh "/path/to/video/library" ["/path/to/recycle/directory"]

# 检查参数
if [ -z "$1" ]; then
    echo ""
    echo "错误: 请指定视频库路径"
    echo "使用方法: $0 \"/path/to/video/library\" [\"/path/to/recycle/directory\"]"
    echo "示例: $0 \"/volume1/Video\" \"/volume1/Recycle\""
    exit 1
fi

# 设置变量
VIDEO_PATH="$1"
RECYCLE_PATH="$2"
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
if [ -n "$RECYCLE_PATH" ]; then
    echo "回收目录路径: $RECYCLE_PATH"
fi
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

# 添加回收目录挂载（如果指定了）
if [ -n "$RECYCLE_PATH" ]; then
    RUN_CMD="$RUN_CMD -v \"$RECYCLE_PATH:$DOCKER_RECYCLE_PATH\""
fi

# 添加默认命令参数
if [ -n "$RECYCLE_PATH" ]; then
    RUN_CMD="$RUN_CMD $IMAGE_NAME $DOCKER_VIDEO_PATH --recycle $DOCKER_RECYCLE_PATH"
else
    RUN_CMD="$RUN_CMD $IMAGE_NAME $DOCKER_VIDEO_PATH --dry-run"
fi

# 执行容器运行
echo ""
echo "正在启动容器..."
echo ""
echo "运行命令: $RUN_CMD"
echo ""
eval "$RUN_CMD"

# 检查执行结果
if [ $? -eq 0 ]; then
    echo ""
    echo "容器执行完成！"
else
    echo ""
    echo "容器执行失败！"
    exit 1
fi