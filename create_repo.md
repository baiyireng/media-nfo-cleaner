# 创建GitHub仓库步骤

## 1. 创建GitHub仓库

1. 访问 https://github.com/baiyireng/repositories
2. 点击 "New repository" 按钮
3. 填写仓库信息：
   - Repository name: `media-nfo-cleaner` (注意: 正确拼写，不是cleane)
   - Description: `DXP4800 NAS媒体NFO文件清理工具`
   - 选择 Public
   - 不要勾选 "Add a README file"（我们已经有了）
4. 点击 "Create repository"

## 2. 推送代码到新仓库

创建仓库后，GitHub会显示设置说明。在本地运行：

```bash
# 确保您在正确的目录
cd "d:/HuaweiMoveData/Users/shihufeng/Desktop/tool"

# 推送代码（已配置好的远程仓库）
git push -u origin main
```

## 3. 设置Docker Hub (可选)

如果需要自动构建和推送Docker镜像：

1. 访问 https://hub.docker.com/
2. 创建仓库 `baiyireng/media-nfo-cleaner`
3. 在GitHub仓库中设置secrets：
   - DOCKER_USERNAME: 您的Docker Hub用户名
   - DOCKER_PASSWORD: 您的Docker Hub访问令牌

## 4. 创建GitHub Release

1. 在GitHub仓库页面，点击 "Releases" -> "Create a new release"
2. 填写信息：
   - Tag version: `v1.0.0`
   - Release title: `v1.0.0 - 初始版本`
   - Description: 可以使用CHANGELOG.md中的内容
3. 点击 "Publish release"

## 5. 测试远程安装

创建仓库后，您可以使用以下命令测试：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/baiyireng/media-nfo-cleaner/main/install.sh)"
```

## 重要提示

- 确保仓库名称正确拼写为 `media-nfo-cleaner`（不是 `media-nfo-cleane`）
- 本地Git仓库已经配置为指向正确的存储库：`git@github.com:baiyireng/media-nfo-cleaner.git`
- 所有文件中的引用已更新为正确的存储库名称