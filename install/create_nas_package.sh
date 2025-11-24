#!/bin/bash
# 创建NAS部署包脚本

echo "创建DXP4800 NAS视频库清理工具部署包"
echo "===================================="
echo

# 获取当前时间戳
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PACKAGE_NAME="dxp4800_video_cleaner_$TIMESTAMP.tar.gz"

echo "打包文件: $PACKAGE_NAME"
echo

# 创建临时目录
TEMP_DIR="temp_nas_package"
mkdir -p "$TEMP_DIR"

# 复制必要文件
echo "复制必要文件..."
cp bin/video_library_cleaner.py "$TEMP_DIR/"
cp scripts/video_library_cleaner.sh "$TEMP_DIR/"
cp scripts/recycle_video_cleaner.sh "$TEMP_DIR/"
cp examples/example_usage.sh "$TEMP_DIR/"
cp install/install_for_nas.sh "$TEMP_DIR/"
cp docs/README_video_cleaner.md "$TEMP_DIR/"
cp docs/README_NAS_Setup.md "$TEMP_DIR/"

# 创建部署说明
cat > "$TEMP_DIR/DEPLOY_README.txt" << EOF
DXP4800 NAS视频库清理工具部署说明
=================================

1. 将此压缩包上传到NAS系统
2. 解压缩: tar -xzf $PACKAGE_NAME
3. 进入解压目录: cd dxp4800_video_cleaner
4. 运行安装脚本: chmod +x install_for_nas.sh && ./install_for_nas.sh

快速开始:
1. SSH连接到NAS
2. 上传并解压此包
3. 运行安装脚本
4. 使用./quick_clean.sh进行清理

更多信息请查看README_NAS_Setup.md
EOF

# 创建压缩包
echo "创建压缩包..."
tar -czf "$PACKAGE_NAME" -C "$TEMP_DIR" .

# 清理临时目录
rm -rf "$TEMP_DIR"

echo
echo "======================================="
echo "部署包创建完成!"
echo "======================================="
echo "文件名: $PACKAGE_NAME"
echo "大小: $(ls -lh "$PACKAGE_NAME" | awk '{print $5}')"
echo
echo "现在可以将此压缩包上传到NAS系统进行部署"
echo "上传后，在NAS上执行以下命令:"
echo "  tar -xzf $PACKAGE_NAME"
echo "  cd dxp4800_video_cleaner"
echo "  chmod +x *.sh"
echo "  ./install_for_nas.sh"
echo
read -p "按任意键退出..."