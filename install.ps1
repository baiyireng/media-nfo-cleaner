# DXP4800 NAS视频库清理工具 - PowerShell远程安装脚本

# 设置变量
$REPO_OWNER = "baiyireng"
$REPO_NAME = "media-nfo-cleaner"
$GITHUB_URL = "https://github.com/$REPO_OWNER/$REPO_NAME"
$RAW_URL = "https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main"

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  DXP4800 NAS视频库清理工具 - PowerShell安装" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# 获取安装目录
$DEFAULT_INSTALL_DIR = "$env:USERPROFILE\media-nfo-cleaner"
$INSTALL_DIR = Read-Host "安装目录 (默认: $DEFAULT_INSTALL_DIR)"
if ([string]::IsNullOrEmpty($INSTALL_DIR)) {
    $INSTALL_DIR = $DEFAULT_INSTALL_DIR
}

Write-Host "安装目录: $INSTALL_DIR" -ForegroundColor Green
Write-Host ""

# 创建安装目录
Write-Host "创建安装目录..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null
New-Item -ItemType Directory -Force -Path "$INSTALL_DIR\bin" | Out-Null
New-Item -ItemType Directory -Force -Path "$INSTALL_DIR\scripts" | Out-Null
New-Item -ItemType Directory -Force -Path "$INSTALL_DIR\examples" | Out-Null
New-Item -ItemType Directory -Force -Path "$INSTALL_DIR\docs" | Out-Null
New-Item -ItemType Directory -Force -Path "$INSTALL_DIR\install" | Out-Null
New-Item -ItemType Directory -Force -Path "$INSTALL_DIR\docker" | Out-Null

# 创建临时目录
$TEMP_DIR = "$env:TEMP\media-nfo-cleaner"
if (Test-Path $TEMP_DIR) {
    Remove-Item -Recurse -Force $TEMP_DIR
}
New-Item -ItemType Directory -Force -Path $TEMP_DIR | Out-Null
Set-Location $TEMP_DIR

Write-Host "下载必要文件..." -ForegroundColor Yellow
Write-Host ""

# 下载文件
$files = @{
    "bin/video_library_cleaner.py" = "video_library_cleaner.py"
    "scripts/run_video_cleaner.bat" = "run_video_cleaner.bat"
    "scripts/recycle_video_cleaner.bat" = "recycle_video_cleaner.bat"
    "scripts/video_library_cleaner.sh" = "video_library_cleaner.sh"
    "scripts/recycle_video_cleaner.sh" = "recycle_video_cleaner.sh"
    "examples/example_usage.bat" = "example_usage.bat"
    "examples/example_usage.sh" = "example_usage.sh"
    "docs/README_video_cleaner.md" = "README_video_cleaner.md"
    "docs/README_NAS_Setup.md" = "README_NAS_Setup.md"
    "docs/README_MultiPlatform.md" = "README_MultiPlatform.md"
    "install/install_for_nas.sh" = "install_for_nas.sh"
    "install/create_nas_package.sh" = "create_nas_package.sh"
    "docker/Dockerfile" = "Dockerfile"
    "docker/docker-compose.yml" = "docker-compose.yml"
    "README.md" = "README.md"
}

$count = 1
$total = $files.Count

foreach ($file in $files.GetEnumerator()) {
    $remotePath = $file.Key
    $localPath = $file.Value
    
    Write-Host "[$count/$total] 下载 $remotePath" -ForegroundColor Cyan
    Invoke-WebRequest -Uri "$RAW_URL/$remotePath" -OutFile $localPath
    $count++
}

Write-Host ""
Write-Host "复制文件到安装目录..." -ForegroundColor Yellow
Write-Host ""

# 复制文件到目标目录
Copy-Item "video_library_cleaner.py" "$INSTALL_DIR\bin\" -Force
Copy-Item "run_video_cleaner.bat" "$INSTALL_DIR\scripts\" -Force
Copy-Item "recycle_video_cleaner.bat" "$INSTALL_DIR\scripts\" -Force
Copy-Item "video_library_cleaner.sh" "$INSTALL_DIR\scripts\" -Force
Copy-Item "recycle_video_cleaner.sh" "$INSTALL_DIR\scripts\" -Force
Copy-Item "example_usage.bat" "$INSTALL_DIR\examples\" -Force
Copy-Item "example_usage.sh" "$INSTALL_DIR\examples\" -Force
Copy-Item "README_video_cleaner.md" "$INSTALL_DIR\docs\" -Force
Copy-Item "README_NAS_Setup.md" "$INSTALL_DIR\docs\" -Force
Copy-Item "README_MultiPlatform.md" "$INSTALL_DIR\docs\" -Force
Copy-Item "install_for_nas.sh" "$INSTALL_DIR\install\" -Force
Copy-Item "create_nas_package.sh" "$INSTALL_DIR\install\" -Force
Copy-Item "Dockerfile" "$INSTALL_DIR\docker\" -Force
Copy-Item "docker-compose.yml" "$INSTALL_DIR\docker\" -Force
Copy-Item "README.md" "$INSTALL_DIR\" -Force

# 创建便捷启动脚本
Write-Host "创建便捷启动脚本..." -ForegroundColor Yellow

$quickStartScript = @"
@echo off
chcp 65001 >nul
echo DXP4800 NAS视频库清理工具
echo ================================
echo.
echo 请选择操作:
echo 1. 预览模式
echo 2. 回收模式
echo 3. 直接删除模式
echo 4. 退出
echo.
set /p choice=请输入选项 (1-4): 

if "%choice%"=="1" goto preview
if "%choice%"=="2" goto recycle
if "%choice%"=="3" goto delete
if "%choice%"=="4" exit

:preview
set /p video_dir=请输入视频目录路径: 
scripts\run_video_cleaner.bat "%video_dir%" --dry-run
goto start

:recycle
set /p video_dir=请输入视频目录路径: 
set /p recycle_dir=请输入回收目录路径 (默认: .\RecycleBin): 
if "%recycle_dir%"=="" set recycle_dir=.\RecycleBin
scripts\run_video_cleaner.bat "%video_dir%" --recycle "%recycle_dir%"
goto start

:delete
set /p video_dir=请输入视频目录路径: 
echo 警告: 此操作将永久删除文件，无法恢复!
set /p confirm=确认继续? (输入YES): 
if "%confirm%"=="YES" scripts\run_video_cleaner.bat "%video_dir%"

:start
echo.
pause
"@

Out-File -FilePath "$INSTALL_DIR\quick-start.bat" -InputObject $quickStartScript -Encoding ASCII

# 清理临时文件
Write-Host "清理临时文件..." -ForegroundColor Yellow
Set-Location $env:TEMP
Remove-Item -Recurse -Force $TEMP_DIR -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "              安装完成!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""
Write-Host "安装目录: $INSTALL_DIR" -ForegroundColor Cyan
Write-Host "项目地址: $GITHUB_URL" -ForegroundColor Cyan
Write-Host ""
Write-Host "使用方法:" -ForegroundColor Yellow
Write-Host "1. 便捷启动: 双击 $INSTALL_DIR\quick-start.bat" -ForegroundColor White
Write-Host "2. 预览模式: $INSTALL_DIR\scripts\run_video_cleaner.bat `"D:\\Video`" --dry-run" -ForegroundColor White
Write-Host "3. 回收模式: $INSTALL_DIR\scripts\run_video_cleaner.bat `"D:\\Video`" --recycle `"Recycle`"" -ForegroundColor White
Write-Host ""
Write-Host "更多信息请查看: $INSTALL_DIR\docs\README_NAS_Setup.md" -ForegroundColor White
Write-Host ""
Write-Host "按任意键打开安装目录..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# 打开安装目录
Invoke-Item $INSTALL_DIR

Write-Host "安装完成！" -ForegroundColor Green