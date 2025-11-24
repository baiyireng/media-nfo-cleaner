@echo off
chcp 65001 >nul
echo 视频库清理工具
echo.

if "%~1"=="" (
    echo 使用方法:
    echo   %0 [视频目录路径] [选项]
    echo.
    echo 参数说明:
    echo   视频目录路径     - 要清理的视频库目录路径
    echo   --dry-run        - 预览模式，只显示将要删除的目录而不实际删除
    echo   --recycle [目录] - 回收模式，将删除内容移动到指定目录
    echo.
    echo 示例:
    echo   %0 "D:\Video"                     -- 直接清理
    echo   %0 "D:\Video" --dry-run           -- 预览模式
    echo   %0 "D:\Video" --recycle "Recycle" -- 回收模式
    echo.
    pause
    exit /b 1
)

set "VIDEO_PATH=%~1"
set "SCRIPT_DIR=%~dp0.."
set "BIN_DIR=%SCRIPT_DIR%\bin"
set "PYTHON_CMD=python"
set "RECYCLE_DIR=%VIDEO_PATH%\RecycleBin"

if not exist "%BIN_DIR%\video_library_cleaner.py" (
    echo 错误: 找不到 video_library_cleaner.py 文件
    echo 请确保安装目录正确
    pause
    exit /b 1
)

echo 正在运行视频库清理脚本...

:: 检查是否为回收模式
if "%2"=="--recycle" (
    if "%3"=="" (
        :: 如果没有指定回收目录，则在视频库根目录下创建RecycleBin
        if not exist "%RECYCLE_DIR%" mkdir "%RECYCLE_DIR%"
        echo 回收目录: %RECYCLE_DIR%
        python bin/video_library_cleaner.py "%VIDEO_PATH%" --recycle "%RECYCLE_DIR%" %4 %5 %6 %7 %8 %9
    ) else (
        set "RECYCLE_PATH=%~3"
        echo 回收目录: %RECYCLE_PATH%
        python bin/video_library_cleaner.py "%VIDEO_PATH%" --recycle "%RECYCLE_PATH%" %4 %5 %6 %7 %8 %9
    )
) else (
    python bin/video_library_cleaner.py "%VIDEO_PATH%" %2 %3 %4 %5 %6 %7 %8 %9
)

echo.
pause