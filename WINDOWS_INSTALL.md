# Windows 安装指南 - 视频库清理工具

## 方法一：使用PowerShell（推荐）

1. 右键点击开始菜单，选择"Windows PowerShell"
2. 复制并运行以下命令：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 下载并运行安装脚本（推荐使用WebClient确保UTF-8编码）
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wc = New-Object System.Net.WebClient
$wc.Encoding = [System.Text.Encoding]::UTF8
$wc.DownloadFile('https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.ps1', 'install.ps1')
.\install.ps1
```

3. 按照提示完成安装

## 方法二：使用命令提示符（CMD）

1. 打开命令提示符（CMD）
2. 复制并运行以下命令：

```cmd
# 下载安装脚本
curl -L -o install.bat https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat

# 运行安装脚本
start install.bat
```

或者使用PowerShell命令：

```cmd
# 使用PowerShell下载和运行
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $wc = New-Object System.Net.WebClient; $wc.Encoding = [System.Text.Encoding]::UTF8; $wc.DownloadFile('https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat', 'install.bat'); Start-Process cmd.exe '/k .\install.bat'"
```

3. 按照提示完成安装

## 方法三：手动下载安装

1. 下载安装文件：
   - https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat
   - 或者 https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.ps1

2. 双击运行下载的文件
3. 按照提示完成安装

## 安装后使用

### 基本使用

安装完成后，您可以：

1. 双击桌面或安装目录中的 `quick-start.bat` 图标
2. 选择预览模式、回收模式或直接删除模式
3. 输入视频目录路径并运行

### 命令行使用

如果您更喜欢使用命令行：

```cmd
# 预览模式（推荐首先使用）
scripts\run_video_cleaner.bat "D:\Video" --dry-run

# 回收模式（安全删除）
scripts\run_video_cleaner.bat "D:\Video" --recycle "D:\Video\Recycle"

# 直接删除模式（永久删除）
scripts\run_video_cleaner.bat "D:\Video"
```

### 注意事项（Windows）

1. **路径格式**：
   - 使用反斜杠 `\` 或双引号包围路径
   - 包含空格的路径必须使用双引号，如 `"D:\My Videos"`

2. **权限问题**：
   - 右键点击CMD或PowerShell，选择"以管理员身份运行"
   - 处理系统目录（如C盘）时需要管理员权限

3. **防病毒软件**：
   - 某些防病毒软件可能会阻止脚本运行
   - 需要将脚本或安装目录添加到白名单

4. **Python依赖**：
   - 如果系统未安装Python，安装脚本会自动下载Miniconda
   - 确保有足够的磁盘空间用于安装

5. **大型目录**：
   - 处理大型视频库可能需要较长时间
   - 建议先在较小目录上测试

### 性能优化

1. **减少扫描范围**：
   - 可以修改Python脚本中的`MAX_DEPTH`参数限制递归深度
   - 使用`--max-depth`命令行参数

2. **排除特定目录**：
   - 可以在脚本中添加排除规则
   - 或将要排除的目录移动到视频目录之外

3. **调整回收位置**：
   - 使用不同磁盘分区作为回收目录可以提高性能
   - SSD上的操作通常比HDD更快

## 常见问题

### PowerShell执行策略错误

如果遇到"因为在此系统上禁止运行脚本"的错误，请先运行：
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 网络连接问题

如果下载失败，请检查网络连接或使用手动下载方法。

### 防病毒软件阻止

某些防病毒软件可能会阻止运行下载的脚本。您可能需要临时禁用实时保护或将脚本添加到白名单。

## 更多信息

- 完整文档：https://github.com/baiyireng/media-nfo-cleaner
- 问题报告：https://github.com/baiyireng/media-nfo-cleaner/issues