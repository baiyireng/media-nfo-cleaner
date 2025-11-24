@echo off
chcp 65001 >nul
echo DXP4800 NAS视频库清理工具
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

echo 正在运行视频库清理脚本...
python bin/video_library_cleaner.py %*
echo.
pause