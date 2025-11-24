#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DXP4800 NAS视频库清理工具
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

def move_to_recycle(source, recycle_dir, preserve_structure=True):
    """将文件或目录移动到回收站目录"""
    try:
        source_path = Path(source)
        if not source_path.exists():
            return False
            
        recycle_path = Path(recycle_dir)
        
        if preserve_structure:
            # 保持相对目录结构
            # 计算从根目录到源的相对路径
            # 这里简单使用源路径的父目录名作为子目录
            if source_path.is_file():
                # 对于文件，放入以其父目录名命名的子目录中
                sub_dir = recycle_path / source_path.parent.name
                sub_dir.mkdir(exist_ok=True)
                dest = sub_dir / source_path.name
            else:
                # 对于目录，直接在回收站中创建同名目录
                dest = recycle_path / source_path.name
        else:
            # 不保持结构，所有内容放在回收站根目录
            if source_path.is_file():
                dest = recycle_path / source_path.name
            else:
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

def process_root_nfo_files(root_dir, dry_run=False, recycle_dir=None):
    """处理根目录下的NFO文件"""
    print(f"\n检查根目录下的NFO文件: {root_dir}")
    
    root_path = Path(root_dir)
    nfo_files = list(root_path.glob('*.nfo'))
    
    if not nfo_files:
        print("  根目录下未找到NFO文件")
        return
    
    for nfo_file in nfo_files:
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

def process_directory(directory, dry_run=False, recycle_dir=None):
    """处理指定目录"""
    print(f"\n处理目录: {directory}")
    
    # 首先处理根目录下的NFO文件
    process_root_nfo_files(directory, dry_run, recycle_dir)
    
    # 查找所有子目录中的NFO文件
    nfo_files = list(Path(directory).glob('**/*.nfo'))
    
    # 过滤掉根目录的NFO文件和回收站目录中的NFO文件
    root_path = Path(directory).resolve()
    recycle_path = Path(recycle_dir).resolve() if recycle_dir else None
    
    nfo_files = [f for f in nfo_files 
                if f.parent != root_path 
                and (not recycle_path or not f.is_relative_to(recycle_path))]
    
    if not nfo_files:
        print("未找到子目录中的NFO文件")
        return
    
    directories_to_check = set()
    
    # 收集所有包含NFO文件的目录
    for nfo_file in nfo_files:
        parent_dir = nfo_file.parent
        directories_to_check.add(parent_dir)
    
    # 检查每个目录
    for dir_path in directories_to_check:
        print(f"\n检查目录: {dir_path}")
        
        # 跳过回收站目录
        if recycle_path and dir_path.is_relative_to(recycle_path):
            print(f"  跳过回收站目录: {dir_path}")
            continue
        
        # 查找该目录下的所有文件
        all_files = list(dir_path.glob('*'))
        video_files = [f for f in all_files if f.is_file() and is_video_file(f)]
        nfo_files_in_dir = [f for f in all_files if f.is_file() and f.suffix.lower() == '.nfo']
        
        # 如果有视频文件，跳过此目录
        if video_files:
            print(f"  发现视频文件，跳过此目录: {[f.name for f in video_files]}")
            continue
        
        # 如果没有视频文件但有NFO文件，进一步检查
        if nfo_files_in_dir:
            print(f"  发现NFO文件但没有视频文件: {[f.name for f in nfo_files_in_dir]}")
            
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
            
            # 如果所有对应的视频都不存在，且目录中没有其他视频文件，则删除目录
            if not all_videos_exist and not video_files:
                print(f"  确认删除目录: {dir_path}")
                
                if dry_run:
                    if recycle_dir:
                        print(f"    [DRY RUN] 将移动目录到回收站")
                    else:
                        print(f"    [DRY RUN] 将删除目录及其内容")
                else:
                    if recycle_dir:
                        # 移动到回收站
                        if move_to_recycle(dir_path, recycle_dir):
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

def main():
    parser = argparse.ArgumentParser(description='DXP4800 NAS视频库清理工具')
    parser.add_argument('directory', help='要清理的视频库目录路径')
    parser.add_argument('--dry-run', action='store_true', 
                       help='预览模式，只显示将要删除的目录而不实际删除')
    parser.add_argument('--recycle', type=str, metavar='RECYCLE_DIR',
                       help='回收模式：将删除的内容移动到指定目录而非永久删除')
    
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
    
    print(f"DXP4800 NAS视频库清理工具")
    print(f"目标目录: {args.directory}")
    
    if args.dry_run:
        print(f"运行模式: 预览 (不会实际删除文件)")
    elif args.recycle:
        print(f"运行模式: 回收模式 (文件将被移动到: {recycle_dir})")
    else:
        print(f"运行模式: 直接删除模式")
    
    try:
        process_directory(args.directory, args.dry_run, recycle_dir)
        print("\n清理完成!")
    except KeyboardInterrupt:
        print("\n操作被用户中断")
    except Exception as e:
        print(f"\n发生错误: {e}")

if __name__ == "__main__":
    main()