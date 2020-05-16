# RenameSubtitles_RE
### 适用于字幕视频匹配的Windows批量处理脚本
### Copyright(c) 2019-2020 yyfll (dyystudio@qq.com)

更快，更准确的新一代视频字幕匹配批处理，NOW COMPLETE！

## 为什么是RE？

其实在这个版本之前就有一个“RenameSubtitles”项目，是基于二十余个匹配模板的简单粗暴的程序

在添加某个模板之后，for无法同时分析那么多的项目，就爆了

于是为了代替原本十分不可靠的初代RS，就有了RS:RE

## 功能
字幕重命名（其实不只是字幕，只要你把扩展名输进去，全都可以匹配）

## 使用方法
我在批处理里写了一堆提示，特别碍眼，看不懂就不关我事了

## 配置要求
处理器：能亮屏就无所谓，但是如果要跑Auto方式，那么有块桌面级4代i5可能更好

显卡：能亮屏就行，这个真无所谓

运行内存：能跑CMD就能跑这个

存储空间：50KB，软盘都能装得下吧

系统：至少Windows7吧，XP我没试过

网络：别逗了，怎么可能需要

## AUTO模式算法介绍
自动模式的算法其实还不是很完整，主要是因为我没空完善

### 1.0.6新算法

1. 取所有属于extlist中允许输入的扩展名的文件

2. 从文件名左侧取一定长度与其它文件逐个比较，然后取其低于阈值的差别值

3. 对字幕文件重复1~2步

4. 得出匹配结果，交给标准模式

### 1.0.6前算法
“比多-同长-差大”算法：

1. 先将计算所有输入文件名的长度

2. 取长度相同最多的（这是针对规则文件名的匹配方式，新算法想出来了没空写）

3. 从文件名左侧向右侧逐个与其他文件做比较，然后取其低于阈值的差别值（差别值就是出现不同的位置和不同的长度，为什么要执行多组是因为担心出错）

4. 对字幕文件重复1~3步

5. 得出匹配规则，交给标准模式

这种算法虽然慢，但是准确率还是非常不错的。

## 模块组
本批处理是我苟yy写那么多批处理来函数用的最多的，我列了个表

    add_char          向字符串添加指定长度的目标字符
    number_list       创建一个数组，或向该数组末尾添加一个新值
    list_largest      求出数组中最大值，同时返回最大值所在的变量名
    list_minimum      求出数组中最小值，同时返回最小值所在的变量名
    list_appear       返回数组中出现的所有值(数组)
    list_appear_most  通过list_appear返回的数组计算列表中出现次数最多的值并返回其所在变量名
    long_string       计算字符串长度
    compare_list      将数组拆解递交给compare_string
    compare_string    将一个字符串与一整个数组中所有字符串比较
    num_in_range      判断误差是否超过所给误差阈值
    check_num         拆分数组递交给num_in_range
    check_path_cmd    原本不应该是一个函数，但是本批处理中分成了一个函数

## 版本记录
### 1.0.9 - 2020/05/16
	新功能:
	1. 输入有通配符的路径时会让用户选择正确路径
	2. 支持检测字幕是否已经匹配视频（对运行速度影响较大，需手动开启）
	3. 现在会对匹配的视频和字幕的扩展名进行检测，防止过于简单的匹配规则导致的重复匹配
	
	问题修复:
	1. 修复了用时计算模块会异常显示[TIME]的问题

### 1.0.8F - 2020/04/??（未公开版本）
	问题修复:
	1. 修复了undo_rename输出不正确的问题
	2. 修复了多注释处理错误的问题
### 1.0.8 - 2020/03/23

	新功能:
	1. 支持由新版CMD提供的变量扩展Replace（会自动判断是否可用）
	2. 添加了匹配用时显示

	问题修复:
	1. 修复了ECHO_DEBUG不能正常启动的问题
	2. 修复了启用subdir时不能正常输入的问题
    3. 修正了字幕subdir不正常工作的问题
	4. 修复了字幕差异众数计算错误

### 1.0.7FST - Unknown（未公开版本）

    缓存文件路径可自定义

### 1.0.7FS - Unknown（未公开版本）

    新增2个控制AUTO搜索准确度及速度的变量
    添加了控制变量确认，有效阻止无效参数输入

### 1.0.7F - 2020/02/15

    全局漏洞修正：
    1. 修复每个视频只有一个字幕时注释添加错误
    2. 修复了字幕注释多一个点的问题
    
    AUTO漏洞修正：
    1. 修复差异众数计算错误
    2. 修复有半角感叹号的字幕/视频路径会保留完整路径
    3. 修复有半角感叹号的路径在计算匹配规则时会删除首尾各一字符
    
    其他内容：
    1. 变更了首尾引号去除方式

### 1.0.7 - 2020/02/11

    新的字幕匹配算法：
    1. 支持符合匹配规则的多字幕同时重命名    
    2. 支持为多个字幕分配不同的注释
    
    代码页变更：
    现已使用UTF-8 without BOM (65001)
    请注意，某些旧系统（如Win7）在chcp切换代码页时可能崩溃
    
    特殊DEBUG：
    在本批处理头部的@echo改为on时，会自动禁用所有的cls
    
### 1.0.6.1 - 2020/02/04（未公开版本）

    子目录搜索优化：
    子目录搜索控制编写完成（包括AUTO）
    可独立控制 视频 或 字幕 是否需要搜索子目录

### 1.0.6 - 2020/01/26

    可选新AUTO算法，包括：
    1. 不进行扩展名筛选，处理全部允许输入的扩展名
    2. 不进行文件名长度筛选，不再只输入同长度文件名
    （原本的旧算法依然可以在内部选项中切换）
    
    部分函数更新：
    compare_string  新版本中不再逐字符比较，而是从头截取指定长度比较
    
    格式支持更新:
    DVDSUB (idx+sub)
    现已支持同时重命名idx和sub两个相关的字幕文件（二文件必须文件名相同）

### 1.0.5c - 2020/01/04

    半角感叹号完全兼容（主程序完全不使用命令扩展）
    
### 1.0.5b - UNKNOWN

    半角感叹号部分兼容（除了AUTO部分外不使用命令扩展）
    
### 1.0.4 - UNKNOWN

    可自定Step的compare_string（速度大幅提升）
    第二种匹配模式（其实就是没补0再配一次）
    
### 1.0.3 - UNKNOWN

    可自定Step的long_string
    
### 1.0.2 - UNKNOWN

    重命名预览
    更快的long_string（Step 5）
    可添加阈值的自动匹配
    修正自动搜索结果错误
    
### 1.0.1 - UNKNOWN

    更快的long_string（Step 3）
    
### 1.0.0 - UNKNOWN

    修正多扩展名时搜索错误
    更快的number_list
    
### 1.0.0γ2 - UNKNOWN

    自动去引号
    
### 1.0.0γ - UNKNOWN

    自动搜索编写完毕
    
### 1.0.0β2 - UNKNOWN

    （没有留下任何版本记录）
    
### 1.0.0β - UNKNOWN

    删除无用模块
    
### 1.0.0α - UNKNOWN

    基础程序编写完毕
