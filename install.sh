#!/bin/bash
# DXP4800 NAS视频库清理工具 - 远程安装脚本

# 设置脚本编码
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目信息
REPO_OWNER="baiyireng"
REPO_NAME="media-nfo-cleaner"
GITHUB_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}"
RAW_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main"

# 显示欢迎信息
echo -e "${BLUE}"
echo "=============================================="
echo "   DXP4800 NAS视频库清理工具 - 远程安装"
echo "=============================================="
echo -e "${NC}"

# 检查操作系统
OS=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
else
    echo -e "${RED}错误: 不支持的操作系统 ${OSTYPE}${NC}"
    exit 1
fi

echo -e "检测到操作系统: ${GREEN}${OS}${NC}"

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查必要的命令
if ! command_exists curl; then
    echo -e "${RED}错误: 需要安装 curl 命令${NC}"
    exit 1
fi

# 检查Python
if command_exists python3; then
    PYTHON_CMD="python3"
elif command_exists python; then
    PYTHON_CMD="python"
else
    echo -e "${RED}错误: 需要安装 Python 3.x${NC}"
    exit 1
fi

echo -e "Python 命令: ${GREEN}${PYTHON_CMD}${NC}"

# 获取安装目录
DEFAULT_INSTALL_DIR="$HOME/dxp4800-video-cleaner"
read -p "安装目录 (默认: $DEFAULT_INSTALL_DIR): " INSTALL_DIR

if [ -z "$INSTALL_DIR" ]; then
    INSTALL_DIR="$DEFAULT_INSTALL_DIR"
fi

# 创建安装目录
echo -e "创建安装目录: ${BLUE}${INSTALL_DIR}${NC}"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# 获取最新版本
echo -e "获取最新版本信息..."
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": ?"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    LATEST_VERSION="main"
    echo -e "${YELLOW}无法获取最新版本，使用main分支${NC}"
else
    echo -e "最新版本: ${GREEN}${LATEST_VERSION}${NC}"
fi

# 下载文件
echo -e "下载工具文件..."

# 创建必要的目录
mkdir -p bin scripts install examples docs docker

# 核心文件
echo -e "下载核心脚本..."
curl -fsSL "${RAW_URL}/bin/video_library_cleaner.py" -o "bin/video_library_cleaner.py"

# 平台特定脚本
if [ "$OS" = "linux" ] || [ "$OS" = "macos" ]; then
    echo -e "下载Linux/macOS脚本..."
    curl -fsSL "${RAW_URL}/scripts/video_library_cleaner.sh" -o "scripts/video_library_cleaner.sh"
    curl -fsSL "${RAW_URL}/scripts/recycle_video_cleaner.sh" -o "scripts/recycle_video_cleaner.sh"
    
    # 设置执行权限
    chmod +x scripts/*.sh
elif [ "$OS" = "windows" ]; then
    echo -e "下载Windows脚本..."
    curl -fsSL "${RAW_URL}/scripts/run_video_cleaner.bat" -o "scripts/run_video_cleaner.bat"
    curl -fsSL "${RAW_URL}/scripts/recycle_video_cleaner.bat" -o "scripts/recycle_video_cleaner.bat"
fi

# 安装脚本
echo -e "下载安装脚本..."
curl -fsSL "${RAW_URL}/install/install_for_nas.sh" -o "install/install_for_nas.sh"
chmod +x install/install_for_nas.sh

# 文档
echo -e "下载文档..."
curl -fsSL "${RAW_URL}/docs/README_video_cleaner.md" -o "docs/README_video_cleaner.md"
curl -fsSL "${RAW_URL}/docs/README_NAS_Setup.md" -o "docs/README_NAS_Setup.md"
curl -fsSL "${RAW_URL}/docs/README_MultiPlatform.md" -o "docs/README_MultiPlatform.md"

# Docker文件
echo -e "下载Docker文件..."
curl -fsSL "${RAW_URL}/docker/Dockerfile" -o "docker/Dockerfile"
curl -fsSL "${RAW_URL}/docker/docker-entrypoint.sh" -o "docker/docker-entrypoint.sh"
curl -fsSL "${RAW_URL}/docker/docker-compose.yml" -o "docker/docker-compose.yml"
chmod +x docker/docker-entrypoint.sh

# 主README
curl -fsSL "${RAW_URL}/README.md" -o "README.md"

# 创建便捷启动脚本
echo -e "创建便捷启动脚本..."
LAUNCHER_SCRIPT="dxp4800-cleaner"
cat > "$LAUNCHER_SCRIPT" << EOF
#!/bin/bash
# DXP4800 NAS视频库清理工具 - 便捷启动脚本

# 脚本目录
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"

# 显示菜单
echo "==============================================="
echo "   DXP4800 NAS视频库清理工具"
echo "==============================================="
echo

echo "请选择操作:"
echo "1. 预览模式"
echo "2. 回收模式"
echo "3. 直接删除模式"
echo "4. 运行Docker容器"
echo "5. 退出"
echo

read -p "请输入选项 (1-5): " choice

case \$choice in
    1)
        echo "预览模式 - 检查但不删除文件"
        read -p "请输入视频目录路径: " video_dir
        \${SCRIPT_DIR}/scripts/video_library_cleaner.sh "\$video_dir" --dry-run
        ;;
    2)
        echo "回收模式 - 将文件移动到回收站"
        read -p "请输入视频目录路径: " video_dir
        read -p "请输入回收目录路径 (默认: ./RecycleBin): " recycle_dir
        if [ -z "\$recycle_dir" ]; then
            recycle_dir="./RecycleBin"
        fi
        \${SCRIPT_DIR}/scripts/recycle_video_cleaner.sh "\$video_dir" "\$recycle_dir"
        ;;
    3)
        echo "直接删除模式 - 永久删除文件"
        echo "警告: 此操作将永久删除文件，无法恢复!"
        read -p "请输入视频目录路径: " video_dir
        read -p "确认继续? (输入YES): " confirm
        if [ "\$confirm" = "YES" ]; then
            \${SCRIPT_DIR}/scripts/video_library_cleaner.sh "\$video_dir"
        else
            echo "操作已取消"
        fi
        ;;
    4)
        echo "Docker模式"
        echo "请确保已安装Docker并创建了数据卷"
        docker run -it --rm \\
            -v /volume1/Video:/data/video \\
            -v /volume1/homes/admin/recycle:/data/recycle \\
            northsea4/dxp4800-video-cleaner:latest \\
            /data/video --recycle /data/recycle
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

# 完成信息
echo
echo -e "${GREEN}==============================================="
echo -e "                安装完成!"
echo -e "===============================================${NC}"
echo
echo -e "安装目录: ${BLUE}${INSTALL_DIR}${NC}"
echo -e "版本: ${GREEN}${LATEST_VERSION}${NC}"
echo
echo -e "使用方法:"
echo -e "1. 便捷启动: ${YELLOW}./${LAUNCHER_SCRIPT}${NC}"
echo -e "2. 预览模式: ${YELLOW}./scripts/video_library_cleaner.sh [视频目录] --dry-run${NC}"
echo -e "3. 回收模式: ${YELLOW}./scripts/recycle_video_cleaner.sh [视频目录] [回收目录]${NC}"
echo -e "4. Docker模式: ${YELLOW}docker run -it northsea4/dxp4800-video-cleaner:latest${NC}"
echo
echo -e "更多信息请查看: ${BLUE}${INSTALL_DIR}/docs/README_NAS_Setup.md${NC}"
echo
echo -e "项目地址: ${BLUE}${GITHUB_URL}${NC}"
echo