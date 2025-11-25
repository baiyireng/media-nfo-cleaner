# 归档模式说明

归档模式会将既没有视频文件也没有残留文件（如.nfo、图片等）的空目录移动到指定的归档目录。这对于整理和管理视频库中的空目录非常有用。

## 归档模式特点

- **选择性处理**：只处理完全空的目录（没有任何视频文件或残留文件）
- **保持目录结构**：在归档目录中保持原始目录结构
- **与其他模式兼容**：可以与忽略目录、大小限制等选项组合使用
- **安全处理**：避免误删可能含有重要数据的目录

## 适用场景

- 整理长期积累的空目录
- 为视频库进行瘦身和优化
- 备份和迁移前的目录整理

## 使用方法

### Docker命令

```bash
# 基本归档模式
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  -v /path/to/archive/directory:/data/archive \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --archive /data/archive

# 预览模式的归档
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  -v /path/to/archive/directory:/data/archive \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --archive /data/archive --dry-run

# 组合使用归档和忽略目录
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  -v /path/to/archive/directory:/data/archive \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --archive /data/archive --ignore-dir "temp" --ignore-dir "backup"

# 组合使用归档和大小限制
docker run --rm \
  -v /path/to/your/video/library:/data/video \
  -v /path/to/archive/directory:/data/archive \
  baiyiren/media-nfo-cleaner:latest \
  /data/video --archive /data/archive --max-dir-size "1GB"
```

### 一键部署脚本

#### Windows

```cmd
# 基本归档模式
scripts\docker_deploy.bat "D:\Video" --archive "D:\Archive"

# 预览模式的归档
scripts\docker_deploy.bat "D:\Video" --archive "D:\Archive" --dry-run

# 组合使用
scripts\docker_deploy.bat "D:\Video" --archive "D:\Archive" --ignore-dir "temp" --max-dir-size "1GB"
```

#### Linux/macOS

```bash
# 基本归档模式
./scripts/docker_deploy.sh "/volume1/Video" --archive "/volume1/Archive"

# 预览模式的归档
./scripts/docker_deploy.sh "/volume1/Video" --archive "/volume1/Archive" --dry-run

# 组合使用
./scripts/docker_deploy.sh "/volume1/Video" --archive "/volume1/Archive" --ignore-dir "temp" --max-dir-size "1GB"
```

## 注意事项

1. **目录结构保持**：归档模式会在归档目录中保持原始目录结构，方便后续管理。

2. **归档目录位置**：归档目录最好放在视频库外部，以避免可能的冲突。

3. **预览模式**：在使用归档模式前，建议先使用`--dry-run`选项预览将要归档的目录。

4. **与回收模式的区别**：
   - **回收模式**：移动包含残留文件但没有对应视频文件的目录
   - **归档模式**：移动既没有视频文件也没有残留文件的空目录

5. **文件冲突处理**：如果归档目录中已存在同名目录，系统会自动添加序号后缀。

6. **权限要求**：确保对源目录和归档目录有足够的读写权限。

## 最佳实践

1. **预览先行**：始终先使用预览模式检查将要归档的目录。

2. **定期归档**：定期运行归档模式，保持视频库整洁。

3. **组合使用**：结合忽略目录和大小限制，精确控制归档范围。

4. **备份策略**：在大规模归档前，考虑先备份整个视频库。

5. **监控结果**：归档后检查归档目录，确认目录结构正确。

## 故障排除

### 归档失败

如果归档操作失败，检查以下问题：

1. 确保归档目录存在且有写入权限
2. 检查源目录是否为空（没有视频文件和残留文件）
3. 检查磁盘空间是否足够
4. 查看错误日志，了解具体失败原因

### 归档了错误的目录

如果发现错误的目录被归档：

1. 检查归档目录，找到被错误归档的目录
2. 将其手动移回原位置
3. 使用`--dry-run`选项重新预览，确认归档列表
4. 添加适当的忽略选项，避免再次错误归档