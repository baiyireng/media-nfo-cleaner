# Windows 安装指南

## 方法一：使用PowerShell（推荐）

1. 右键点击开始菜单，选择"Windows PowerShell"
2. 复制并运行以下命令：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.ps1' -OutFile 'install.ps1'; .\install.ps1
```

3. 按照提示完成安装

## 方法二：使用命令提示符（CMD）

1. 打开命令提示符（CMD）
2. 复制并运行以下命令：

```cmd
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat' -OutFile 'install.bat'; .\install.bat"
```

3. 按照提示完成安装

## 方法三：手动下载安装

1. 下载安装文件：
   - https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.bat
   - 或者 https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.ps1

2. 双击运行下载的文件
3. 按照提示完成安装

## 安装后使用

安装完成后，您可以：

1. 双击桌面或安装目录中的 `quick-start.bat` 图标
2. 选择预览模式、回收模式或直接删除模式
3. 输入视频目录路径并运行

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