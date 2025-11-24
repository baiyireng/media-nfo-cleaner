@echo off
chcp 65001 >nul
echo 视频库清理工具 - 回收模式
echo.

if "%~1"=="" (
    echo 使用方法:
    echo   %0 [视频目录路径] [回收目录名称]
    echo.
    echo 参数说明:
    echo   视频目录路径     - 要清理的视频库目录路径
    echo   回收目录名称     - 在视频目录下创建的回收目录名称（可选，默认: RecycleBin）
    echo.
    echo 示例:
    echo   %0 "D:\Video"                    -- 在视频目录下创建RecycleBin
    echo   %0 "D:\Video" "MyRecycle"       -- 在视频目录下创建MyRecycle
    echo.
    pause
    exit /b 1
)

set "VIDEO_PATH=%~1"
set "RECYCLE_NAME=%~2"
set "SCRIPT_DIR=%~dp0.."
set "BIN_DIR=%SCRIPT_DIR%\bin"

if "%RECYCLE_NAME%"=="" (
    set "RECYCLE_NAME=RecycleBin"
)

set "RECYCLE_DIR=%VIDEO_PATH%\%RECYCLE_NAME%"

if not exist "%BIN_DIR%\video_library_cleaner.py" (
    echo 错误: 找不到 video_library_cleaner.py 文件
    echo 请确保安装目录正确
    pause
    exit /b 1
)

if not exist "%RECYCLE_DIR%" mkdir "%RECYCLE_DIR%"

echo 正在运行视频库清理脚本...
echo 视频库路径: %VIDEO_PATH%
echo 回收目录: %RECYCLE_DIR%

python bin/video_library_cleaner.py "%VIDEO_PATH%" --recycle "%RECYCLE_DIR%"

echo.
pause