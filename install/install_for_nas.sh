#!/bin/bash
# DXP4800 NAS视频库清理工具 - 安装脚本

# 设置脚本编码为UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "DXP4800 NAS视频库清理工具 - 安装向导"
echo "======================================="
echo

# 检查是否为root用户
if [ "$(id -u)" -eq 0 ]; then
    echo "警告: 不建议以root用户身份运行此脚本"
    echo "建议使用普通管理员账户运行"
    echo
    read -p "是否继续? (y/N): " continue_as_root
    if [[ ! "$continue_as_root" =~ ^[Yy]$ ]]; then
        echo "安装已取消"
        exit 1
    fi
fi

# 检查Python是否安装
if ! command -v python3 &> /dev/null; then
    if ! command -v python &> /dev/null; then
        echo "错误: 未找到Python解释器"
        echo "请先安装Python 3.x"
        echo
        echo "对于DSM系统，可以通过包管理器安装:"
        echo "sudo opkg install python3"
        exit 1
    else
        PYTHON_CMD="python"
    fi
else
    PYTHON_CMD="python3"
fi

echo "Python解释器: $PYTHON_CMD"
$PYTHON_CMD --version
echo

# 获取当前目录
CURRENT_DIR=$(pwd)
echo "当前工作目录: $CURRENT_DIR"
echo

# 创建安装目录选项
DEFAULT_INSTALL_DIR="/volume1/homes/$(whoami)/video_cleaner"
read -p "安装目录 (默认: $DEFAULT_INSTALL_DIR): " INSTALL_DIR
if [ -z "$INSTALL_DIR" ]; then
    INSTALL_DIR="$DEFAULT_INSTALL_DIR"
fi

echo "安装目录: $INSTALL_DIR"
echo

# 创建安装目录
echo "创建安装目录..."
mkdir -p "$INSTALL_DIR/bin" "$INSTALL_DIR/scripts" "$INSTALL_DIR/examples" "$INSTALL_DIR/docs"
if [ $? -ne 0 ]; then
    echo "错误: 无法创建目录 $INSTALL_DIR"
    echo "请检查权限和路径是否正确"
    exit 1
fi

# 检查是否存在必要的文件
echo "检查必要文件..."
REQUIRED_FILES=("bin/video_library_cleaner.py" "scripts/video_library_cleaner.sh" "scripts/recycle_video_cleaner.sh" "docs/README_NAS_Setup.md")
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$CURRENT_DIR/$file" ]; then
        echo "错误: 找不到必要文件 $file"
        echo "请确保所有必要文件都在当前目录中"
        exit 1
    fi
done

# 复制文件
echo "复制文件到安装目录..."
cp -v "$CURRENT_DIR/bin/video_library_cleaner.py" "$INSTALL_DIR/bin/"
cp -v "$CURRENT_DIR/scripts/video_library_cleaner.sh" "$INSTALL_DIR/scripts/"
cp -v "$CURRENT_DIR/scripts/recycle_video_cleaner.sh" "$INSTALL_DIR/scripts/"
cp -v "$CURRENT_DIR/examples/example_usage.sh" "$INSTALL_DIR/examples/"
cp -v "$CURRENT_DIR/docs/README_video_cleaner.md" "$INSTALL_DIR/docs/"
cp -v "$CURRENT_DIR/docs/README_NAS_Setup.md" "$INSTALL_DIR/docs/"

# 设置执行权限
echo "设置脚本执行权限..."
chmod +x "$INSTALL_DIR"/scripts/*.sh "$INSTALL_DIR"/examples/*.sh

# 检查视频目录
echo
read -p "请输入您的视频目录路径 (例如: /volume1/Video): " VIDEO_DIR
if [ -z "$VIDEO_DIR" ]; then
    VIDEO_DIR="/volume1/Video"
    echo "使用默认视频目录: $VIDEO_DIR"
fi

if [ ! -d "$VIDEO_DIR" ]; then
    echo "警告: 视频目录 $VIDEO_DIR 不存在"
    echo "请确认路径是否正确"
    read -p "是否继续? (y/N): " continue_without_video
    if [[ ! "$continue_without_video" =~ ^[Yy]$ ]]; then
        echo "安装已取消"
        exit 1
    fi
fi

# 创建便捷脚本
echo "创建便捷脚本..."
LAUNCHER_SCRIPT="$INSTALL_DIR/quick_clean.sh"
cat > "$LAUNCHER_SCRIPT" << EOF
#!/bin/bash
# DXP4800 NAS视频库清理工具 - 便捷启动脚本

echo "DXP4800 NAS视频库清理工具 - 便捷启动"
echo "===================================="
echo

# 默认视频目录
DEFAULT_VIDEO_DIR="$VIDEO_DIR"
DEFAULT_RECYCLE_DIR="RecycleBin"

# 显示菜单
echo "请选择操作:"
echo "1. 预览模式检查 (\$DEFAULT_VIDEO_DIR)"
echo "2. 回收模式清理 (\$DEFAULT_VIDEO_DIR -> RecycleBin)"
echo "3. 直接删除模式 (\$DEFAULT_VIDEO_DIR) - 警告!"
echo "4. 自定义参数"
echo "5. 退出"
echo

read -p "请输入选项 (1-5): " choice

case \$choice in
    1)
        echo "执行预览模式..."
        ./scripts/video_library_cleaner.sh "\$DEFAULT_VIDEO_DIR" --dry-run
        ;;
    2)
        echo "执行回收模式..."
        ./scripts/recycle_video_cleaner.sh "\$DEFAULT_VIDEO_DIR" "\$DEFAULT_RECYCLE_DIR"
        ;;
    3)
        echo "警告: 此操作将永久删除文件!"
        read -p "确认继续? (输入YES): " confirm
        if [ "\$confirm" = "YES" ]; then
            ./scripts/video_library_cleaner.sh "\$DEFAULT_VIDEO_DIR"
        else
            echo "操作已取消"
        fi
        ;;
    4)
        echo "自定义参数模式"
        echo "可用参数: --dry-run, --recycle [目录]"
        read -p "请输入完整命令: ./scripts/video_library_cleaner.sh " custom_args
        ./scripts/video_library_cleaner.sh \$custom_args
        ;;
    5)
        echo "退出"
        exit 0
        ;;
    *)
        echo "无效选项"
        exit 1
        ;;
esac
EOF

chmod +x "$LAUNCHER_SCRIPT"

# 创建日志目录
mkdir -p "$INSTALL_DIR/logs"

# 完成信息
echo
echo "======================================="
echo "安装完成!"
echo "======================================="
echo
echo "安装位置: $INSTALL_DIR"
echo "视频目录: $VIDEO_DIR"
echo
echo "使用方法:"
echo "1. 便捷启动: cd $INSTALL_DIR && ./quick_clean.sh"
echo "2. 预览模式: cd $INSTALL_DIR && ./scripts/video_library_cleaner.sh '$VIDEO_DIR' --dry-run"
echo "3. 回收模式: cd $INSTALL_DIR && ./scripts/recycle_video_cleaner.sh '$VIDEO_DIR' 'RecycleBin'"
echo
echo "更多信息请查看: $INSTALL_DIR/docs/README_NAS_Setup.md"
echo
read -p "按任意键退出..."