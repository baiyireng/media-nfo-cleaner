@echo off
REM 一键Docker部署脚本 for Windows
REM 使用方法: docker_deploy.bat "视频库路径" [回收目录路径]

:: 检查参数
if "%~1"=="" (
    echo.
    echo 错误: 请指定视频库路径
    echo 使用方法: %0 "视频库路径" [回收目录路径]
    echo 示例: %0 "D:\\Video" "D:\\Recycle"
    exit /b 1
)

:: 设置变量
set VIDEO_PATH=%~1
set RECYCLE_PATH=%~2
set IMAGE_NAME=baiyiren/media-nfo-cleaner:latest
set CONTAINER_NAME=media-nfo-cleaner

:: 转换Windows路径为Docker兼容路径
set DOCKER_VIDEO_PATH=/data/video
set DOCKER_RECYCLE_PATH=/data/recycle

:: 显示配置信息
echo.
echo ======================================
echo   一键Docker部署 - 视频库清理工具
echo ======================================
echo.
echo 视频库路径: %VIDEO_PATH%
if not ""=="%RECYCLE_PATH%" (
    echo 回收目录路径: %RECYCLE_PATH%
)
echo 镜像名称: %IMAGE_NAME%
echo 容器名称: %CONTAINER_NAME%
echo.

:: 拉取最新镜像
echo 正在拉取最新镜像...
docker pull %IMAGE_NAME%
if %errorlevel% neq 0 (
    echo 镜像拉取失败，请检查网络连接和Docker配置
    exit /b 1
)

:: 构建运行命令
set "RUN_CMD=docker run -it --rm --name %CONTAINER_NAME% -v \"%VIDEO_PATH%:%DOCKER_VIDEO_PATH%\""

:: 添加回收目录挂载（如果指定了）
if not ""=="%RECYCLE_PATH%" (
    set "RUN_CMD=%RUN_CMD% -v \"%RECYCLE_PATH%:%DOCKER_RECYCLE_PATH%\""
)

:: 添加默认命令参数
if not ""=="%RECYCLE_PATH%" (
    set "RUN_CMD=%RUN_CMD% %IMAGE_NAME% %DOCKER_VIDEO_PATH% --recycle %DOCKER_RECYCLE_PATH%"
) else (
    set "RUN_CMD=%RUN_CMD% %IMAGE_NAME% %DOCKER_VIDEO_PATH% --dry-run"
)

:: 执行容器运行
echo.
echo 正在启动容器...
echo.
echo 运行命令: %RUN_CMD%
echo.
call %RUN_CMD%

:: 检查执行结果
if %errorlevel% equ 0 (
    echo.
    echo 容器执行完成！
) else (
    echo.
    echo 容器执行失败！
    exit /b %errorlevel%
)