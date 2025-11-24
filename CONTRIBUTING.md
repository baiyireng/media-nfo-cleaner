# 贡献指南

感谢您对DXP4800 NAS视频库清理工具的关注！我们欢迎各种形式的贡献，包括但不限于：

- 报告问题
- 提出功能建议
- 提交代码改进
- 改进文档
- 分享使用经验

## 如何贡献

### 报告问题

如果您发现任何问题或错误，请通过以下步骤报告：

1. 检查是否已有相关的Issue
2. 如果没有，请创建新的Issue
3. 提供详细的问题描述，包括：
   - 操作系统和版本
   - Python版本
   - 使用的命令和参数
   - 错误信息和日志
   - 预期行为与实际行为的差异

### 提交代码改进

1. Fork本项目到您的GitHub账户
2. 创建功能分支：`git checkout -b feature/AmazingFeature`
3. 进行修改，并确保：
   - 代码符合项目的编码规范
   - 添加必要的注释
   - 更新相关文档
4. 提交更改：`git commit -m 'Add some AmazingFeature'`
5. 推送到分支：`git push origin feature/AmazingFeature`
6. 创建Pull Request

### 编码规范

- Python代码遵循PEP 8规范
- Shell脚本遵循Google Shell Style Guide
- 添加适当的注释
- 确保跨平台兼容性（Windows/Linux）

## 开发环境设置

### 准备环境

1. 克隆仓库：
   ```bash
   git clone https://github.com/northsea4/mdcx-docker.git
   cd mdcx-docker
   ```

2. 设置Python环境：
   ```bash
   # 创建虚拟环境（推荐）
   python3 -m venv venv
   source venv/bin/activate  # Linux/macOS
   # 或
   venv\Scripts\activate  # Windows
   ```

### 测试您的更改

1. 在测试数据上运行脚本：
   ```bash
   # 预览模式
   python3 bin/video_library_cleaner.py /path/to/test/data --dry-run
   
   # 回收模式
   python3 bin/video_library_cleaner.py /path/to/test/data --recycle /tmp/recycle
   ```

2. 确保更改不会破坏现有功能

### 文档更新

如果您的更改影响用户界面或功能，请更新相关文档：

- `docs/README_video_cleaner.md` - 基本使用指南
- `docs/README_NAS_Setup.md` - NAS设置指南
- `docs/README_MultiPlatform.md` - 多平台支持

## 发布流程

1. 更新版本号（如果适用）
2. 更新CHANGELOG.md
3. 创建发布标签
4. 创建GitHub Release

## 社区行为准则

我们致力于为每个人提供友好、安全和欢迎的环境。请：

- 尊重他人，保持礼貌
- 接受建设性的批评
- 专注于对社区最有利的事情
- 对其他社区成员表示同理心

## 获取帮助

如果您有任何问题或需要帮助，请：

1. 查看现有文档
2. 搜索已有的Issues
3. 创建新的Issue，并使用"question"标签

## 许可证

通过贡献代码，您同意您的贡献将在MIT许可证下授权。