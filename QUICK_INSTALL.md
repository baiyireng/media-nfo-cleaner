# 快速安装指南

## 远程一键安装

**Linux/macOS用户**:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.sh)"
```

**Windows用户**:
1. 打开命令提示符（CMD）
2. 复制并运行以下命令：

```cmd
# 下载安装脚本
curl -L -o install.bat https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat

# 运行安装脚本
start install.bat
```

或者使用PowerShell（推荐）：

```powershell
# 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 下载并运行安装脚本（推荐使用WebClient确保UTF-8编码）
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wc = New-Object System.Net.WebClient
$wc.Encoding = [System.Text.Encoding]::UTF8
$wc.DownloadFile('https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.ps1', 'install.ps1')
.\install.ps1
```

或者直接下载并运行 `install.bat` 或 `install.ps1` 文件:
- https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat
- https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.ps1

## 快速启动

安装完成后，可以使用以下方式快速启动工具：

### Windows系统

```cmd
# 便捷启动脚本（安装后可用）
quick-start.bat

# 预览模式
scripts\run_video_cleaner.bat "D:\Video" --dry-run

# 回收模式
scripts\run_video_cleaner.bat "D:\Video" --recycle "Recycle"
```

### Linux/NAS系统

```bash
# 便捷启动脚本（安装后可用）
./quick-cleaner

# 预览模式
./scripts/video_library_cleaner.sh "/volume1/Video" --dry-run

# 回收模式
./scripts/recycle_video_cleaner.sh "/volume1/Video" "RecycleBin"
```

### Docker方式

```bash
# 拉取镜像
docker pull baiyiren/media-nfo-cleaner:latest

# 预览模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run

# 回收模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  -v /volume1/homes/admin/recycle:/data/recycle \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --recycle /data/recycle
```

## 一键Docker部署

### Windows系统

```cmd
# 便捷启动脚本
scripts\\docker_deploy.bat "D:\\Video"

# 回收模式
scripts\\docker_deploy.bat "D:\\Video" "D:\\Recycle"
```

### Linux/macOS系统

```bash
# 添加执行权限
chmod +x scripts/docker_deploy.sh

# 便捷启动脚本
./scripts/docker_deploy.sh "/volume1/Video"

# 回收模式
./scripts/docker_deploy.sh "/volume1/Video" "/volume1/Recycle"
```

### 手动Docker命令

```bash
# 拉取镜像
docker pull baiyiren/media-nfo-cleaner:latest

# 预览模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --dry-run

# 回收模式
docker run -it --rm \
  -v /volume1/Video:/data/video \
  -v /volume1/homes/admin/recycle:/data/recycle \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --recycle /data/recycle
```

## 常见问题

### Windows平台

1. **权限问题**：右键点击CMD或PowerShell，选择"以管理员身份运行"
2. **执行策略限制**：在PowerShell中运行 `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. **防病毒软件拦截**：将脚本或安装目录添加到白名单
4. **路径空格**：包含空格的路径使用双引号包围，如 `"D:\My Videos"`

### Linux/NAS平台

1. **权限不足**：运行 `chmod +x scripts/*.sh` 添加执行权限
2. **Python缺失**：安装Python3，如 `apt install python3` 或 `yum install python3`
3. **磁盘空间不足**：确保回收目录所在分区有足够空间
4. **大目录处理慢**：使用 `nice` 命令降低优先级，如 `nice -n 19 ./scripts/recycle_video_cleaner.sh`

### macOS平台

1. **Python缺失**：使用Homebrew安装 `brew install python3`
2. **路径问题**：用户目录可能需要完整路径，如 `/Users/username/Movies`
3. **权限问题**：可能需要 `chmod +x scripts/*.sh` 添加执行权限

### Docker平台

1. **路径挂载失败**：确保本地路径存在且有权限访问
2. **Windows路径问题**：Docker内部使用正斜杠，如 `/d/video`
3. **权限问题**：添加 `--user $(id -u):$(id -g)` 参数使用当前用户权限

## 获取帮助

如果遇到问题：

1. 查看详细文档：[文档目录](https://github.com/baiyireng/media-nfo-cleaner/tree/main/docs)
2. 搜索已有问题：[Issues](https://github.com/baiyireng/media-nfo-cleaner/issues)
3. 提交新问题：[New Issue](https://github.com/baiyireng/media-nfo-cleaner/issues/new)
4. 查看使用示例：[Examples](https://github.com/baiyireng/media-nfo-cleaner/tree/main/examples)