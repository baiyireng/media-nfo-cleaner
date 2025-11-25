@echo off
REM 一键Docker部署脚本 for Windows
REM 使用方法: docker_deploy.bat "视频库路径" [选项]

:: 检查参数
if "%~1"=="" (
    echo.
    echo 错误: 请指定视频库路径
    echo 使用方法: %0 "视频库路径" [选项]
    echo 示例: %0 "D:\Video" --recycle "D:\Recycle"
    echo       %0 "D:\Video" --dry-run --ignore-dir "temp" --max-size 1024
    exit /b 1
)

:: 设置变量
set VIDEO_PATH=%~1
set IMAGE_NAME=baiyiren/media-nfo-cleaner:latest
set CONTAINER_NAME=media-nfo-cleaner

:: 转换Windows路径为Docker兼容路径
set DOCKER_VIDEO_PATH=/data/video
set DOCKER_RECYCLE_PATH=/data/recycle

:: 显示配置信息
echo.
echo =====================================
echo   一键Docker部署 - 视频库清理工具
echo =====================================
echo.
echo 视频库路径: %VIDEO_PATH%
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
set "RUN_CMD=docker run -it --rm --name %CONTAINER_NAME% -v "%VIDEO_PATH%:%DOCKER_VIDEO_PATH%""

:: 解析其他参数
set "ARGS="
set /a COUNT=2
:LOOP
if "%~2"=="" goto CONTINUE
    :: 处理--recycle参数
    if "%~2"=="--recycle" (
        set "ARGS=%ARGS% --recycle %DOCKER_RECYCLE_PATH%"
        :: 添加回收目录挂载
        shift
        if "%~2"=="" (
            echo 错误: --recycle 需要指定回收目录路径
            exit /b 1
        )
        set RECYCLE_PATH=%~2
        set "RUN_CMD=%RUN_CMD% -v "%RECYCLE_PATH%:%DOCKER_RECYCLE_PATH%""
    ) else (
        :: 其他参数直接传递
        set "ARGS=%ARGS% %~2"
    )
    shift
goto LOOP

:CONTINUE
:: 添加默认命令参数（如果没有指定任何选项，默认使用预览模式）
if "%ARGS%"=="" (
    set "ARGS=--dry-run"
)

:: 构建完整命令
set "FULL_CMD=%RUN_CMD% %IMAGE_NAME% %DOCKER_VIDEO_PATH%%ARGS%"

:: 执行容器运行
echo.
echo 正在启动容器...
echo.
echo 运行命令: %FULL_CMD%
echo.
call %FULL_CMD%

:: 检查执行结果
if %errorlevel% equ 0 (
    echo.
    echo 容器执行完成！
) else (
    echo.
    echo 容器执行失败！
    exit /b %errorlevel%
)