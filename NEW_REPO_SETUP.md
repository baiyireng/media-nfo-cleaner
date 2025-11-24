# 从零创建GitHub存储库指南

## 1. 创建新GitHub仓库

1. 访问 https://github.com/baiyireng/repositories
2. 点击 "New repository" 按钮
3. 填写仓库信息：
   - Repository name: `media-nfo-cleaner`（或您选择的其他名称）
   - Description: `DXP4800 NAS媒体NFO文件清理工具`
   - 选择 Public
   - 不要勾选 "Add a README file"、"Add .gitignore"等选项（我们已经有了）
4. 点击 "Create repository"

## 2. 关联本地仓库到新GitHub仓库

创建仓库后，GitHub会显示快速设置页面。在本地运行：

```bash
cd "d:/HuaweiMoveData/Users/shihufeng/Desktop/tool"
git remote add origin https://github.com/baiyireng/[您的仓库名].git
git branch -M main
git push -u origin main
```

请将 `[您的仓库名]` 替换为您在GitHub上创建的实际仓库名称。

## 3. 更新所有引用（如果仓库名称与media-nfo-cleaner不同）

如果您使用了不同的仓库名称，需要更新以下文件中的引用：

1. install.sh
2. docker/docker-compose.yml
3. .github/workflows/ci.yml
4. QUICK_INSTALL.md
5. Makefile

## 4. 设置Docker Hub (可选)

1. 访问 https://hub.docker.com/
2. 创建新仓库（与GitHub仓库名相同）
3. 在GitHub仓库设置中添加Secrets：
   - DOCKER_USERNAME: 您的Docker Hub用户名
   - DOCKER_PASSWORD: 您的Docker Hub访问令牌

## 5. 创建GitHub Release

1. 在GitHub仓库页面，点击 "Releases" -> "Create a new release"
2. 填写信息：
   - Tag version: `v1.0.0`
   - Release title: `v1.0.0 - 初始版本`
   - Description: 可以使用CHANGELOG.md中的内容
3. 点击 "Publish release"

## 6. 测试远程安装

创建仓库后，您可以使用以下命令测试：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/baiyireng/[您的仓库名]/main/install.sh)"
```

## 当前状态

✅ 本地Git仓库已准备好推送
✅ 所有远程引用已移除
✅ 等待您创建GitHub仓库并关联

## 下一步

1. 在GitHub上创建新仓库
2. 使用上述命令关联并推送
3. 测试远程安装脚本