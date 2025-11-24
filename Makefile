# 视频库清理工具 Makefile
SHELL := /bin/bash
export LANG := zh_CN.UTF-8
export LC_ALL := zh_CN.UTF-8

.PHONY: help install install-local install-docker test clean build docker-build docker-push release

# 默认目标
help:
	@echo "视频库清理工具 - 可用命令:"
	@echo "  install-local  - 本地安装工具"
	@echo "  install       - 运行远程安装脚本"
	@echo "  test          - 运行测试"
	@echo "  clean         - 清理临时文件"
	@echo "  docker-build  - 构建Docker镜像"
	@echo "  docker-push   - 推送Docker镜像到仓库"
	@echo "  package       - 创建发布包"
	@echo "  release       - 完整发布流程"

# 本地安装
install-local:
	@echo "本地安装..."
	@if [ ! -d "install" ]; then mkdir -p install; fi
	@install/install_for_nas.sh

# 远程安装
install:
	@echo "运行远程安装脚本..."
	@bash -c "$(curl -fsSL https://github.com/baiyireng/media-nfo-cleaner/blob/main/install.sh)"

# 测试
test:
	@echo "运行基本测试..."
	@echo "检查Python语法..."
	@python3 -m py_compile bin/video_library_cleaner.py
	@echo "检查Shell脚本语法..."
	@bash -n scripts/video_library_cleaner.sh
	@bash -n scripts/recycle_video_cleaner.sh
	@bash -n docker/docker-entrypoint.sh
	@echo "基本测试完成!"

# 清理
clean:
	@echo "清理临时文件..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@rm -rf dist/ build/
	@rm -f *.tar.gz
	@echo "清理完成!"

# 构建Docker镜像
docker-build:
	@echo "构建Docker镜像..."
	@docker build -t baiyiren/media-nfo-cleaner:latest -f docker/Dockerfile .
	@echo "Docker镜像构建完成!"

# 推送Docker镜像
docker-push:
	@echo "推送Docker镜像到仓库..."
	@docker push baiyiren/media-nfo-cleaner:latest
	@echo "Docker镜像推送完成!"
	@echo "发布完成!"

# 创建发布包
package:
	@echo "创建发布包..."
	@mkdir -p dist
	@tar -czf dist/media-video-cleaner.tar.gz \
		--exclude=dist \
		--exclude=.git \
		--exclude=.gitignore \
		--exclude=Makefile \
		--exclude=CHANGELOG.md \
		--exclude=CONTRIBUTING.md \
		--exclude=install.sh \
		.
	@echo "发布包创建完成: dist/media-video-cleaner.tar.gz"

# 完整发布流程
release: clean test docker-build package
	@echo "发布流程完成!"