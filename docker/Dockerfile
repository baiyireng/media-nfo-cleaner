# 视频库清理工具 Docker镜像
FROM docker-mirror.aigc2d.com/library/nginx:latest

# 设置维护者
LABEL maintainer="baiyireng"
LABEL description="视频库清理工具"
LABEL version="1.0.0"

# 切换到root用户安装软件
USER root

# 安装Python和其他必要软件
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制Python脚本
COPY bin/video_library_cleaner.py /app/

# 创建必要的目录
RUN mkdir -p /app/scripts /app/data

# 复制启动脚本
COPY docker/docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 创建非root用户
RUN useradd -m -s /bin/bash appuser && \
    chown -R appuser:appuser /app

# 切换到非root用户
USER appuser

# 设置入口点
ENTRYPOINT ["/app/docker-entrypoint.sh"]