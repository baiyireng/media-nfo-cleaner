#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
视频库清理工具
用于清理残留的.nfo文件和预览、缩略图等辅助文件
"""

import os
import sys
import re
import shutil
import argparse
import datetime
from pathlib import Path

# 常见的视频文件扩展名
VIDEO_EXTENSIONS = {
    '.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv', '.webm', '.m4v', 
    '.3gp', '.mpg', '.mpeg', '.ts', '.m2ts', '.rm', '.rmvb', '.divx', 
    '.xvid', '.f4v', '.asf', '.vob', '.ogv'
}

# 常见的残留文件扩展名（通常由媒体管理器生成）
RESIDUAL_EXTENSIONS = {
    '.nfo', '.jpg', '.jpeg', '.png', '.gif', '.tbn', '.tbm', '.tbn',
    '.srr', '.srs', '.sfv', '.nzb', '.par2', '.idx', '.sub', '.txt',
    '.xml', '.json', '.db', '.dat', '.log', '.rar', '.zip'
}

# 常见的预览/缩略图文件名模式
THUMBNAIL_PATTERNS = [
    r'.*poster\.jpg$', r'.*fanart\.jpg$', r'.*banner\.jpg$',
    r'.*thumb\.jpg$', r'.*cover\.jpg$', r'.*landscape\.jpg$',
    r'.*clearart\.png$', r'.*logo\.png$', r'.*disc\.png$',
    r'.*extrathumbs.*', r'.*sample.*', r'.*trailer.*',
    r'.*-preview.*', r'.*-thumb.*', r'.*-poster.*'
]

def is_video_file(file_path):
    """判断文件是否为视频文件"""
    return Path(file_path).suffix.lower() in VIDEO_EXTENSIONS

def is_residual_file(file_path):
    """判断文件是否为残留文件"""
    path = Path(file_path)
    if path.suffix.lower() in RESIDUAL_EXTENSIONS:
        return True
    
    # 检查文件名是否匹配缩略图/预览图模式
    filename = path.name.lower()
    for pattern in THUMBNAIL_PATTERNS:
        if re.search(pattern, filename, re.IGNORECASE):
            return True
    return False

def extract_video_path_from_nfo(nfo_path):
    """从.nfo文件中提取视频文件路径，可能是相对路径或绝对路径"""
    try:
        with open(nfo_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # 尝试从NFO文件中提取视频文件名或路径
        # 常见的媒体信息软件会在此处记录文件名
        for line in content.split('\n'):
            if '<filename>' in line and '</filename>' in line:
                match = re.search(r'<filename>(.*?)</filename>', line)
                if match:
                    return match.group(1).strip()
            
            # 也尝试查找path标签
            if '<path>' in line and '</path>' in line:
                match = re.search(r'<path>(.*?)</path>', line)
                if match:
                    return match.group(1).strip()
    except Exception as e:
        print(f"读取NFO文件 {nfo_path} 时出错: {e}")
    
    # 如果无法从NFO内容中提取，则尝试从文件名推断
    nfo_name = Path(nfo_path).stem
    
    # 尝试所有可能的视频扩展名
    for ext in VIDEO_EXTENSIONS:
        potential_video = Path(nfo_path).parent / (nfo_name + ext)
        if potential_video.exists():
            return potential_video.name
    
    return None

def check_video_exists(video_info, nfo_dir):
    """检查视频文件是否存在，处理相对路径和绝对路径"""
    if not video_info:
        return False, None
    
    video_path = Path(video_info)
    
    # 如果是绝对路径，直接检查
    if video_path.is_absolute():
        if video_path.exists():
            return True, video_path
        return False, video_path
    
    # 如果是相对路径，相对于NFO文件所在目录检查
    relative_path = nfo_dir / video_path
    if relative_path.exists():
        return True, relative_path
    
    # 如果相对路径不存在，也尝试在NFO目录直接查找同名文件
    filename = video_path.name
    for ext in VIDEO_EXTENSIONS:
        potential_video = nfo_dir / (Path(filename).stem + ext)
        if potential_video.exists():
            return True, potential_video
    
    return False, relative_path

def setup_recycle_bin(recycle_dir):
    """设置回收站目录，确保存在"""
    recycle_path = Path(recycle_dir)
    if not recycle_path.exists():
        try:
            recycle_path.mkdir(parents=True, exist_ok=True)
            print(f"创建回收站目录: {recycle_dir}")
        except Exception as e:
            print(f"创建回收站目录失败: {e}")
            return False
    return True

def move_to_recycle(source, recycle_dir, preserve_structure=True, base_dir=None):
    """将文件或目录移动到回收站目录"""
    try:
        source_path = Path(source)
        if not source_path.exists():
            return False
            
        recycle_path = Path(recycle_dir)
        
        # 检查回收目录是否在源目录内，如果是则不保持目录结构
        recycle_in_source = False
        if base_dir:
            base_path = Path(base_dir)
            try:
                # 检查回收目录是否是源目录的子目录
                recycle_in_source = recycle_path.is_relative_to(base_path) or recycle_path == base_path
            except AttributeError:
                # 对于旧版本Python，使用替代方法
                try:
                    recycle_rel = recycle_path.relative_to(base_path)
                    recycle_in_source = len(str(recycle_rel).split(os.sep)) > 0
                except ValueError:
                    recycle_in_source = False
        
        if preserve_structure and not recycle_in_source:
            # 保持相对目录结构
            # 计算从根目录到源的相对路径
            if base_dir:
                try:
                    relative_path = source_path.relative_to(base_dir)
                    # 在回收站中创建相同的目录结构
                    dest_parent = recycle_path / relative_path.parent
                    dest_parent.mkdir(parents=True, exist_ok=True)
                    dest = dest_parent / source_path.name
                except ValueError:
                    # 如果无法计算相对路径，则使用父目录名
                    sub_dir = recycle_path / source_path.parent.name
                    sub_dir.mkdir(exist_ok=True)
                    dest = sub_dir / source_path.name
            else:
                # 如果没有提供基础目录，则使用源路径的父目录名作为子目录
                if source_path.is_file():
                    sub_dir = recycle_path / source_path.parent.name
                    sub_dir.mkdir(exist_ok=True)
                    dest = sub_dir / source_path.name
                else:
                    dest = recycle_path / source_path.name
        else:
            # 回收目录在源目录内或不保持结构，所有内容放在回收站根目录
            dest = recycle_path / source_path.name
        
        # 处理文件名冲突
        counter = 1
        original_dest = dest
        while dest.exists():
            if dest.is_file():
                stem = original_dest.stem
                suffix = original_dest.suffix
                dest = original_dest.parent / f"{stem}_{counter}{suffix}"
            else:
                dest = original_dest.parent / f"{original_dest.name}_{counter}"
            counter += 1
        
        # 移动文件或目录
        shutil.move(str(source_path), str(dest))
        return True
    except Exception as e:
        print(f"移动到回收站失败: {e}")
        return False

def process_root_nfo_files(root_dir, dry_run=False, recycle_dir=None, max_file_size_bytes=0):
    """处理根目录下的NFO文件"""
    print(f"\n检查根目录下的NFO文件: {root_dir}")
    
    root_path = Path(root_dir)
    nfo_files = list(root_path.glob('*.nfo'))
    
    if not nfo_files:
        print("  根目录下未找到NFO文件")
        return
    
    for nfo_file in nfo_files:
        # 检查文件大小限制
        if max_file_size_bytes > 0 and not check_file_size(nfo_file, max_file_size_bytes):
            print(f"  跳过NFO文件（超过大小限制）: {nfo_file.name} ({format_size(nfo_file.stat().st_size)})")
            continue
        
        print(f"  检查NFO文件: {nfo_file.name}")
        
        # 检查是否存在同名的视频文件
        nfo_name = nfo_file.stem
        found_matching_video = False
        
        for ext in VIDEO_EXTENSIONS:
            potential_video = root_path / (nfo_name + ext)
            if potential_video.exists():
                print(f"    发现同名视频文件: {potential_video.name}")
                found_matching_video = True
                break
        
        # 如果没有同名视频文件，尝试从NFO文件中提取视频路径
        if not found_matching_video:
            video_info = extract_video_path_from_nfo(nfo_file)
            if video_info:
                exists, video_path = check_video_exists(video_info, root_path)
                if exists:
                    print(f"    从NFO中找到的视频文件存在: {video_path}")
                    found_matching_video = True
                else:
                    print(f"    从NFO中找到的视频文件不存在: {video_path}")
        
        # 如果没有找到匹配的视频文件，检查NFO文件是否应该被删除
        if not found_matching_video:
            print(f"  未找到匹配的视频文件，可删除NFO文件: {nfo_file.name}")
            
            if dry_run:
                if recycle_dir:
                    print(f"    [DRY RUN] 将移动文件到回收站: {nfo_file.name}")
                else:
                    print(f"    [DRY RUN] 将删除文件: {nfo_file.name}")
            else:
                if recycle_dir:
                    # 移动到回收站
                    if move_to_recycle(nfo_file, recycle_dir):
                        print(f"    已移动文件到回收站: {nfo_file.name}")
                    else:
                        print(f"    移动文件失败: {nfo_file.name}")
                else:
                    # 直接删除
                    try:
                        nfo_file.unlink()
                        print(f"    已删除文件: {nfo_file.name}")
                    except Exception as e:
                        print(f"    删除文件失败: {e}")

def should_ignore_directory(dir_path, ignore_dirs, base_dir):
    """检查目录是否应该被忽略"""
    if not ignore_dirs:
        return False
    
    dir_path = Path(dir_path)
    
    for ignore_dir in ignore_dirs:
        ignore_path = Path(ignore_dir)
        
        # 如果忽略路径是绝对路径，直接比较
        if ignore_path.is_absolute():
            if dir_path.is_relative_to(ignore_path):
                return True
        else:
            # 如果忽略路径是相对路径，相对于base_dir进行比较
            if base_dir:
                full_ignore_path = Path(base_dir) / ignore_path
                if dir_path.is_relative_to(full_ignore_path):
                    return True
            
            # 或者比较目录名
            if dir_path.name == ignore_path.name:
                return True
    
    return False

def parse_size(size_str):
    """解析大小字符串，支持KB, MB, GB, TB等单位，返回字节数"""
    if not size_str:
        return 0
    
    size_str = size_str.upper().strip()
    # 如果只包含数字，默认为MB
    if size_str.isdigit():
        return int(size_str) * 1024 * 1024
    
    # 解析数字和单位
    import re
    match = re.match(r'^(\d+(?:\.\d+)?)\s*([KMGT]?B?)$', size_str)
    if not match:
        raise ValueError(f"无效的大小格式: {size_str}")
    
    value = float(match.group(1))
    unit = match.group(2) or 'MB'  # 默认单位为MB
    
    # 转换为字节
    multipliers = {
        'B': 1,
        'KB': 1024,
        'K': 1024,
        'MB': 1024 * 1024,
        'M': 1024 * 1024,
        'GB': 1024 * 1024 * 1024,
        'G': 1024 * 1024 * 1024,
        'TB': 1024 * 1024 * 1024 * 1024,
        'T': 1024 * 1024 * 1024 * 1024
    }
    
    if unit not in multipliers:
        raise ValueError(f"不支持的大小单位: {unit}")
    
    return int(value * multipliers[unit])

def format_size(bytes_size):
    """格式化字节数为人类可读的大小字符串"""
    if bytes_size == 0:
        return "0B"
    
    units = ['B', 'KB', 'MB', 'GB', 'TB']
    i = 0
    size = float(bytes_size)
    
    while size >= 1024 and i < len(units) - 1:
        size /= 1024
        i += 1
    
    return f"{size:.2f}{units[i]}"

def get_directory_size(dir_path, max_size_bytes):
    """计算目录大小，如果超过max_size_bytes则返回False"""
    if max_size_bytes <= 0:
        return True  # 大小为0或负数表示不限制
    
    total_size = 0
    
    try:
        for file_path in dir_path.rglob('*'):
            if file_path.is_file():
                total_size += file_path.stat().st_size
                if total_size > max_size_bytes:
                    print(f"  目录大小已超过限制: {format_size(total_size)} > {format_size(max_size_bytes)}")
                    return False
        return True
    except Exception as e:
        print(f"计算目录大小时出错: {e}")
        return True  # 出错时默认允许处理

def check_file_size(file_path, max_file_size_bytes):
    """检查文件大小是否超过限制"""
    if max_file_size_bytes <= 0:
        return True  # 大小为0或负数表示不限制
    
    try:
        file_size = file_path.stat().st_size
        if file_size > max_file_size_bytes:
            print(f"  文件大小超过限制: {file_path.name} ({format_size(file_size)} > {format_size(max_file_size_bytes)})")
            return False
        return True
    except Exception as e:
        print(f"检查文件大小时出错: {e}")
        return True  # 出错时默认允许处理

def archive_directory(dir_path, archive_dir, base_dir=None):
    """归档目录"""
    try:
        source_path = Path(dir_path)
        if not source_path.exists():
            return False
            
        archive_path = Path(archive_dir)
        
        # 检查归档目录是否在源目录内
        archive_in_source = False
        if base_dir:
            base_path = Path(base_dir)
            try:
                archive_in_source = archive_path.is_relative_to(base_path) or archive_path == base_path
            except AttributeError:
                try:
                    archive_rel = archive_path.relative_to(base_path)
                    archive_in_source = len(str(archive_rel).split(os.sep)) > 0
                except ValueError:
                    archive_in_source = False
        
        # 创建归档目录结构
        if base_dir and not archive_in_source:
            try:
                relative_path = source_path.relative_to(base_dir)
                # 在归档目录中创建相同的目录结构
                dest_parent = archive_path / relative_path.parent
                dest_parent.mkdir(parents=True, exist_ok=True)
                dest = dest_parent / source_path.name
            except ValueError:
                # 如果无法计算相对路径，则使用父目录名
                sub_dir = archive_path / source_path.parent.name
                sub_dir.mkdir(exist_ok=True)
                dest = sub_dir / source_path.name
        else:
            # 归档目录在源目录内或不保持结构
            dest = archive_path / source_path.name
        
        # 处理文件名冲突
        counter = 1
        original_dest = dest
        while dest.exists():
            if dest.is_file():
                stem = original_dest.stem
                suffix = original_dest.suffix
                dest = original_dest.parent / f"{stem}_{counter}{suffix}"
            else:
                dest = original_dest.parent / f"{original_dest.name}_{counter}"
            counter += 1
        
        # 移动目录到归档位置
        shutil.move(str(source_path), str(dest))
        return True
    except Exception as e:
        print(f"归档目录失败: {e}")
        return False

def process_directory(directory, dry_run=False, recycle_dir=None, archive_dir=None, ignore_dirs=None, max_dir_size="0", max_file_size="0"):
    """处理指定目录"""
    print(f"\n处理目录: {directory}")
    
    # 处理忽略目录
    if ignore_dirs:
        print(f"忽略目录: {', '.join(ignore_dirs)}")
    
    # 处理归档选项
    if archive_dir:
        print(f"归档目录: {archive_dir}")
    
    # 解析大小限制
    try:
        max_dir_size_bytes = parse_size(max_dir_size)
        max_file_size_bytes = parse_size(max_file_size)
    except ValueError as e:
        print(f"错误: {e}")
        return
    
    # 处理目录大小限制
    if max_dir_size_bytes > 0:
        print(f"目录大小限制: {format_size(max_dir_size_bytes)}")
    
    # 处理文件大小限制
    if max_file_size_bytes > 0:
        print(f"文件大小限制: {format_size(max_file_size_bytes)}")
    
    # 设置归档目录
    archive_path = None
    if archive_dir:
        archive_path = Path(archive_dir)
        # 如果归档目录是相对路径，则相对于目标目录
        if not archive_path.is_absolute():
            archive_path = Path(directory) / archive_path
        
        # 创建归档目录
        if not archive_path.exists():
            try:
                archive_path.mkdir(parents=True, exist_ok=True)
                print(f"创建归档目录: {archive_path}")
            except Exception as e:
                print(f"创建归档目录失败: {e}")
                archive_path = None
    
    # 首先处理根目录下的NFO文件
    process_root_nfo_files(directory, dry_run, recycle_dir, max_file_size_bytes)
    
    # 获取所有子目录
    all_subdirs = [d for d in Path(directory).iterdir() if d.is_dir() and d.name != 'recycle']
    
    # 过滤掉回收站目录和归档目录
    recycle_path = Path(recycle_dir).resolve() if recycle_dir else None
    if recycle_path:
        all_subdirs = [d for d in all_subdirs if not d.resolve().is_relative_to(recycle_path)]
    
    if archive_path:
        all_subdirs = [d for d in all_subdirs if not d.resolve().is_relative_to(archive_path)]
    
    if not all_subdirs:
        print("未找到子目录")
        return
    
    # 检查每个目录
    for dir_path in all_subdirs:
        print(f"\n检查目录: {dir_path}")
        
        # 检查是否在忽略目录列表中
        if should_ignore_directory(dir_path, ignore_dirs, directory):
            print(f"  在忽略列表中，跳过目录: {dir_path}")
            continue
        
        # 检查目录大小限制
        if not get_directory_size(dir_path, max_dir_size_bytes):
            print(f"  目录大小超过限制 ({format_size(max_dir_size_bytes)})，跳过: {dir_path}")
            continue
        
        # 查找该目录下的所有文件
        all_files = list(dir_path.glob('*'))
        video_files = [f for f in all_files if f.is_file() and is_video_file(f)]
        nfo_files_in_dir = [f for f in all_files if f.is_file() and f.suffix.lower() == '.nfo']
        other_files = [f for f in all_files if f.is_file() and is_residual_file(f)]
        
        # 如果有视频文件，跳过此目录
        if video_files:
            print(f"  发现视频文件，跳过此目录: {[f.name for f in video_files]}")
            continue
        
        # 处理有NFO文件或其他残留文件的目录
        if nfo_files_in_dir or other_files:
            files_to_process = []
            
            # 检查每个NFO文件对应的视频是否存在
            all_videos_exist = True
            for nfo_file in nfo_files_in_dir:
                video_info = extract_video_path_from_nfo(nfo_file)
                if not video_info:
                    print(f"    无法从NFO文件 {nfo_file.name} 提取视频路径")
                    all_videos_exist = False
                    continue
                
                exists, video_path = check_video_exists(video_info, dir_path)
                if exists:
                    print(f"    视频文件存在: {video_path}")
                else:
                    print(f"    视频文件不存在: {video_path}")
                    all_videos_exist = False
                    files_to_process.append(nfo_file)
            
            # 检查其他残留文件的大小
            for file in other_files:
                if not check_file_size(file, max_file_size_bytes):
                    continue  # 跳过超过大小限制的文件
                files_to_process.append(file)
            
            # 如果有需要处理的文件，则处理
            if files_to_process:
                print(f"  发现以下需要处理的文件:")
                for f in files_to_process:
                    print(f"    - {f.name} ({format_size(f.stat().st_size)})")
                
                if not all_videos_exist and not video_files:
                    print(f"  确认删除文件和目录: {dir_path}")
                    
                    if dry_run:
                        if recycle_dir:
                            print(f"    [DRY RUN] 将移动目录到回收站")
                        else:
                            print(f"    [DRY RUN] 将删除目录及其内容")
                    else:
                        if recycle_dir:
                            # 移动到回收站
                            if move_to_recycle(dir_path, recycle_dir, True, directory):
                                print(f"    已移动目录到回收站")
                            else:
                                print(f"    移动目录失败")
                        else:
                            # 直接删除
                            try:
                                shutil.rmtree(dir_path)
                                print(f"    已删除目录及其内容")
                            except Exception as e:
                                print(f"    删除目录失败: {e}")
        
        # 处理既没有视频文件也没有残留文件的空目录（仅当启用归档时）
        elif not video_files and not nfo_files_in_dir and not other_files and archive_path:
            print(f"  目录为空，将归档: {dir_path}")
            
            if dry_run:
                print(f"    [DRY RUN] 将归档目录")
            else:
                if archive_directory(dir_path, archive_path, directory):
                    print(f"    已归档目录")
                else:
                    print(f"    归档目录失败")

def main():
    parser = argparse.ArgumentParser(description='视频库清理工具')
    parser.add_argument('directory', help='要清理的视频库目录路径')
    parser.add_argument('--dry-run', action='store_true', 
                       help='预览模式，只显示将要删除的目录而不实际删除')
    parser.add_argument('--recycle', type=str, metavar='RECYCLE_DIR',
                       help='回收模式：将删除的内容移动到指定目录而非永久删除')
    parser.add_argument('--archive', type=str, metavar='ARCHIVE_DIR',
                       help='归档模式：将既无视频文件也无残留文件的目录移动到指定目录')
    parser.add_argument('--ignore-dir', action='append', dest='ignore_dirs', metavar='DIR',
                       help='指定要忽略的目录，可多次使用。支持相对路径和绝对路径')
    parser.add_argument('--max-dir-size', type=str, dest='max_dir_size', default='0', metavar='SIZE',
                       help='限制处理的目录最大大小，支持KB, MB, GB等单位 (默认: 0=不限制)')
    parser.add_argument('--max-file-size', type=str, dest='max_file_size', default='0', metavar='SIZE',
                       help='限制处理的文件最大大小，支持KB, MB, GB等单位 (默认: 0=不限制)')
    
    args = parser.parse_args()
    
    # 检查目录是否存在
    if not os.path.isdir(args.directory):
        print(f"错误: 目录 {args.directory} 不存在")
        sys.exit(1)
    
    # 处理回收站目录
    recycle_dir = None
    if args.recycle:
        recycle_dir = args.recycle
        
        # 如果回收目录是相对路径，则相对于目标目录
        if not os.path.isabs(recycle_dir):
            recycle_dir = os.path.join(args.directory, recycle_dir)
        
        # 设置回收站目录
        if not setup_recycle_bin(recycle_dir):
            print(f"错误: 无法创建回收站目录 {recycle_dir}")
            sys.exit(1)
    
    # 处理归档目录
    archive_dir = None
    if args.archive:
        archive_dir = args.archive
        
        # 如果归档目录是相对路径，则相对于目标目录
        if not os.path.isabs(archive_dir):
            archive_dir = os.path.join(args.directory, archive_dir)
    
    print(f"视频库清理工具")
    print(f"目标目录: {args.directory}")
    
    if args.dry_run:
        print(f"运行模式: 预览 (不会实际删除或移动文件)")
    elif args.recycle:
        print(f"运行模式: 回收模式 (文件将被移动到: {recycle_dir})")
    else:
        print(f"运行模式: 直接删除模式")
    
    if args.archive:
        print(f"归档模式: 空目录将被移动到: {archive_dir}")
    
    try:
        process_directory(args.directory, args.dry_run, recycle_dir, archive_dir, args.ignore_dirs, args.max_dir_size, args.max_file_size)
        print("\n清理完成!")
    except KeyboardInterrupt:
        print("\n操作被用户中断")
    except Exception as e:
        print(f"\n发生错误: {e}")

if __name__ == "__main__":
    main()