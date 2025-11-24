@echo off
chcp 65001 >nul
echo DXP4800 NAS视频库清理工具 - 示例用法
echo.

echo ============================================
echo 1. 预览模式检查D盘Video目录
echo ============================================
echo.
scripts\scripts\run_video_cleaner.bat "D:\Video" --dry-run
echo.
pause

echo ============================================
echo 2. 预览模式检查网络共享目录
echo ============================================
echo.
scripts\run_video_cleaner.bat "\\NAS\Video\Movies" --dry-run
echo.
pause

echo ============================================
echo 3. 回收模式清理D盘Video目录（推荐）
echo ============================================
echo.
echo 使用回收模式，将删除的内容移动到指定目录，可恢复
echo.
scripts\scripts\scripts\run_video_cleaner.bat "D:\Video" --recycle "VideoRecycle"
echo.
pause

echo ============================================
echo 4. 实际清理模式（仅在确认预览结果正确后使用）
echo ============================================
echo.
echo 警告：此操作将永久删除文件，无法恢复！
echo.
set /p confirm="确认执行实际清理？(输入YES继续): "
if /i "%confirm%"=="YES" (
    scripts\run_video_cleaner.bat "D:\Video"
) else (
    echo 操作已取消
)
echo.
pause

echo ============================================
echo 5. 组合使用示例：先预览，再回收模式清理
echo ============================================
echo.
echo 第一步：预览检查
scripts\scripts\run_video_cleaner.bat "D:\Video" --dry-run
echo.
echo 第二步：回收模式清理
scripts\scripts\scripts\run_video_cleaner.bat "D:\Video" --recycle "VideoRecycle"
echo.
pause