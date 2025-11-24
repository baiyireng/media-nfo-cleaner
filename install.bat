@echo off
chcp 65001 >nul
rem DXP4800 NAS视频库清理工具 - Windows远程安装脚本

echo ===============================================
echo   DXP4800 NAS视频库清理工具 - Windows安装
echo ===============================================
echo.

rem 检查管理员权限
net session >nul 2>&1
if %errorLevel% == 0 (
    echo 检测到管理员权限，继续安装...
) else (
    echo 警告: 建议以管理员身份运行此脚本
    echo.
)

rem 设置变量
set "REPO_OWNER=baiyireng"
set "REPO_NAME=media-nfo-cleaner"
set "GITHUB_URL=https://github.com/%REPO_OWNER%/%REPO_NAME%"
set "RAW_URL=https://raw.githubusercontent.com/%REPO_OWNER%/%REPO_NAME%/main"

rem 获取安装目录
set "DEFAULT_INSTALL_DIR=%USERPROFILE%\media-nfo-cleaner"
set /p "INSTALL_DIR=安装目录 (默认: %DEFAULT_INSTALL_DIR%): "
if "%INSTALL_DIR%"=="" (
    set "INSTALL_DIR=%DEFAULT_INSTALL_DIR%"
)

echo 安装目录: %INSTALL_DIR%
echo.

rem 创建安装目录
echo 创建安装目录...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\bin" mkdir "%INSTALL_DIR%\bin"
if not exist "%INSTALL_DIR%\scripts" mkdir "%INSTALL_DIR%\scripts"
if not exist "%INSTALL_DIR%\examples" mkdir "%INSTALL_DIR%\examples"
if not exist "%INSTALL_DIR%\docs" mkdir "%INSTALL_DIR%\docs"
if not exist "%INSTALL_DIR%\install" mkdir "%INSTALL_DIR%\install"
if not exist "%INSTALL_DIR%\docker" mkdir "%INSTALL_DIR%\docker"

rem 切换到临时目录
set "TEMP_DIR=%TEMP%\media-nfo-cleaner"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
cd /d "%TEMP_DIR%"

echo 下载必要文件...
echo.

rem 下载核心脚本
echo [1/8] 下载核心Python脚本...
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/bin/video_library_cleaner.py' -OutFile 'video_library_cleaner.py'"
if %errorLevel% neq 0 (
    echo 错误: 下载失败，请检查网络连接
    pause
    exit /b 1
)

rem 下载Windows脚本
echo [2/8] 下载Windows批处理脚本...
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/scripts/run_video_cleaner.bat' -OutFile 'run_video_cleaner.bat'"
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/scripts/recycle_video_cleaner.bat' -OutFile 'recycle_video_cleaner.bat'"

rem 下载Linux脚本（可选）
echo [3/8] 下载Linux脚本（可选）...
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/scripts/video_library_cleaner.sh' -OutFile 'video_library_cleaner.sh'"
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/scripts/recycle_video_cleaner.sh' -OutFile 'recycle_video_cleaner.sh'"

rem 下载文档
echo [4/8] 下载文档...
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/docs/README_video_cleaner.md' -OutFile 'README_video_cleaner.md'"
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/docs/README_NAS_Setup.md' -OutFile 'README_NAS_Setup.md'"
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/docs/README_MultiPlatform.md' -OutFile 'README_MultiPlatform.md'"

rem 下载示例脚本
echo [5/8] 下载示例脚本...
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/examples/example_usage.bat' -OutFile 'example_usage.bat'"
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/examples/example_usage.sh' -OutFile 'example_usage.sh'"

rem 下载Docker文件
echo [6/8] 下载Docker文件...
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/docker/Dockerfile' -OutFile 'Dockerfile'"
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/docker/docker-compose.yml' -OutFile 'docker-compose.yml'"

rem 下载安装脚本
echo [7/8] 下载安装脚本...
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/install/install_for_nas.sh' -OutFile 'install_for_nas.sh'"
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/install/create_nas_package.sh' -OutFile 'create_nas_package.sh'"

rem 下载主README
echo [8/8] 下载主README...
powershell -Command "Invoke-WebRequest -Uri '%RAW_URL%/README.md' -OutFile 'README.md'"

echo.
echo 复制文件到安装目录...
echo.

rem 复制文件到目标目录
copy "video_library_cleaner.py" "%INSTALL_DIR%\bin\" >nul
copy "run_video_cleaner.bat" "%INSTALL_DIR%\scripts\" >nul
copy "recycle_video_cleaner.bat" "%INSTALL_DIR%\scripts\" >nul
copy "video_library_cleaner.sh" "%INSTALL_DIR%\scripts\" >nul
copy "recycle_video_cleaner.sh" "%INSTALL_DIR%\scripts\" >nul
copy "example_usage.bat" "%INSTALL_DIR%\examples\" >nul
copy "example_usage.sh" "%INSTALL_DIR%\examples\" >nul
copy "README_video_cleaner.md" "%INSTALL_DIR%\docs\" >nul
copy "README_NAS_Setup.md" "%INSTALL_DIR%\docs\" >nul
copy "README_MultiPlatform.md" "%INSTALL_DIR%\docs\" >nul
copy "install_for_nas.sh" "%INSTALL_DIR%\install\" >nul
copy "create_nas_package.sh" "%INSTALL_DIR%\install\" >nul
copy "Dockerfile" "%INSTALL_DIR%\docker\" >nul
copy "docker-compose.yml" "%INSTALL_DIR%\docker\" >nul
copy "README.md" "%INSTALL_DIR%\" >nul

rem 创建便捷启动脚本
echo 创建便捷启动脚本...
echo @echo off > "%INSTALL_DIR%\quick-start.bat"
echo chcp 65001 ^>nul >> "%INSTALL_DIR%\quick-start.bat"
echo echo DXP4800 NAS视频库清理工具 >> "%INSTALL_DIR%\quick-start.bat"
echo echo ================================ >> "%INSTALL_DIR%\quick-start.bat"
echo echo. >> "%INSTALL_DIR%\quick-start.bat"
echo echo 请选择操作: >> "%INSTALL_DIR%\quick-start.bat"
echo echo 1. 预览模式 >> "%INSTALL_DIR%\quick-start.bat"
echo echo 2. 回收模式 >> "%INSTALL_DIR%\quick-start.bat"
echo echo 3. 直接删除模式 >> "%INSTALL_DIR%\quick-start.bat"
echo echo 4. 退出 >> "%INSTALL_DIR%\quick-start.bat"
echo echo. >> "%INSTALL_DIR%\quick-start.bat"
echo set /p choice=请输入选项 (1-4):  >> "%INSTALL_DIR%\quick-start.bat"
echo if "%%choice%%"=="1" goto preview >> "%INSTALL_DIR%\quick-start.bat"
echo if "%%choice%%"=="2" goto recycle >> "%INSTALL_DIR%\quick-start.bat"
echo if "%%choice%%"=="3" goto delete >> "%INSTALL_DIR%\quick-start.bat"
echo if "%%choice%%"=="4" exit >> "%INSTALL_DIR%\quick-start.bat"
echo goto start >> "%INSTALL_DIR%\quick-start.bat"
echo. >> "%INSTALL_DIR%\quick-start.bat"
echo :preview >> "%INSTALL_DIR%\quick-start.bat"
echo set /p video_dir=请输入视频目录路径:  >> "%INSTALL_DIR%\quick-start.bat"
echo scripts\run_video_cleaner.bat "%%video_dir%%" --dry-run >> "%INSTALL_DIR%\quick-start.bat"
echo goto start >> "%INSTALL_DIR%\quick-start.bat"
echo. >> "%INSTALL_DIR%\quick-start.bat"
echo :recycle >> "%INSTALL_DIR%\quick-start.bat"
echo set /p video_dir=请输入视频目录路径:  >> "%INSTALL_DIR%\quick-start.bat"
echo set /p recycle_dir=请输入回收目录路径 (默认: .\RecycleBin):  >> "%INSTALL_DIR%\quick-start.bat"
echo if "%%recycle_dir%%"=="" set recycle_dir=.\RecycleBin >> "%INSTALL_DIR%\quick-start.bat"
echo scripts\run_video_cleaner.bat "%%video_dir%%" --recycle "%%recycle_dir%%" >> "%INSTALL_DIR%\quick-start.bat"
echo goto start >> "%INSTALL_DIR%\quick-start.bat"
echo. >> "%INSTALL_DIR%\quick-start.bat"
echo :delete >> "%INSTALL_DIR%\quick-start.bat"
echo set /p video_dir=请输入视频目录路径:  >> "%INSTALL_DIR%\quick-start.bat"
echo echo 警告: 此操作将永久删除文件，无法恢复! >> "%INSTALL_DIR%\quick-start.bat"
echo set /p confirm=确认继续? (输入YES):  >> "%INSTALL_DIR%\quick-start.bat"
echo if "%%confirm%%"=="YES" scripts\run_video_cleaner.bat "%%video_dir%%" >> "%INSTALL_DIR%\quick-start.bat"
echo goto start >> "%INSTALL_DIR%\quick-start.bat"

rem 清理临时文件
echo 清理临时文件...
cd /d "%TEMP%"
rmdir /s /q "%TEMP_DIR%" >nul 2>&1

echo.
echo ================================================
echo               安装完成!
echo ================================================
echo.
echo 安装目录: %INSTALL_DIR%
echo 项目地址: %GITHUB_URL%
echo.
echo 使用方法:
echo 1. 便捷启动: 双击 %INSTALL_DIR%\quick-start.bat
echo 2. 预览模式: %INSTALL_DIR%\scripts\run_video_cleaner.bat "D:\Video" --dry-run
echo 3. 回收模式: %INSTALL_DIR%\scripts\run_video_cleaner.bat "D:\Video" --recycle "Recycle"
echo.
echo 更多信息请查看: %INSTALL_DIR%\docs\README_NAS_Setup.md
echo.
echo 按任意键打开安装目录...
pause >nul

rem 打开安装目录
explorer "%INSTALL_DIR%"

echo 安装完成！
echo.