# RenameSubtitles_RE
### 适用于重命名字幕使其与视频匹配的Windows批量处理脚本（Latest Update：v1.1.1）
### Copyright(c) 2019-2021 yyfll (dyystudio@qq.com)

更快，更准确的新一代视频字幕匹配批处理，NOW COMPLETE！

# 本脚本已停止更新，所提供的的功能将会集成至[ASFMKV Py](https://github.com/DYY-Studio/AddSubFontMKV_py)

## 为什么是RE？

其实在这个版本之前就有一个“RenameSubtitles”项目，是基于二十余个匹配模板的简单粗暴的程序

在添加某个模板之后，for无法同时分析那么多的项目，就爆了

于是为了代替原本十分不可靠的初代RS，就有了RS:RE

## 功能
<s>文件一对一匹配</s>

字幕重命名

> *由于设计上的原因，理论上完全支持任意两个不同扩展名的文件相互匹配*

## 使用方法
我在批处理里写了一堆提示，特别碍眼，看不懂就不关我事了

## 配置要求
处理器：能亮屏就无所谓，但是如果要跑Auto方式，那么有块桌面级4代i5可能更好

> *Auto的运行速度与CPU单核性能紧密相关，单核性能越强速度越快<br>
在AMD锐龙7 3800X上运行Auto，[30,2]时分析一次仅需要130ms±10ms<br>
而Intel酷睿i5-4590则需要300ms左右*

显卡：能亮屏就行，这个真无所谓

运行内存：能跑CMD就能跑这个

存储空间：50KB，软盘都能装得下吧

系统：至少Windows7吧，XP我没试过

网络：别逗了，怎么可能需要

## 自定义变量
为了符合不同用户的使用习惯，RenameSubtitles RE: 有着大量的自定义变量来适应各种不同的使用情况

### 修改方式
自定义变量位于该批处理的头部，用文本编辑器打开就能看到，每个变量都有详细的解释

*推荐使用有Batch语法高亮功能的文本编辑器，如VS Code、UltraEdit，不然改起来很痛苦*

在修改的时候只需要把行首为`set`的那一行，等号后面的值修改为目标值就行了

如赋任意值就写成`set "vid_subdir=A"`，设置为未定义就写成`set "vid_subdir="`

### 自定义变量列表
**全局设定**
| 变量名 | 作用 | 版本 | 预设 |
| --- | --- | --- | --- |
| subext | 可以匹配到的字幕扩展名 | 1.0.6 | (略) |
| vidext | 可以匹配到的视频扩展名 | 1.0.6 | (略) |
| ass_subdir | 搜索字幕时是否搜索子目录 | 1.0.6.1 | False |
| vid_subdir | 搜索视频时是否搜索子目录 | 1.0.6.1 | False |
| cache_dir | 设定缓存文件的临时存放路径 | 1.0.7fST | %~dp0 |
| check_same | 是否启用视频字幕匹配判断功能<sup>[1](#check_same)</sup> | 1.0.9 | True |
| check_same_ex | 是否使用命令扩展加速`check_same`<sup>[2](#check_same_ex)</sup> | 1.0.10α | True |
| new_match_method | 是否启用v1.1新匹配 | 1.1 | True |
| direct_sub_match | 是否启用v1.1暴力字幕匹配 | 1.1 | True |
| max_ep-range | v1.1匹配能够接受的最大集数长度 | 1.1 | 5 |
| echo_debug | 不执行所有cls指令并启用echo | 1.0.7 | False |

**<a name="check_same">1</a>**: 该功能能够判断字幕是否已经和视频匹配，若匹配则不再重命名，启用该功能会明显降低速度

**<a name="check_same_ex">2</a>**: 若使用命令扩展加速则会自动省略所有的半角感叹号`!`，但速度有明显提升（尽管还是很慢）

**AUTO设定**
| 变量名 | 作用 | 版本 | 预设 |
| --- | --- | --- | --- |
| show_howlong | 是否显示一次文件名比较所花费的时间 | 1.0.8 | True |
| compare_limit | 两文件名之间误差的最大值，超过则不再继续比较 | 1.0.7fS | 6 |
| compare_limit_method | 控制达到`compare_limit`之后如何输出误差量 | 1.0.10 | Minus |
| drop_minus | 丢弃误差量为负的结果（结合`compare_limit_method=""`使用）| 1.0.12 | True |
| deviation_a | 集数长度容差<sup>[3](#deviation)</sup> | 1.0.7fS | 2 |
| deviation_b | 集数位置容差<sup>[3](#deviation)</sup> | 1.0.7fS | 1 |
| count_range | 控制每个文件要与多少个文件进行比较<sup>[4](#count_range)</sup> | 1.0.2 | 15 |
| ls_step | 控制字符串长度计算函数的搜索步长`step`<sup>[5](#ls_step)</sup> | 1.0.3 | 5 |
| com_step | 控制文件名比较函数的搜索步长`step`<sup>[5](#ls_step)</sup> | 1.0.4 | 5 |
| same_long_v | *旧式算法* 控制是否对视频文件启用同长度文件名过滤<sup>[6](#same_long)</sup> | 1.0.6 | False |
| same_long_s | *旧式算法* 控制是否对字幕文件启用同长度文件名过滤<sup>[6](#same_long)</sup> | 1.0.6 | False |
| ext_use_most_v | *旧式算法* 控制是否对视频文件启用同扩展名过滤<sup>[7](#ext_use)</sup> | 1.0.6 | False |
| ext_use_most_s | *旧式算法* 控制是否对字幕文件启用同扩展名过滤<sup>[7](#ext_use)</sup> | 1.0.6 | False |

**<a name="deviation">3</a>**: 位置容差指的是在最终位置运算时能够取到的最大值或最小值为多少
	<br>其中集数长度将从该误差范围中选取最小值，而集数位置将会选取最大值
	<br>有该设定的原因是在本搜索方法下，一部有着12话的动画，在文件名中有着`第01话`这样的话数标记的情况下
	<br>由于`{02,03,04,...}`的第一个字符都是`0`，在比较前9话时得到的范围会是如`[27,1]`这样的
	<br>但实际上正确的范围是`[26,2]`，而这个范围只能由如`第10话`这样的集数得到<br>因而如果没有位置容差，将会选择到错误的范围导致无法匹配或只能匹配一部分

**<a name="count_range">4</a>**: 主要用于那些集数太多的作品，这些作品由于文件太多，比较会非常花时间
	<br>而`count_range`会舍弃超过其设定值的集数，只取其设定值的数量的文件名来比较，可以大大提高效率

**<a name="ls_step">5</a>**: 步长`step`默认设置为5，更长或是更短对提高效率作用似乎已不是太大，其原理是：
	<br>一次性取`%step%`个字符，然后查看它们是否有区别或是否确实有`%step%`个字符
	<br>若有区别或没有取到足够的字符，则用传统的`step=1`的搜索来反向搜索以确定精确的值
	<br>这样搜索速度也就大大提高了

**<a name="same_long">6</a>**: 同长度文件名过滤是1.0.6版本之前的旧算法的组成部分之一，其工作原理是：
	<br>计算所有输入的文件的文件名长度，取文件名长度相同最多的那个长度
	<br>如一组文件长度为`{4,4,4,4,5,4}`，那么将会只输入文件名长度为`4`的文件

**<a name="ext_use">7</a>**: 同扩展名过滤是1.0.6版本之前的旧算法的另一个组成部分，其工作原理与同长度文件名过滤类似。
	<br>它会先计算某个扩展名出现的次数，从中选取出现最多的扩展名，最终将会只输入这些出现最多的扩展名。

## AUTO模式算法介绍
自动模式的算法其实还不是很完整，主要是因为我没空完善

### 1.0.6新算法

1. 取所有属于extlist中允许输入的扩展名的文件

2. 从文件名左侧取一定长度与其它文件逐个比较，然后取其低于阈值的差别值

3. 对字幕文件重复1~2步

4. 得出匹配结果，交给标准模式

这种算法的优点在于不需要计算文件名长度和扩展名数量，可以更快地开始匹配

但相对于旧算法更容易出错

*1.0.6之后的版本可以在自定义变量中启用旧算法的各功能*

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
### 1.1.1 - 2021/09/21
	问题修复:
	1. 修复了1.1算法下，搜索视频时会将字幕列入匹配列表的问题
	2. 修复了1.1算法下，搜索视频时subdir变量失效的问题
	
	问题依旧没有修复:
	1. 注释不够时，自动添加的注释".subX"不会累加，导致X始终等于1

### 1.1_fix -2021/05/09
	问题修复:
	1. 修正了Auto下v1.1新算法无法正常计算出匹配规则的问题
	
	问题没有修复:
	1. 注释不够时自动添加的注释".subX"不会累加导致X始终等于1
### 1.1 - 2021/05/01
	新功能:
	1. v1.1全新算法，适用更广泛，匹配更全面，集数范围已成为过去式
	2. 与v1.1算法相匹配的新字符串比较算法，速度更快
### 1.0.12(q) - 2021/04/04
	新功能:
	1. 加入drop_minus自定义变量，让负值不再干扰计算
	2. 在输入多个注释时允许用户先行确认注释是否与字幕相匹配
	
	问题修复:
	1. 修复了字幕处理上的一些小问题
### 1.0.11q - 2021/02/12
	没有更改其他模块算法的1.0.11s，速度相对于1.0.11s应该快一些
### 1.0.11s - 2021/02/12
	新功能:
	1. list_appear_most模块更新至V2
	
	功能更改:
	1. 集数替换符变更为":"以保留"?"作为通配符的功能
	2. AUTO模式各模块的算法进行了稳定性优化，更慢了
		
	总体来说，该版本速度基本与上一版本持平
### 1.0.10 - 2020/08/08
	新功能:
	1. 目录路径输入检测（不再允许输入文件路径）
	2. 使用命令扩展加速的check_same
	3. compare_limit允许通过不计算字符串长度来加速
	4. 在不输入匹配规则时会要求再次输入
	5. 目录路径、匹配规则、通配路径选择器 在要求再次输入时会重置输入内容
	
	问题修复:
	1. 修复了启用check_same时无法找到字幕的问题

### 1.0.9 - 2020/05/16
	新功能:
	1. 输入有通配符的路径时会让用户选择正确路径
	2. 支持检测字幕文件名是否已经与视频相匹配，不需要再次重命名（对运行速度影响较大，默认关闭，需手动开启）
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
