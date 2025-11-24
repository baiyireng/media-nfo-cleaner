@echo off
chcp 65001 >nul
echo DXP4800 NAS视频库清理工具 - 回收模式
echo.

set "VIDEO_DIR=%~1"
set "RECYCLE_DIR=%~2"

if "%VIDEO_DIR%"=="" (
    echo 使用方法:
    echo   %0 [视频目录路径] [回收站目录名]
    echo.
    echo 参数说明:
    echo   视频目录路径     - 要清理的视频库目录路径
    echo   回收站目录名     - 用于存放删除内容的目录名
    echo.
    echo 示例:
    echo   %0 "D:\Video" "Recycle"         -- 将清理内容移动到D:\Video\Recycle
    echo   %0 "D:\Video" "D:\Temp\VideoRecycle" -- 指定绝对路径
    echo.
    pause
    exit /b 1
)

if "%RECYCLE_DIR%"=="" (
    set "RECYCLE_DIR=RecycleBin"
)

echo 视频目录: %VIDEO_DIR%
echo 回收目录: %RECYCLE_DIR%
echo.

echo 正在运行回收模式清理脚本...
echo 注意: 文件将被移动到回收站目录，而非永久删除
echo.

python bin/video_library_cleaner.py "%VIDEO_DIR%" --recycle "%RECYCLE_DIR%"
echo.
pause