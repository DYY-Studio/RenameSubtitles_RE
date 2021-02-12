@echo off
chcp 65001 1>nul 2>nul
:DEBUG
if not defined debug (
	echo [M_DE] 正在启动DEBUG层
	set "debug=1"
	cmd /c call "%~0"
	set "debug="
	title %ComSpec%
	echo [M_DE] 运行结束
	pause
	goto :EOF
)

:rsr.GENERAL_SETTINGS
rem -------------------------------------------------------
rem GENERAL SEARCH SETTINGS 全局参数设置
rem -------------------------------------------------------
rem [ext_filters]
rem [subext]:字幕扩展名过滤
rem [vidext]:视频扩展名过滤
rem 控制AUTO模式扩展名过滤器可输入的扩展名
rem 注意：必须在整个变量的尾部也加上一个";"，否则无法读取最后一个扩展名

set "subext=ass;ssa;srt;idx;pgs;sup;smi;"
set "vidext=mp4;m4v;mkv;m2ts;avi;mpeg;mpg;wmv;"

rem -------------------------------------------------------
rem [subdir]
rem [vid]: 视频搜索控制
rem [ass]: 字幕搜索控制
rem 控制搜索时是否对子目录也进行搜索

set "ass_subdir=0"
set "vid_subdir=0"

rem 可用值
rem 	{未定义}:对子目录进行搜索
rem 	{任意值}:放弃对子目录的搜索
rem 注
rem 	{未定义}即直接 set "ass_subdir=" 不需要空格
rem -------------------------------------------------------
rem [cache_dir]
rem 缓存文件的临时存放路径

set "cache_dir=%~dp0"

rem 可用值
rem 	{未定义}: 默认为"%~dp0"
rem 	{可用路径}: 任何能够正常访问或能够被创建的文件夹
rem 推荐值
rem 	{%~dp0}: 即BATCH所在位置
rem 	{%TEMP%/%TMP%}: 系统缓存TEMP文件夹
rem -------------------------------------------------------
rem [check_same]
rem 是否要判断字幕已经与视频匹配
rem 该选项会明显降低匹配速度

set "check_same=1"

rem 可用值
rem 	{未定义}: 不启用
rem 	{任意值}: 启用
rem -------------------------------------------------------
rem [check_same_ex]
rem 启用使用命令扩展的check_same
rem 可能出现某些奇怪的错误，但速度非常快

set "check_same_ex=1"

rem 可用值
rem 	{未定义}: 不启用
rem 	{任意值}: 启用

:rsr.AUTOMODE_SETTINGS
rem -------------------------------------------------------
rem AUTO SEARCH MODE SETTINGS 自动模式参数设置
rem -------------------------------------------------------
rem [show_howlong]
rem 显示一次compare到底花费了多长时间，启用该功能可能会慢几毫秒

set "show_howlong=0"

rem 可用值
rem 	{未定义}:不显示
rem 	{任意值}:显示
rem -------------------------------------------------------
rem [compare_limit]
rem 控制compare_string误差量的最大值，超过该值则放弃继续搜索

set "compare_limit=6"

rem 可用值
rem 	{1~n(正整数)}
rem 	{空缺}（不放弃搜索）
rem 推荐值
rem 	{误差量+2}（可以防止出错）
rem -------------------------------------------------------
rem [compare_limit_method]
rem 控制达到compare_string误差量的最大值后的长度运算方式

set "compare_limit_method="

rem 可用值
rem 	{任意值}: 计算字符串的全长，与误差位置相减来得到误差量
rem 	{空缺}: 直接赋值"-2*%deviation_a%"（速度比较快）
rem -------------------------------------------------------
rem [number_deviation]
rem 控制最终规则决策时允许误差值
rem 集数长度将从该误差范围中选取最小值，集数位置将会选取最大值
rem [deviation_a] 集数长度容差

set "deviation_a=2"

rem [deviation_b] 集数位置容差

set "deviation_b=1"

rem 可用值
rem 	{a=1~n,b=1~n(正整数)}
rem 	{留空}（使用默认值，a=2 b=1）
rem 推荐值
rem 	{a=2,b=1}（对于集数不超过100的）
rem 	{a=集数长度,b=集数长度-1}
rem -------------------------------------------------------
rem [count_range]
rem 控制compare_list进行比较的项数，可以加快AUTO，但错误率增大

set "count_range=15"

rem 可用值 
rem 	{1~n(正整数)}（从0开始计数，即=15时会比较16项）
rem 	{留空}（不启用，即全项目检索）
rem 推荐值
rem 	{10~20}（不建议少于10）
rem 	{≥100}（对于集数超过100的）
rem -------------------------------------------------------
rem [ls_step]
rem 控制long_string每一循环计数的字符量，值越大对长字符串的计数就越快，但对短字符串就越慢

set "ls_step=5"

rem 可用值
rem 	{1~n(正整数)}
rem 推荐值
rem 	{5~10}
rem -------------------------------------------------------
rem [com_step]
rem 控制compare_string每一循环计数的字符量，值越大对长字符串的计数就越快，但对短字符串就越慢

set "com_step=5"

rem 可用值
rem 	{1~n(正整数)}
rem 推荐值
rem 	{5~10}
rem -------------------------------------------------------
rem [use_same_long_filename]
rem [same_long_v]:用于视频搜索
rem [same_long_s]:用于字幕搜索
rem 
rem 该选项控制是否启用旧的 同长度文件名筛选 算法
rem 在该旧算法下，只有同样长度的文件会进行对比
rem 适用于规范的、格式化的、有一定规律的文件名

set "same_long_v="
set "same_long_s="

rem 可用值
rem 	{未定义}:不使用该算法
rem 	{任意值}:使用旧算法
rem 注
rem 	{未定义}即直接 set "same_long_v=" 不需要空格
rem -------------------------------------------------------
rem [enable_ext_use_most]
rem [ext_use_most_v]:用于视频搜索
rem [ext_use_most_s]:用于字幕搜索
rem 该选项控制是否启用旧的 扩展名筛选 算法
rem 在该算法下，只有文件夹下文件数量最多的扩展名才会被使用
rem 适用于普遍使用同一扩展名的文件

set "ext_use_most_v="
set "ext_use_most_s="

rem 可用值
rem 	{未定义}:不使用该算法
rem 	{任意值}:使用旧算法
rem 注
rem 	{未定义}即直接 set "ext_use_most_v=" 不需要空格
rem -------------------------------------------------------

:rsr.MAIN_LOAD
if not "%cache_dir:~-1%"=="\" set "cache_dir=%cache_dir%\"
echo a>"%cache_dir%test.txt" 2>nul
if %errorlevel%0 GEQ 10 (
	set "cache_dir=%~dp0"
) else (
	del /q "%cache_dir%test.txt"
	goto :get_cache_dir
)

echo a>"%cache_dir%test.txt"
if %errorlevel%0 GEQ 10 (
	if exist "%Temp%" (
		if not exist "%Temp%\RENAMESUBTITLES_FSM_CACHE" md "%Temp%\RENAMESUBTITLES_FSM_CACHE"
		if exist "%Temp%\RENAMESUBTITLES_FSM_CACHE" (
			set "cache_dir=%Temp%\RENAMESUBTITLES_FSM_CACHE"
		) else (
			echo [ERROR] Can't make "%Temp%\RENAMESUBTITLES_FSM_CACHE" DIR
			pause
			goto :EOF
		)
	) else (
		echo [ERROR] "%Temp%" DIR not found
		pause
		goto :EOF
	)
) else del /q "%cache_dir%test.txt"

:get_cache_dir
if exist "%cache_dir%" if not "%cache_dir%"=="%~dp0" if not "%cache_dir%"=="%Temp%\" set "remove_cache_dir=0"

set "prefile=%cache_dir%rename_preview.log"
set "logfile=%cache_dir%rename_log.log"
set "vpfile=%cache_dir%vp_cache.log"
set "undofile=%cache_dir%undo_rename.log"
set "vffile=%cache_dir%vf_rename.log"
set "sffile=%cache_dir%sf_rename.log"
set "vsnfile=%cache_dir%vsn_rename.log"
set "sgetfile=%cache_dir%Sget_rename.log"

if exist "%undofile%" del /q "%undofile%"
if exist "%prefile%" del /q "%prefile%"
if exist "%logfile%" del /q "%logfile%"
if exist "%vpfile%" del /q "%vpfile%"
if exist "%vffile%" del /q "%vffile%"
if exist "%sffile%" del /q "%sffile%"
if exist "%vsnfile%" del /q "%vsnfile%"
if exist "%sgetfile%" del /q "%sgetfile%"

echo.
echo [PCHK] 正在检查控制变量

if not defined deviation_a (
	set "deviation_a=2"
	echo [ASET] deviation_a=2
) else if %deviation_a%0 LSS 10 (
	set "deviation_a=2"
	echo [ASET] deviation_a=2
) else echo [PCHK] deviation_a=%deviation_a%

if not defined deviation_b (
	set "deviation_b=1"
	echo [ASET] deviation_b=1
) else if %deviation_b%0 LSS 10 (
	set "deviation_b=1"
	echo [ASET] deviation_b=1
) else echo [PCHK] deviation_b=%deviation_b%

if not defined com_step (
	set "com_step=5"
	echo [ASET] com_step=5
) else if 0%com_step% LSS 1 (
	set "com_step=5"
	echo [ASET] com_step=5
) else echo [PCHK] com_step=%com_step%

if not defined ls_step (
	set "ls_step=5"
	echo [ASET] ls_step=5
) else if %ls_step%0 LSS 10 (
	set "ls_step=5"
	echo [ASET] ls_step=5
) else echo [PCHK] ls_step=%ls_step%

if defined count_range (
	if %count_range%0 LSS 10 (
		set "count_range=15"
		echo [ASET] count_range=15
	) else echo [PCHK] count_range=%count_range%
)

if defined compare_limit (
	if not %compare_limit%0 GTR %deviation_a%0 (
		set /a compare_limit=deviation_a+2
		echo [ASET] compare_limit=%deviation_a%+2
	) else echo [PCHK] compare_limit=%compare_limit%
)

set "test=aba"
if "%test:b=a%"=="aaa" (
	set "use_new_echo=0"
) else set "use_new_echo="
set "test="

cls

set "echo_debug="
for /f "tokens=*" %%a in ('cmd /q /c echo') do (
	set "echo_mode=%%~a"
)
for /f "tokens=*" %%a in ('echo') do (
	if not "%echo_mode%"=="%%~a" (
		set "echo_debug=0"
		echo [ECHO] ECHO_DEBUG ON
	)
)
set "echo_mode="

set "bat_ver=RenameSubtitles RE: Ver1.0.11q UTF-8"
title %bat_ver% [(c) yyfll]
echo [INFO] %bat_ver%
echo [INFO] Copyright(c) 2019-2021 yyfll
echo [CDIR] "%cache_dir%"

:MAIN
echo.
set "v_path="
echo [ 视频目录 ]
set /p v_path=[V_IN] V_PATH: 
rem goto v_check_end
echo [CHKV] 正在检查视频目录CMD兼容性及可用性

cmd /c if "%v_path:~1,-1%"=="%v_path:~1,-1%" echo. 1>nul 2>NUL
if "%errorlevel%"=="0" if exist "%v_path:~1,-1%" (
	set "v_path=%v_path:~1,-1%"
	goto vpath_chk_over
)

cmd /c if "%v_path%"=="%v_path%" echo. 1>nul 2>NUL
if "%errorlevel%"=="0" if exist "%v_path%" (
	set "v_path=%v_path%"
	goto vpath_chk_over
)

cmd /c if "%v_path:~1%"=="%v_path:~1%" echo. 1>nul 2>NUL
if "%errorlevel%"=="0" if exist "%v_path:~1%" (
	set "v_path=%v_path:~1%"
	goto vpath_chk_over
)

cmd /c if "%v_path:~0,-1%"=="%v_path:~0,-1%" echo. 1>nul 2>NUL
if "%errorlevel%"=="0" if exist "%v_path:0,-1%" (
	set "v_path=%v_path:~0,-1%"
	goto vpath_chk_over
)

echo [ERRV] 不受支持的非法路径
echo [INFO] 可能是您的路径中含有非法字符
goto MAIN

:vpath_chk_over

for /f "tokens=*" %%a in ("%v_path%") do (
	set "v_path_a=%%~aa"
)
if not "%v_path_a:~0,1%"=="d" (
	echo [ERRV] 您输入的路径不是目录路径
	goto MAIN
)

for /f "tokens=1,2 delims=*" %%a in ("%v_path%") do (
	if not "%v_path:~-1%"=="*" (
		if "%%~b"=="" goto vpc.vpath_choose_end
	)
)

set "list_count=0"
for /d %%a in ("%v_path%") do if exist "%%~a" call :vpc.write_vpath_list "%%~a"
goto vpc.show_vpath_list

:vpc.write_vpath_list
if %list_count% LSS 10 (
	set "v_path0%list_count%=%~1"
) else set "v_path%list_count%=%~1"
set /a list_count=list_count+1
goto :EOF

:vpc.show_vpath_list
if %list_count%==1 (
	set "v_path=%v_path00%"
	echo [FRFC] 自动套用唯一匹配文件夹"%v_path00%"
	goto vpc.vpath_choose_end
) else if %list_count%==0 (
	echo [ERROR] 没有找到匹配"%v_path%"的目录
	goto Main
)

cls
echo [Module] FRF通配路径选择器 视频路径
echo.
set "v_path="
for /f "tokens=1* delims==" %%a in ('set v_path') do (
	call :vpc.show_list_2 "%%~a" "%%~b"
)
echo.
:vpc.path_choose
set "v_path_count="
echo 请选择您要输入的目录(填路径前括号内的数字，零开头的可省略零)
set /p v_path_count=:
if "%v_path_count%" GTR "%list_count%" (
	echo [ERROR] "%sub_path_count%"^|MAX:"%list_count%-1"
	echo [ERROR] 输入不正确!
	goto spc.path_choose
)
for /f "tokens=1,2 delims= " %%a in ("%v_path_count%") do (
	if not "%%~b"=="" (
		echo [ERROR] 输入不能带有空格!
		echo [ERROR] 输入不正确!
		goto spc.path_choose
	)
)
if defined v_path0%v_path_count% (
	for /f "tokens=1* delims==" %%a in ('set v_path0%v_path_count%') do (
		set "dircache=%%~b"
	)
	for /f "tokens=1* delims==" %%a in ('set v_path') do set "%%~a="
) else if defined v_path%v_path_count% (
	for /f "tokens=1* delims==" %%a in ('set v_path%v_path_count%') do (
		set "dircache=%%~b"
	)
	for /f "tokens=1* delims==" %%a in ('set v_path') do set "%%~a="
) else (
	echo [ERROR] 找不到"v_path%v_path_count%"
	goto vpc.path_choose
)
set "v_path=%dircache%"
set "dircache="
set "listitem="
set "listitem2="
cls
echo [VPCS] 您选择了目录"%v_path%"!
goto vpc.vpath_choose_end

:vpc.show_list_2
set "listitem=%~1"
set "listitem2=%~2"
echo [%listitem:~6%] "%listitem2%"
goto :EOF

:vpc.vpath_choose_end

if not exist "%v_path%" (
	echo [V_EX] 找不到视频路径
	goto MAIN
)
echo [CHKV] 视频目录确认成功

if not "%v_path:~-1%"=="\" (
	set "v_path=%v_path%\"
) else set "v_path=%v_path%"

:MAIN_S
echo.
set "sub_path="
echo [ 字幕目录（留空默认同视频目录） ]
set /p sub_path=[S_IN] S_PATH: 
if not defined sub_path (
	echo [VOID] 自动套用视频目录
	set "sub_path=%v_path%"
	goto s_check_end
)

echo [CHEK] 正在检查字幕目录CMD兼容性及可用性
echo.

cmd /c if "%sub_path:~1,-1%"=="%sub_path:~1,-1%" echo. 1>nul 2>NUL
if "%errorlevel%"=="0" if exist "%sub_path:~1,-1%" (
	set "sub_path=%sub_path:~1,-1%"
	goto spath_chk_over
)

cmd /c if "%sub_path%"=="%sub_path%" echo. 1>nul 2>NUL
if "%errorlevel%"=="0" if exist "%sub_path%" (
	set "sub_path=%sub_path%"
	goto spath_chk_over
)

cmd /c if "%sub_path:~1%"=="%sub_path:~1%" echo. 1>nul 2>NUL
if "%errorlevel%"=="0" if exist "%sub_path:~1%" (
	set "sub_path=%sub_path:~1%"
	goto spath_chk_over
)

cmd /c if "%sub_path:~0,-1%"=="%sub_path:~0,-1%" echo. 1>nul 2>NUL
if "%errorlevel%"=="0" if exist "%sub_path:~0,-1%" (
	set "sub_path=%sub_path:~0,-1%"
	goto spath_chk_over
)

echo [ERRV] 不受支持的非法路径
echo [INFO] 可能是您的路径中含有非法字符
goto MAIN_S

:spath_chk_over

for /f "tokens=*" %%a in ("%sub_path%") do (
	set "sub_path_a=%%~aa"
)
if not "%sub_path_a:~0,1%"=="d" (
	echo [ERRS] 您输入的路径不是目录路径
	goto MAIN_S
)

for /f "tokens=1,2 delims=*" %%a in ("%sub_path%") do (
	if not "%sub_path:~-1%"=="*" (
		if "%%~b"=="" goto spc.vpath_choose_end
	)
)

set "list_count=0"
for /d %%a in ("%sub_path%") do if exist "%%~a" call :spc.write_vpath_list "%%~a"
goto spc.show_vpath_list

:spc.write_vpath_list
if %list_count% LSS 10 (
	set "sub_path0%list_count%=%~1"
) else set "sub_path%list_count%=%~1"
set /a list_count=list_count+1
goto :EOF

:spc.show_vpath_list
if %list_count%==1 (
	set "sub_path=%sub_path00%"
	echo [FRFC] 自动套用唯一匹配文件夹"%sub_path00%"
	goto spc.vpath_choose_end
) else if %list_count%==0 (
	echo [ERROR] 没有找到匹配"%sub_path%"的目录
	goto Main
)

cls
echo [Module] FRF通配路径选择器 字幕路径
echo.
set "sub_path="
for /f "tokens=1* delims==" %%a in ('set sub_path') do (
	call :spc.show_list_2 "%%~a" "%%~b"
)
echo.
:spc.path_choose
set "sub_path_count="
echo 请选择您要输入的目录(填路径前括号内的数字，零开头的可省略零)
set /p sub_path_count=:
if "%sub_path_count%" GTR "%list_count%" (
	echo [ERROR] "%sub_path_count%"^|MAX:"%list_count%-1"
	echo [ERROR] 输入不正确!
	goto spc.path_choose
)
for /f "tokens=1,2 delims= " %%a in ("%sub_path_count%") do (
	if not "%%~b"=="" (
		echo [ERROR] 输入不能带有空格!
		echo [ERROR] 输入不正确!
		goto spc.path_choose
	)
)
if defined sub_path0%sub_path_count% (
	for /f "tokens=1* delims==" %%a in ('set sub_path0%sub_path_count%') do (
		set "dircache=%%~b"
	)
	for /f "tokens=1* delims==" %%a in ('set sub_path') do set "%%~a="
) else if defined sub_path%sub_path_count% (
	for /f "tokens=1* delims==" %%a in ('set sub_path%sub_path_count%') do (
		set "dircache=%%~b"
	)
	for /f "tokens=1* delims==" %%a in ('set sub_path') do set "%%~a="
) else (
	echo [ERROR] 找不到"sub_path%sub_path_count%"
	goto spc.path_choose
)
set "sub_path=%dircache%"
set "dircache="
set "listitem="
set "listitem2="
cls
echo [VINP] 视频目录: "%v_path%"
echo [SPCS] 您选择了目录"%sub_path%"!
goto spc.vpath_choose_end

:spc.show_list_2
set "listitem=%~1"
set "listitem2=%~2"
echo [%listitem:~8%] "%listitem2%"
goto :EOF

:spc.vpath_choose_end

if defined path_inv (
	set "path_inv="
	goto MAIN_S
)
if not exist "%sub_path%" (
	echo [S_EX] 找不到字幕路径
	goto MAIN_S
)

echo [CHKS] 字幕目录确认成功

if not "%sub_path:~0,-1%"=="\" set "sub_path=%sub_path%\"

:s_check_end
echo.
echo [ 自动生成匹配规则 即通过分析文件名寻找匹配规则 ]
echo [ 由于批量处理程序比较简单 分析出错率比较大     ]
echo [ 而且自动 非常慢！ 非常慢！ 非常慢！ 非常慢！  ]
echo [ 不是很懒的人非常非常非常建议手动输入匹配规则  ]
echo [ 预计时长 约6分钟完成13话分析 于 酷睿2DuoP8400 ]
echo [ 自动匹配 （[y]尝试/[n]不尝试） ]
set /p auto=[AUTO] Auto[y/n]?: 
if /i "%auto%"=="y" (
	goto AUTO_POINT
) else if /i "%auto%"=="n" (
	set "auto="
) else (
	set "auto="
)
echo.
echo [ 匹配规则即如何匹配视频 请用半角冒号代替集数   ]
echo [ 例如[CASO][El_Cazador][GB_BIG5][01][DVDRIP]   ]
echo [ 替换成[CASO][El_Cazador][GB_BIG5][::][DVDRIP] ]
echo [ 如果视频有非常麻烦的如校验值在文件名结尾      ]
echo [ 请使用通配符 如[CASO][*][GB_BIG5][::][*       ]
:v_filter.get
set "filter="
echo [ 视频匹配规则 ]
set /p filter=[V_FI] V_FILTER: 
echo.
if not defined filter (
	echo [ERRF] 您没有输入匹配规则
	goto v_filter.get
)
:s_filter.get
echo [ 字幕匹配规则 ]
set /p s_filter=[S_FI] S_FILTER: 
echo.
if not defined s_filter (
	echo [ERRF] 您没有输入匹配规则
	goto s_filter.get
)
:AUTO_POINT
if defined auto (
	cls
	echo 在自动搜索之前，我们需要您填写一些必要信息
	echo.
)
echo [ 剧集范围即是从多少集到多少集 请以 1,24 表示   ]
echo [ 如我的片有52话 从第01话开始 那么我就写1,52    ]
echo [ 注意必须要用半角逗号 , 否则不被识别           ]
:re_get_ep
echo [ 剧集范围 ]
set /p ep=[EP_R] EP_Range: 
for /f "tokens=1,2 delims=," %%a in ("%ep%") do (
	if "%%~a"=="" (
		echo [ERRE] 剧集输入有误
		goto re_get_ep
	)
	if "%%~b"=="" (
		echo [ERRE] 剧集输入有误
		goto re_get_ep
	)
)
echo.
echo [ 字幕注释信息即文件名后跟的如 .CASO-sc 这样的  ]
echo [ 这种用于表示字幕组与字幕语言的文本 就是注释   ]
echo [ 如[YYDM-11FANS][Rozen Maiden][01].CASO-sc.ass ]
echo [ 多字幕注释：使用":"（半角冒号）隔开每个注释   ]
echo [ 本批处理按照名称排序进行搜索，具体先后顺序    ]
echo [ 与资源管理器中文件夹在最上方的名称排序相同    ]
echo [ 字幕注释（可以留空） ]
set /p s_rem=[SANN] S_Annotate: 

if not defined echo_debug cls

setlocal EnableDelayedExpansion
:pre.toList
echo [LIST] 正在转换扩展名表
set "ass_loop=0"
set "ass_count=0"
set "ass_start=0"
:pre.get_sub_extlist
set "a_char=!subext:~%ass_loop%,1!"
if "%a_char%"=="" goto pre.get_sub_extlist_end
if not "%a_char%"==";" (
	set /a ass_loop=ass_loop+1
	goto pre.get_sub_extlist
)
for /f "tokens=*" %%a in ('set /a ass_loop-ass_start') do (
	set "subext[%ass_count%]=.!subext:~%ass_start%,%%~a!"
)
set /a ass_count=ass_count+1
set /a ass_loop=ass_loop+1
set "ass_start=%ass_loop%"
goto pre.get_sub_extlist

:pre.get_sub_extlist_end

set "ass_loop=0"
set "ass_count=0"
set "ass_start=0"
:pre.get_vid_extlist
set "a_char=!vidext:~%ass_loop%,1!"
if "%a_char%"=="" goto pre.get_vid_extlist_end
if not "%a_char%"==";" (
	set /a ass_loop=ass_loop+1
	goto pre.get_vid_extlist
)
for /f "tokens=*" %%a in ('set /a ass_loop-ass_start') do (
	set "vidext[%ass_count%]=.!vidext:~%ass_start%,%%~a!"
)
set /a ass_count=ass_count+1
set /a ass_loop=ass_loop+1
set "ass_start=%ass_loop%"
goto pre.get_vid_extlist

:pre.get_vid_extlist_end
setlocal DisableDelayedExpansion
echo [LIST] Complete making EXT lists.

if not defined s_rem (
	if defined auto (
		goto START_AUTO
	) else goto AUTO_BACK
)

for /f "tokens=1,2 delims=?" %%a in ("%s_rem%") do if "%%~b"=="" (
	if not "%s_rem:~0,1%"=="." set "s_rem=.%s_rem%"
	if defined auto (
		goto START_AUTO
	) else goto AUTO_BACK
)

echo [SREM] 正在切分多字幕注释，请稍等...
set "work_s_rem=%s_rem%"
set "count_s_rem=0"
set "s_rem[0]="
:more_rem_cut
if not defined work_s_rem (
	if not "%cache_s_rem:~0,1%"=="." (
		set "s_rem[%count_s_rem%]=.%cache_s_rem%"
	) else set "s_rem[%count_s_rem%]=%cache_s_rem%"
	if defined auto (
		goto START_AUTO
	) else goto AUTO_BACK
)
if not "%work_s_rem:~0,1%"==":" (
	set "cache_s_rem=%cache_s_rem%%work_s_rem:~0,1%"
) else (
	if not "%cache_s_rem:~0,1%"=="." (
		set "s_rem[%count_s_rem%]=.%cache_s_rem%"
	) else set "s_rem[%count_s_rem%]=%cache_s_rem%"
	set /a count_s_rem=count_s_rem+1
	set "cache_s_rem="
)
set "work_s_rem=%work_s_rem:~1%"
goto more_rem_cut

:START_AUTO
goto auto

:AUTO_BACK
if defined s_rem[0] if not defined s_rem[1] (
	set "s_rem=%s_rem[0]%"
	set "s_rem[0]="
	set "count_s_rem="
) else (
	set "s_rem="
)

if not defined echo_debug cls
echo [WORK] 正在匹配规则中寻找剧集位置...
:GET_COUNT

set "get_loop=0"
set "instr[0]="
set "instr[1]="
set "get_count=0"
set "stop_count=0"

echo [V_FI] 视频匹配规则"%filter%"
set "working_filter=0%filter%"
:FIND_COUNT
set "working_filter=%working_filter:~1%"
if not defined working_filter goto END_FIND_COUNT
set "a_char=%working_filter:~0,1%"
if "%a_char%"==":" (
	set /a get_count=get_count+1
	if not defined instr[0] (
		set "instr[0]=%get_loop%"
	) else set /a stop_count=stop_count+1
)
if %stop_count% GTR 0 goto END_FIND_COUNT
if not "%a_char%"=="" (
	set /a get_loop=get_loop+1
	goto FIND_COUNT
) else goto END_FIND_COUNT
goto FIND_COUNT

:END_FIND_COUNT

set "instr[1]=%get_count%"
echo [VINS] 在视频匹配规则中找到位置%instr[0]%，长度%instr[1]%

if not defined s_filter goto END_FIND_SUB_COUNT
set "get_loop=0"
set "s_instr[0]="
set "s_instr[1]="
set "get_count=0"
set "stop_count=0"

echo [S_FI] 字幕匹配规则"%s_filter%"
set "working_filter=0%s_filter%"
:FIND_SUB_COUNT
set "working_filter=%working_filter:~1%"
if not defined working_filter goto END_FIND_SUB_COUNT
set "a_char=%working_filter:~0,1%"
if "%a_char%"==":" (
	set /a get_count=get_count+1
	if not defined s_instr[0] (
		set "s_instr[0]=%get_loop%"
	) else set /a stop_count=stop_count+1
)
if %stop_count% GTR 0 goto END_FIND_SUB_COUNT
if not "%a_char%"=="" (
	set /a get_loop=get_loop+1
	goto FIND_SUB_COUNT
) else goto END_FIND_SUB_COUNT
goto FIND_SUB_COUNT

:END_FIND_SUB_COUNT
set "working_filter="

set "s_instr[1]=%get_count%"
echo [SINS] 在字幕匹配规则中找到位置%s_instr[0]%，长度%s_instr[1]%
echo.

:LOOP_NUM
title %bat_ver% ^| 视频字幕匹配中...
for /f "tokens=1,2 delims=," %%a in ("%ep%") do (
	for /l %%c in (%%~a,1,%%~b) do (
		echo [LOOP] 尝试匹配剧集%%~c
		call :SEARCH_VIDEO "%%~c"
		if not defined not_work (
			call :SEARCH_ASS "%sub_path%" "%s_filter%" "%%~c"
		) else set "not_work="
	)
)

if not exist "%prefile%" (
	echo [ERR_] 找不到匹配的重命名项
	goto end_batch
)
if not exist "%logfile%" (
	echo [ERR_] 找不到匹配的重命名项
	goto end_batch
)

:preview_check
if not defined echo_debug cls
title %bat_ver% ^| 重命名预览
echo [PREV] 重命名预览
echo.
type "%prefile%"
echo [PREV] 预览显示完毕
choice /M "[CHK_] 要执行这样的重命名吗？"
if %errorlevel%==0 goto preview_check
if %errorlevel%==1 (
	echo.
	for /f "usebackq tokens=1,2 delims=^|" %%a in ("%logfile%") do (
		call :rename_sub "%%~a" "%%~b"
	)
	if exist "%prefile%" if not "%sub_path:~-1%"=="\" (
		move /y "%prefile%" "%sub_path%\rename_log.log"
		if exist "%undofile%" move /y "%undofile%" "%sub_path%\undo_rename.log"
	) else (
		move /y "%prefile%" "%sub_path%rename_log.log"
		if exist "%undofile%" move /y "%undofile%" "%sub_path%undo_rename.log"
	)
)

:end_batch

if exist "%undofile%" del /q "%undofile%"
if exist "%logfile%" del /q "%logfile%"
if exist "%prefile%" del /q "%prefile%"
if exist "%vpfile%" del /q "%vpfile%"
if exist "%vffile%" del /q "%vffile%"
if exist "%sffile%" del /q "%sffile%"
setlocal DisableDelayedExpansion
goto :EOF

:SEARCH_VIDEO
set "vid_num=%~1"
set "zero_loop=0"
setlocal EnableDelayedExpansion
if "%instr[1]%"=="1" goto :end_add_zero
:add_zero
set "vid_num_r=%vid_num%"
set "vid_num=00000000000000000000000%vid_num%"
set "vid_num=!vid_num:~-%instr[1]%!"
:end_add_zero
set "not_work="
set "video="

set "vid_path[0]=!filter:~0,%instr[0]%!"
for /f "tokens=*" %%a in ('set /a instr[0]+instr[1]') do (
	set "vid_path[1]=!filter:~%%~a!"
)

setlocal DisableDelayedExpansion

set "vid_path=%vid_path[0]%%vid_num%%vid_path[1]%"
if exist "%v_path%%vid_path%" (
	call :check_video "%v_path%%vid_path%"
	if defined video goto got_video
)
if not "%instr[1]%"=="1" set "vid_path_1=%vid_path[0]%%vid_num_r%%vid_path[1]%"

for /r "%v_path%" %%a in ("%vid_path%") do (
	call :check_video "%%~a"
	if defined video goto got_video
)
if defined vid_path_1 for /r "%v_path%" %%a in ("%vid_path_1%") do (
	call :check_video "%%~a"
	if defined video goto got_video
)
echo [ERR_] 未能匹配到视频
set "not_work=0"
goto got_video
:check_video
set "video="
set "ext_OK="
if not exist "%~1" (
	echo [ERRV] 找不到匹配的视频文件
	goto :EOF
)

if defined vid_subdir (
	if not "%v_path%"=="%~dp1" (
		echo [VDIR] 文件处于子目录
		goto :EOF
	)
)

for /f "tokens=1* delims==" %%a in ('set vidext[') do (
	if "%~x1"=="%%~b" set "ext_OK=1"
)
if not defined ext_OK (
	echo [SKIP] 扩展名不匹配 ["%~x1"]
	goto :EOF
)

set "video=%~1"
echo [VGET] 匹配到视频"%~nx1"
goto :EOF
:got_video
if defined video echo "%video%">"%vpfile%"
goto :EOF

rem call :SEARCH_ASS "[sub_path]" "[filter]" "[ep_num]"
:SEARCH_ASS
rem @echo on
set "ass_path=%~1"
if not "%~2"=="" ( 
	rem for /f "tokens=* delims=^|" %%a in ("%s_filter%") do (
	rem	call :CHECK_EXT "%%~xa" "n"
	rem )
	set "s_filter=%~2" 
) else set "s_filter=*.ass"

if not exist "%~1" (
	echo [ERROR] Subtitles Path No Found
	pause
	goto :EOF
)
set "sub_num=%~3"
set "zero_loop=0"
set "get_sub=0"

:time_format
for /f "tokens=*" %%a in ('time /T') do (
	for /f "delims=: tokens=1,2*" %%b in ("%%a:%time:~6,2%%time:~9,2%") do (
		set "work_time=%%b%%c%%d"
	)
)
set "same_sub_tmp=%TEMP%\RENAMESUBTITLES_CACHE%work_time%.log"

setlocal EnableDelayedExpansion
if "%s_instr[1]%"=="1" goto end_s_add_zero
:s_add_zero
set "sub_num_r=%sub_num%"
set "sub_num=00000000000000000000000%sub_num%"
set "sub_num=!sub_num:~-%s_instr[1]%!"
:end_s_add_zero
set "s_path[0]=!s_filter:~0,%s_instr[0]%!"
for /f "tokens=*" %%a in ('set /a s_instr[0]+s_instr[1]') do (
	set "s_path[1]=!s_filter:~%%~a!"
)

setlocal DisableDelayedExpansion

set "s_path=%s_path[0]%%sub_num%%s_path[1]%"

set "subget_finish="
set "get_sub=0"
if not "%s_instr[1]%"=="1" set "s_path_1=%s_path[0]%%sub_num_r%%s_path[1]%"

:subtitles_again

if exist "%same_sub_tmp%" del /q "%same_sub_tmp%"

REM for /r "%ass_path%" %%a in ("%s_path%") do (
	REM call :check_subtitles "%%~a"
REM )

for /f "tokens=* delims=^|" %%a in ('dir /S /A:-D-O /B "%ass_path%%s_path%"') do (
	call :check_subtitles "%%~a"
)

call :check_subget
if defined subget_finish (
	set "subget_finish="
	goto got_sub
)

set "get_sub=0"
if exist "%same_sub_tmp%" del /q "%same_sub_tmp%"

if defined s_path_1 if not "%s_path%"=="%s_path_1%" (
	set "s_path=%s_path_1%"
	set "s_path_1="
	goto subtitles_again
)

echo [ERR_] 未能匹配到字幕
goto got_sub
:check_subtitles
set "ext_OK="
if exist "%vsnfile%" del /q "%vsnfile%"

if not exist "%~1" (
	echo [ERRS] 找不到匹配的字幕文件
	set "subdir_nochk=0"
	goto check_subtitles_end
)

for /f "tokens=1* delims==" %%a in ('set subext[') do (
	if "%~x1"=="%%~b" set "ext_OK=1"
)
if not defined ext_OK (
	echo [SKIP] 扩展名不匹配 ["%~x1"]
	set "subdir_nochk=0"
	goto check_subtitles_end
)

if defined check_same (
	call :comp.check_vs "%~1"
	if exist "%vsnfile%" (
		echo [SKIP] 找到的字幕与目标视频文件名称相同，自动跳过
		del /q "%vsnfile%"
		set "subdir_nochk=0"
	) else if "%~x1"==".idx" (
		if exist "%~dpn1.sub" (
			echo [SGET] 匹配到字幕"%~n1" [IDX+SUB]
			set /a get_sub=get_sub+1
		) else (
			echo [ERRS] 找不到与IDX文件相匹配的SUB文件
			set "subdir_nochk=0"
		)
	) else if "%~x1"==".sub" (
		if exist "%~dpn1.idx" (
			echo [SGET] 匹配到字幕"%~n1" [IDX+SUB]
			set /a get_sub=get_sub+1
		) else (
			echo [ERRS] 找不到与IDX文件相匹配的SUB文件
			set "subdir_nochk=0"
		)
	) else (
		echo [SGET] 匹配到字幕"%~nx1"
		set /a get_sub=get_sub+1
	)
) else if "%~x1"==".idx" (
	if exist "%~dpn1.sub" (
		echo [SGET] 匹配到字幕"%~n1" [IDX+SUB]
		set /a get_sub=get_sub+1
	) else (
		echo [ERRS] 找不到与IDX文件相匹配的SUB文件
		set "subdir_nochk=0"
	)
) else if "%~x1"==".sub" (
	if exist "%~dpn1.idx" (
		echo [SGET] 匹配到字幕"%~n1" [IDX+SUB]
		set /a get_sub=get_sub+1
	) else (
		echo [ERRS] 找不到与IDX文件相匹配的SUB文件
		set "subdir_nochk=0"
	)
) else (
	echo [SGET] 匹配到字幕"%~nx1"
	set /a get_sub=get_sub+1
)
:check_subtitles_end
if not defined subdir_nochk (
	if defined ass_subdir (
		if "%~dp1"=="%ass_path%" (
			echo "%~1">>"%same_sub_tmp%"
		) else (
			echo [SDIR] 文件处于子目录
		)
	) else (
		echo "%~1">>"%same_sub_tmp%"
	)
) else (
	rem echo "%~1">>"%same_sub_tmp%"
	set "subdir_nochk="
)

goto :EOF
:comp.check_vs
for /f "tokens=* usebackq" %%a in ("%vpfile%") do (
	set "comp_video=%%~na"
)
setlocal EnableDelayedExpansion
call :long_string "%comp_video%" "video_long" "n"
call :long_string "%~n1" "sub_long" "n"
if not defined check_same_ex setlocal DisableDelayedExpansion
if %sub_long% LEQ %video_long% goto :EOF
set "comp_subtitle=%~n1"
if not defined check_same_ex (
	set "name_subtitle="
	for /l %%a in (0,1,%video_long%) do (
		call :comp.addend_string
	)
) else (
	set "name_subtitle=!comp_subtitle:~0,%video_long%!"
	setlocal DisableDelayedExpansion
)
if "%comp_video%"=="%name_subtitle%" (
	echo "same">"%vsnfile%"
)
goto :EOF
:comp.addend_string
set "name_subtitle=%name_subtitle%%comp_subtitle:~0,1%"
set "comp_subtitle=%comp_subtitle:~1%"
goto :EOF
:check_subget
set "srem_without=1"
set "srem_read=-1"
if %get_sub%0 GTR 10 (
	for /f "tokens=* usebackq" %%a in ("%same_sub_tmp%") do (
		if exist "%%~a" (
			call :srem_to_preview "%%~a"
			set "subget_finish=0"
		)
	)
) else if %get_sub%0 EQU 10 (
	for /f "tokens=* usebackq" %%a in ("%same_sub_tmp%") do (
		if exist "%%~a" (
			if defined s_rem[0] (
				call :preview_sub "%%~a" "%s_rem[0]%"
			) else if defined s_rem (
				call :preview_sub "%%~a" "%s_rem%"
			) else call :preview_sub "%%~a" ""
			set "subget_finish=0"
			goto :EOF
		)
	)
)
goto :EOF
:srem_to_preview
if not defined s_rem[0] (
	if defined s_rem (
		call :preview_sub "%~1" "%s_rem%"
	) else call :preview_sub "%~1" ""
	goto :EOF
)
if defined s_rem[0] set "s_rem_back=%s_rem[0]%"
:srem_loop
set /a srem_read=srem_read+1
if not defined s_rem[%srem_read%] (
	goto nomore_s_rem_pre
)

for /f "tokens=1* delims==" %%a in ('set s_rem[%srem_read%]') do (
	call :preview_sub "%~1" "%%~b"
	goto :EOF
)
goto srem_loop
:nomore_s_rem_pre
for /f "tokens=1* delims==" %%a in ('set s_rem') do (
	if "%%~b"=="sub%srem_without%" (
		set /a srem_without=srem_without+1
		goto nomore_s_rem_pre
	)
)
call :preview_sub "%~1" ".sub%srem_without%"
goto :EOF
:got_sub
if exist "%same_sub_tmp%" del /q "%same_sub_tmp%"
set "s_path[0]="
set "s_path[1]="
setlocal EnableDelayedExpansion
goto :EOF
:rename_sub
rename "%~1" "%~nx2"
if not exist "%~2" (
	echo [ERR_] 未能重命名字幕"%~nx1"
) else (
	echo [REN_] 成功重命名字幕"%~nx2"
	echo "%~2"^|"%~nx1">>"%undofile%"
)
goto :EOF
:preview_sub
for /f "tokens=* usebackq" %%a in ("%vpfile%") do (
	set "v_name=%%~na"
)

if "%v_name%"=="" goto :EOF

if not "%~x1"==".idx" if not "%~x1"==".sub" (
	(echo "%~nx1"
	echo --^> "%v_name%%~2%~x1"
	echo.)>>"%prefile%"
	if not "%ass_path:~-1%"=="\" (
		echo "%~1"^|"%ass_path%\%v_name%%~2%~x1">>"%logfile%"
	) else echo "%~1"^|"%ass_path%%v_name%%~2%~x1">>"%logfile%"
)
if "%~x1"==".sub" (
	(echo "%~nx1" ^& "%~n1.idx"
	echo --^> "%v_name%%~2%~x1"
	echo --^> "%v_name%%~2.idx"
	echo.)>>"%prefile%"
	if not "%ass_path:~-1%"=="\" (
		echo "%~1"^|"%ass_path%\%v_name%%~2%~x1">>"%logfile%"
		echo "%~dpn1.idx"^|"%ass_path%\%v_name%%~2.idx">>"%logfile%"
	) else (
		echo "%~1"^|"%ass_path%%v_name%%~2%~x1">>"%logfile%"
		echo "%~dpn1.idx"^|"%ass_path%%v_name%%~2.idx">>"%logfile%"
	)
) else if "%~x1"==".idx" (
	(echo "%~nx1" ^& "%~n1.sub"
	echo --^> "%v_name%%~2%~x1"
	echo --^> "%v_name%%~2.sub"
	echo.)>>"%prefile%"
	if not "%ass_path:~-1%"=="\" (
		echo "%~1"^|"%ass_path%\%v_name%%~2%~x1">>"%logfile%"
		echo "%~dpn1.sub"^|"%ass_path%\%v_name%%~2.sub">>"%logfile%"
	) else (
		echo "%~1"^|"%ass_path%%v_name%%~2%~x1">>"%logfile%"
		echo "%~dpn1.sub"^|"%ass_path%%v_name%%~2.sub">>"%logfile%"
	)
)

goto :EOF

:Module_AUTO-SEARCH
:AUTO
echo [AUTO] 自动搜索模块 VER_N
setlocal EnableDelayedExpansion

set "rf=%~dp0auto_rename\"
if not exist "%rf%" mkdir "%rf%" 1>nul 2>nul

:AUTO_MAIN
del /q "%rf%*.log" 2>nul
if not defined echo_debug cls
title %bat_ver% ^| 自动匹配视频规则中...
call :try_video
if not defined echo_debug cls
title %bat_ver% ^| 自动匹配字幕规则中...
del /q "%rf%*.log" 2>nul
call :try_subtitles
if not defined echo_debug cls
del /q "%rf%*.log" 2>nul
rmdir "%rf%" 2>nul

setlocal DisableDelayedExpansion

if exist "%vffile%" (
	for /f "tokens=* usebackq" %%a in ("%vffile%") do set "filter=%%~a"
) else (
	echo [ERRA] 找不到输出的匹配规则文件
	pause
	goto end_batch
)
if exist "%sffile%" (
	for /f "tokens=* usebackq" %%a in ("%sffile%") do set "s_filter=%%~a"
) else (
	echo [ERRA] 找不到输出的匹配规则文件
	pause
	goto end_batch
)

echo [AUTO] 自动视频匹配规则: "%filter%"
echo [AUTO] 自动字幕匹配规则: "%s_filter%"

goto AUTO_BACK

:try_video
setlocal DisableDelayedExpansion
echo [WORK] 正在匹配视频...
set "has_change="
for /f "tokens=1* delims==" %%a in ('set vidext[') do (
	for /r "%v_path%" %%c in ("*%%~b") do (
		if exist "%%~c" (
			if defined vid_subdir (
				if not "%%~dpc"=="%v_path%" (
					echo [%%~b] 文件处于子目录
				) else (
					echo [%%~b] 在目录中找到文件"%%~nxc"
					for /f "tokens=1* delims=^!" %%d in ("%%~nxc") do (
						if not "%%~e"=="" (
							set "has_change=0"
							echo [RBVP] 文件名中含有半角感叹号"!"，正在转换...
							if defined use_new_echo (
								call :Echo_Replace "%%~nxc" "%rf%%%~a.log"
							) else (
								call :Module_ReplaceBatch "%%~nxc" "!" "?"
								for /f "tokens=* usebackq" %%f in ("%USERPROFILE%\rforbat.log") do (
									echo "%%~f">>"%rf%%%~a.log"
								)
							)
						) else echo "%%~nxc">>"%rf%%%~a.log"
					)
				)
			) else (
				echo [%%~b] 在目录中找到文件"%%~nxc"
				for /f "tokens=1* delims=^!" %%d in ("%%~nxc") do (
					if not "%%~e"=="" (
						set "has_change=0"
						echo [RBVP] 文件名中含有半角感叹号"!"，正在转换...
						if defined use_new_echo (
							call :Echo_Replace "%%~nxc" "%rf%%%~a.log"
						) else (
							call :Module_ReplaceBatch "%%~nxc" "!" "?"
							for /f "tokens=* usebackq" %%f in ("%USERPROFILE%\rforbat.log") do (
								echo "%%~f">>"%rf%%%~a.log"
							)
						)
					) else echo "%%~nxc">>"%rf%%%~a.log"
				)
			)
		)
	)
	if not exist "%rf%%%~a.log" (
		set "count_v_%%~a=0"
		echo;>"%rf%%%~a.log"
	)
)
setlocal EnableDelayedExpansion

set "log_count=0"
for /r "%rf%" %%a in ("*.log") do set /a log_count=log_count+1
if not %log_count% GTR 0 (
	echo [ERRA] 找不到视频
	goto MAIN
)

if not defined ext_use_most_v goto v_non_usemost

for /r "%rf%" %%a in ("*.log") do (
	echo [CONT] 正在计数"%%~a"
	for /f "usebackq tokens=*" %%b in ("%%~a") do (
		call :number_list "log_v_%%~na" "%%~b"
		set /a count_v_%%~na=count_v_%%~na+1
	)
)
echo [LARG] 正在列表中寻找数量最多的扩展名
for /f "tokens=*" %%a in ('set /a log_count-1') do (
	if %%~a GTR 0 (
		call :list_largest "count_v_vidext" "%%~a"
	) else (
		for /f "tokens=1* delims==" %%b in ('set count_v_vidext[') do (
			set "l_largest=%%~b"
		)
	)
)

goto v_ext_end
:v_non_usemost
for /r "%rf%" %%a in ("*.log") do (
	echo [CONT] 正在计数"%%~a"
	for /f "usebackq tokens=*" %%b in ("%%~a") do (
		call :number_list "log_v_vidext[0]" "%%~b"
	)
)
set "l_largest=count_v_vidext[0]"
:v_ext_end

if not defined same_long_v goto v_non_samelong

set "largest_vid=%l_largest:~14%"
echo [LSTR] 正在计算文件名长度
for /f "tokens=1* delims==" %%a in ('set log_v_%l_largest:~8%') do (
	call :cut_string "%%~b" "%%~a"
)
echo [NAPR] 正在选择出现次数最多的文件名长度
call :list_appear_mostV2 "long_v%largest_vid%"
echo [LIST] 正在列表文件名
for /f "tokens=1* delims==" %%a in ('set long_v') do (
	if "%%~b"=="%appear_most%" (
		call :cut_string_2 "%%~a"
	)
)

goto v_list_end
:v_non_samelong
echo [LIST] 正在列表文件名
for /f "tokens=1* delims==" %%a in ('set log_v_%l_largest:~8%') do (
	call :cut_string_3 "%%~a"
)
:v_list_end
echo [COMP] 列表内差异计算
call :compare_list "c_v" "%count_range%"
call :list_appear_mostV2 "comp_diff"
echo [CHKN] 容差值计算 a=±%deviation_a%,b=±%deviation_b%
for /f "tokens=1* delims==" %%a in ('set comp_diff%l_largest:~12%') do (
	for /f "tokens=1,2 delims=," %%c in ("%%~b") do (
		for /f "tokens=1* delims==" %%e in ('set comp_diff') do (
			for /f "tokens=1,2 delims=," %%g in ("%%~f") do (
				call :check_num "%%~g" "%%~c,%deviation_a%" "%%~e" "c_v"
				call :check_num "%%~h" "%%~d,%deviation_b%" "%%~e" "c_v"
			)
		)
	)
)

echo [LIST] 开始制表文件名
for /f "tokens=1* delims==" %%a in ('set comp_diff') do (
	call :make_list "%%~a" "%%~b" "c_v" "9"
)
set "list_count=-1"
for /f "tokens=*" %%a in ('set v_diff') do (
	set /a list_count=list_count+1
)
echo [LIST] 制表差异值
for /l %%a in (0,1,%list_count%) do (
	for /f "tokens=1* delims==" %%b in ('set v_diff[%%~a]') do (
		for /f "tokens=1,2,3 delims=," %%d in ("%%~c") do (
			set "comp_diff_1[%%~a]=%%~d"
			set "comp_diff_2[%%~a]=%%~e"
		)
	)
)

echo [MINI] 差异位置求最小值
call :list_minimum "comp_diff_1" "%list_count%"
echo [MINI] 差异位置"%n_minimum%"，位于表"%l_minimum%"
echo [MAXN] 差异量求最大值
call :list_largest "comp_diff_2" "%list_count%"
echo [MAXN] 差异量"%n_largest%"，位于表"%l_largest%"

set "vf_s=%n_minimum%"
set "vf_c=%n_largest%"
for /f "tokens=1,2,* delims=," %%a in ("%v_diff[0]%") do (
	set "vf=%%~c"
	set "vf_x=%%~xc"
	goto v_dont_get_more
)
:v_dont_get_more
if defined echo_debug (
	set v_diff
	echo "%vf%" "%vf_x%" "%vf_s%,%vf_c%"
)
set "filter=!vf:~0,%vf_s%!"
setlocal DisableDelayedExpansion
if defined has_change for /f "tokens=1,2 delims=?" %%a in ("%filter%") do (
	if not "%%~b"=="" (
		if not defined use_new_echo (
			call :Module_ReplaceBatch "%filter%" "?" "!"
		) else call :Echo_Replace "%%~nxc" "%USERPROFILE%\rforbat.log" "0"
		for /f "tokens=* usebackq" %%a in ("%USERPROFILE%\rforbat.log") do set "filter=%%~a"
	)
)
set "has_change="
setlocal EnableDelayedExpansion
call :add_char "?" "%vf_c%" "filter"
setlocal DisableDelayedExpansion
if defined ext_use_most_v (
	set "filter=%filter%*%vf_x%"
) else set "filter=%filter%*"
echo "%filter%">>"%~dp0vf_rename.log"
echo [V_FI] 计算出视频过滤规则"%filter%"
setlocal EnableDelayedExpansion
call :clear_list "comp_diff_1"
call :clear_list "comp_diff_2"
call :clear_list "comp_diff"
call :clear_list "v_diff"
call :clear_list "count_v_vidext" 
if defined echo_debug pause
goto :EOF

:cut_string
set "cs_cut=%~2"
call :long_string "%~1" "s_long"
set "long_v%cs_cut:~12%=%s_long%"
goto :EOF
:cut_string_2
set "cs_cut=%~1"
set "cs_cut=!log_v_vidext%cs_cut:~6%!"
call :number_list "c_v" "%cs_cut%"
goto :EOF
:cut_string_3
set "cs_cut=%~1"
set "cs_cut=!log_v_vidext%cs_cut:~12%!"
call :number_list "c_v" "%cs_cut%"
goto :EOF
:make_list
set "in_name=%~1"
set "in_text=%~2"
set "in2_name=%~3"
set "instr_1=%~4"
set "count=!in_name:~%instr_1%!"
for /f "tokens=1* delims==" %%a in ('set %in2_name%%count%') do (
	call :number_list "v_diff" "%in_text%,%%~b"
)
goto :EOF

:try_subtitles
echo [WORK] 正在匹配字幕...
setlocal DisableDelayedExpansion
set "has_change="
for /f "tokens=1* delims==" %%a in ('set subext[') do (
	for /r "%sub_path%" %%c in ("*%%~b") do (
		if exist "%%~c" (
			if defined ass_subdir (
				if not "%%~dpc"=="%sub_path%" (
					echo [%%~b] 文件处于子目录"%%~nc"
				) else (
					if "%%~xc"==".idx" (
						if exist "%%~dpnc.sub" (
							echo [%%~b] 在目录中找到文件"%%~nc" [IDX+SUB]
							call :subtitles_remove_char "%%~c" "%%~a"
						)
					) else (
						echo [%%~b] 在目录中找到文件"%%~nxc"
						call :subtitles_remove_char "%%~c" "%%~a"
					)
				)
			) else (
				if "%%~xc"==".idx" (
					if exist "%%~dpnc.sub" (
						echo [%%~b] 在目录中找到文件"%%~nc" [IDX+SUB]
						call :subtitles_remove_char "%%~c" "%%~a"
					)
				) else (
					echo [%%~b] 在目录中找到文件"%%~nxc"
					call :subtitles_remove_char "%%~c" "%%~a"
				)
			)
		)
	)
	if not exist "%rf%%%~a.log" (
		set "count_s_%%~a=0"
		echo;>"%rf%%%~a.log"
	)
)

goto s_remove_char_finish

:subtitles_remove_char
for /f "tokens=1* delims=^!" %%a in ("%~nx1") do (
	if not "%%~b"=="" (
		set "has_change=0"
		echo [RBSP] 文件名中含有半角感叹号"!"，正在转换...
		if not defined use_new_echo (
			call :Module_ReplaceBatch "%~nx1" "!" "?"
			for /f "tokens=1,2 delims=^| usebackq" %%c in ("%USERPROFILE%\rforbat.log") do (
				echo "%~nx1">>"%rf%%~2.log"
			)
		) else call :Echo_Replace "%~nx1" "%rf%%~2.log"
	) else echo "%~nx1">>"%rf%%~2.log"
)
goto :EOF
:s_remove_char_finish

setlocal EnableDelayedExpansion
set "log_count=0"
for /r "%rf%" %%a in ("*.log") do set /a log_count=log_count+1
if not %log_count% GTR 0 (
	echo [ERRA] 找不到字幕
	goto MAIN
)

if not defined ext_use_most_s goto s_non_usemost

for /r "%rf%" %%a in ("*.log") do (
	echo [CONT] 正在计数"%%~a"
	for /f "usebackq tokens=*" %%b in ("%%~a") do (
		call :number_list "log_s_%%~na" "%%~b"
		set /a count_s_%%~na=count_s_%%~na+1
	)
)

echo [LARG] 正在列表中寻找数量最多的扩展名
for /f "tokens=*" %%a in ('set /a log_count-1') do (
	if %%~a GTR 0 (
		call :list_largest "count_s_subext" "%%~a"
	) else (
		for /f "tokens=1* delims==" %%b in ('set count_s_subext[') do (
			set "l_largest=%%~b"
		)
	)
)

goto s_ext_end
:s_non_usemost
for /r "%rf%" %%a in ("*.log") do (
	for /f "usebackq tokens=*" %%b in ("%%~a") do (
		call :number_list "log_s_subext[0]" "%%~b"
	)
)
set "l_largest=count_s_subext[0]"
:s_ext_end

if not defined same_long_s goto s_non_samelong

set "largest_sid=%l_largest:~14%"
echo [LSTR] 正在计算文件名长度
for /f "tokens=1* delims==" %%a in ('set log_s_%l_largest:~8%') do (
	call :cut_string_s "%%~b" "%%~a"
)

echo [NAPR] 正在选择出现次数最多的文件名长度
call :list_appear_mostV2 "long_s%largest_sid%"
echo [LIST] 正在列表文件名
for /f "tokens=1* delims==" %%a in ('set long_s') do (
	if "%%~b"=="%appear_most%" (
		call :cut_string_s_2 "%%~a"
	)
)

goto s_list_end
:s_non_samelong
echo [LIST] 正在列表文件名
for /f "tokens=1* delims==" %%a in ('set log_s_%l_largest:~8%') do (
	call :cut_string_s_3 "%%~a"
)
:s_list_end

echo [COMP] 列表内差异计算
call :compare_list "c_s" "%count_range%"
call :list_appear_mostV2 "comp_diff"
echo [CHKN] 容差值计算 a=±%deviation_a%,b=±%deviation_b%
for /f "tokens=1* delims==" %%a in ('set num_appear%l_largest:~12%') do (
	for /f "tokens=1,2 delims=," %%c in ("%%~b") do (
		for /f "tokens=1* delims==" %%e in ('set comp_diff') do (
			for /f "tokens=1,2 delims=," %%g in ("%%~f") do (
				call :check_num "%%~g" "%%~c,%deviation_a%" "%%~e" "c_s"
				call :check_num "%%~h" "%%~d,%deviation_b%" "%%~e" "c_s"
			)
		)
	)
)
echo [LIST] 开始制表文件名
for /f "tokens=1* delims==" %%a in ('set comp_diff') do (
	echo [%%~b]
	call :make_list_s "%%~a" "%%~b" "c_s" "9"
)
set "list_count=-1"
for /f "tokens=*" %%a in ('set s_diff') do (
	set /a list_count=list_count+1
)
echo [LIST] 制表差异值
for /l %%a in (0,1,%list_count%) do (
	for /f "tokens=1* delims==" %%b in ('set s_diff[%%~a]') do (
		for /f "tokens=1,2,3 delims=," %%d in ("%%~c") do (
			set "comp_diff_1[%%~a]=%%~d"
			set "comp_diff_2[%%~a]=%%~e"
		)
	)
)

echo [MINI] 差异位置求最小值
call :list_minimum "comp_diff_1" "%list_count%"
echo [MINI] 差异位置"%n_minimum%"，位于表"%l_minimum%"
echo [MAXN] 差异量求最大值
call :list_largest "comp_diff_2" "%list_count%"
echo [MAXN] 差异量"%n_largest%"，位于表"%l_largest%"

set "sf_s=%n_minimum%"
set "sf_c=%n_largest%"
for /f "tokens=1,2,* delims=," %%a in ("%s_diff[0]%") do (
	set "sf=%%~c"
	set "sf_x=%%~xc"
	goto s_dont_get_more
)
:s_dont_get_more
set "s_filter=!sf:~0,%sf_s%!"
setlocal DisableDelayedExpansion
if defined has_change for /f "tokens=1,2 delims=?" %%a in ("%s_filter%") do (
	if not "%%~b"=="" (
		if not defined use_new_echo (
			call :Module_ReplaceBatch "%s_filter%" "?" "!"
		) else call :Echo_Replace "%s_filter%" "%USERPROFILE%\rforbat.log" "0"
		for /f "tokens=* usebackq" %%a in ("%USERPROFILE%\rforbat.log") do set "s_filter=%%~a"
	)
)
setlocal EnableDelayedExpansion
call :add_char "?" "%sf_c%" "s_filter"
setlocal DisableDelayedExpansion
set "has_change="
if defined ext_use_most_s (
	set "s_filter=%s_filter%*%sf_x%"
) else set "s_filter=%s_filter%*"
echo "%s_filter%">>"%~dp0sf_rename.log"
echo [S_FI] 计算出字幕过滤规则"%s_filter%"

setlocal EnableDelayedExpansion

call :clear_list "comp_diff_1"
call :clear_list "comp_diff_2"
call :clear_list "comp_diff"
call :clear_list "count_s_subext" 
call :clear_list "s_diff"
if defined echo_debug pause
goto :EOF

:cut_string_s
set "cs_cut=%~2"
call :long_string "%~1" "s_long"
set "long_s%cs_cut:~12%=%s_long%"
goto :EOF
:cut_string_s_2
set "cs_cut=%~1"
set "cs_cut=!log_s_subext%cs_cut:~6%!"
call :number_list "c_s" "%cs_cut%"
goto :EOF
:cut_string_s_3
set "cs_cut=%~1"
set "cs_cut=!log_s_subext%cs_cut:~12%!"
call :number_list "c_s" "%cs_cut%"
goto :EOF
:make_list_s
set "in_name=%~1"
set "in_text=%~2"
set "in2_name=%~3"
set "instr_1=%~4"
set "count=!in_name:~%instr_1%!"
for /f "tokens=1* delims==" %%a in ('set %in2_name%%count%') do (
	call :number_list "s_diff" "%in_text%,%%~b"
)
goto :EOF


rem 附加模块组 包括各种运算方式与简化函数
rem 用法一般写在该函数的前一行
:Module_ADDITION
rem call :add_char "[char]" "[count]" "[value]"
:add_char
for /l %%a in (1,1,%~2) do (
	call :add_char_1 "%~1" "%~3"
)
goto :EOF
:add_char_1
set "%~2=!%~2!%~1"
goto :EOF

rem call :number_list "[list_name]" "[string]"
:number_list
if defined %~1[0] (
	for /f "tokens=1* delims==" %%a in ('set C_%~1') do (
		set "%~1[%%~b]=%~2"
	)
	set /a C_%~1=C_%~1+1
) else (
	set "%~1[0]=%~2"
	set "C_%~1=1"
)
goto :EOF
:add_list_end
set "list_end=0"
:add_list_end_loop
set /a list_end=list_end+1
if not defined %~1[%list_end%] (
	set "%~1[%list_end%]=%~2"
	goto :EOF
) else goto add_list_end_loop

rem call :list_largest "[list_name]" "[list_count]"
:list_largest
rem "list_name=%~1"
rem "list_count=%~2"
if "%~2"=="0" (
	for /f "tokens=1* delims==" %%a in ('set %~1[0]') do set "n_largest=%%~b"
	set "l_largest=%~1[0]"
	goto :EOF
)
for /f "tokens=1* delims==" %%a in ('set %~1[0]') do (
	set "n_largest=%%~b"
	set "l_largest=%%~a"
)
for /l %%a in (0,1,%~2) do (
	for /f "tokens=1* delims==" %%b in ('set %~1[%%~a]') do (
		call :number_compare "%%~c" "%%~b"
	)
)
goto :EOF
:number_compare
if %n_largest% LSS %~1 (
	set "n_largest=%~1"
	set "l_largest=%~2"
) 
goto :EOF

rem call :list_minimum "[list_name]" "[list_count]"
:list_minimum
if %~2==0 (
	for /f "tokens=1* delims==" %%a in ('set %~1[0]') do set "n_minimum=%%~b"
	set "l_minimum=%~1[0]"
	goto :EOF
)
for /f "tokens=1* delims==" %%a in ('set %~1[0]') do (
	set "n_minimum=%%~b"
	set "l_minimum=%%~a"
)
for /l %%a in (0,1,%~2) do (
	for /f "tokens=1* delims==" %%b in ('set %~1[%%~a]') do (
		call :number_compare_min "%%~c" "%%~b"
	)
)
goto :EOF
:number_compare_min
if %n_minimum% GTR %~1 (
	set "n_minimum=%~1"
	set "l_minimum=%~2"
) 
goto :EOF

rem call :list_appear "[list_name]"
:list_appear
rem list_name=%~1
if not defined %~1[0] goto :EOF
call :clear_list "num_appear"
for /f "tokens=1* delims==" %%a in ('set %~1[0]') do (
	call :number_list "num_appear" "%%~b"
)
for /f "tokens=1* delims==" %%a in ('set %~1[') do (
	call :compare_appear_list "%%~b"
)
goto :EOF
:compare_appear_list
for /f "tokens=1* delims==" %%a in ('set num_appear[') do (
 	if "%~1"=="%%~b" goto :EOF
) 
call :number_list "num_appear" "%~1"
goto :EOF

rem call :list_appear_most "[list_name]" "[appear_list]"
:list_appear_most
if not defined %~1[0] goto :EOF
call :clear_list "appear_count"
set "list_appear_count=-1"
for /f "tokens=1* delims==" %%a in ('set %~2[') do (
	call :count_list_appear "%~1" "%%~b"
	set /a list_appear_count=list_appear_count+1
)
call :list_largest "appear_count" "%list_appear_count%"
set "appear_most=!num_appear%l_largest:~12%!"
goto :EOF
:count_list_appear
set "count_appear=0"
for /f "tokens=1* delims==" %%a in ('set %~1[') do (
	if "%%~b"=="%~2" set /a count_appear=count_appear+1
)
call :number_list "appear_count" "%count_appear%"
goto :EOF

rem call :list_appear_mostV2 "[list_name]"
:list_appear_mostV2
if not defined %~1[0] goto :EOF
call :clear_list "num_appear"
call :clear_list "appear_count"
set "list_appear_count=-1"
for /f "tokens=1* delims==" %%a in ('set %~1[') do (
	call :compare_appear_list2 "%%~b" "%~1"
)
call :list_largest "appear_count" "%list_appear_count%"
set "appear_most=!num_appear%l_largest:~12%!"
goto :EOF
:compare_appear_list2
if defined num_appear[0] (
    for /f "tokens=1* delims==" %%a in ('set num_appear[') do (
 	    if "%~1"=="%%~b" goto :EOF
    )
)
call :number_list "num_appear" "%~1"
:appear_most2
set "count_appear=0"
for /f "tokens=1* delims==" %%a in ('set %~2[') do (
	if "%~1"=="%%~b" set /a count_appear=count_appear+1
)
call :number_list "appear_count" "%count_appear%"
set /a list_appear_count=list_appear_count+1
goto :EOF

rem call :long_string "[string]" "[return]" "[show_result]"
:long_string
if "%~1"=="" goto :EOF
if "%~2"=="" goto :EOF
set "string_long=0"
set "string_in=%~1"
if not defined ls_step (
	set "ls_step=5"
) else if %ls_step% LSS 1 goto :EOF
:long_string_loop
set /a string_long=string_long+ls_step
set "ls_check=!string_in:~%string_long%!"
if defined ls_check (
	goto long_string_loop
)
set /a string_long=string_long-ls_step
set "ls_check=!string_in:~%string_long%!"
set "ls_lcheck=0"
:long_string_l2
set "ls_lcheck_s=!ls_check:~%ls_lcheck%!"
if not "%ls_lcheck_s%"=="" (
	set /a string_long=string_long+1
) else goto long_string_return
set /a ls_lcheck=ls_lcheck+1
goto long_string_l2
:long_string_return
set "ls_lcheck_s="
set "ls_lcheck="
set "ls_check="
set "string_in="
set "%~2=%string_long%"
if "%~3"=="" echo [LSTR] 返回"%~2"，长度为"%string_long%"
set "string_long="
goto :EOF

rem call :compare_list "[list_name]" "[select_compare]"
rem select_compare: 
rem 	If [list_count] GTR [select_compare], only use [select_compare] count to compare
rem 	use [select_compare] can save time if you think this function spend you too much time
:compare_list
if not defined %~1[0] goto :EOF
if not "%~2"=="" set "selcount=%~2"
set "list_count=-1"
for /f "tokens=*" %%a in ('set %~1[') do (
	set /a list_count=list_count+1
)
if not defined selcount goto compare_list.non_selcount
if %list_count% GTR %selcount% (
	echo [COMP] 项数"%list_count%"超过阈值"%selcount%"，自动调整为"%selcount%"
	set "list_count=%selcount%"
)
:compare_list.non_selcount
for /l %%a in (0,1,%list_count%) do (
	if defined %~1[%%~a] for /f "tokens=1* delims==" %%b in ('set %~1[%%~a]') do (
		echo [COMP] 正在比较表"%~1"项"%%~a"
		call :compare_string "%%~c" "%~1" "%selcount%"
	)
)
set "list_count="
set "selcount="
goto :EOF

rem call :compare_string "[string]" "[compare_list]"
:compare_string
if not defined %~2[0] goto :EOF
if not "%~3"=="" set "selcount=%~3"
set "compare_start=%time%"
echo [COMP] 正在表"%~2"中计算"%~1"的差异值
call :clear_list "str_diff"
set "comp_count=0"
for /f "tokens=1* delims==" %%a in ('set %~2[') do (
	call :compare_char "%~1" "%%~b"
	if defined selcount call :check_selcount
	if defined selcount_ok (
		set "selcount_ok="
		goto compare_string.end_char
	)
)
:compare_string.end_char
if defined show_howlong call :time_calculation "%compare_start%" "%time%" "compare_speed"
call :list_appear_mostV2 "str_diff"
for /f "tokens=1* delims==" %%a in ('set num_appear%l_largest:~12%') do (
	echo [COMP] 差异位置与差异值为"%%~b" [%compare_speed%]
	call :number_list "comp_diff" "%%~b"
)
set "comp_count="
set "compare_start="
set "compare_speed="
goto :EOF
:check_selcount
if "%comp_count%"=="%selcount%" set "selcount_ok=0"
goto :EOF
:compare_char
set "char_time=%time%"
set /a comp_count=comp_count+1
if "%~1"=="%~2" (
	set "diff_count="
	set "diff_in="
	goto :EOF
)
set "in_comp=%~1"
set "in_comp2=%~2"
set "ccl_count=-1"
set "diff_count=0"
set "diff_in="
:compare_char_loop
set /a ccl_count=ccl_count+com_step
set "comp_1=!in_comp:~0,%ccl_count%!"
set "comp_2=!in_comp2:~0,%ccl_count%!"
if "%comp_1%"=="" goto list_compare_diff
if "%comp_2%"=="" goto list_compare_diff
if not "%comp_1%"=="%comp_2%" (
	if not defined diff_in (
		set "diff_in=%ccl_count%"
	)
	call :compare_char_range "%~1"
	goto list_compare_diff
)
goto compare_char_loop
:list_compare_diff
call :time_calculation "%char_time%" "%time%" "char_speed"
if defined diff_count if defined diff_in (
	echo - 发现差异于"%diff_in%,%diff_count%" [%char_speed%]
	call :number_list "str_diff" "%diff_in%,%diff_count%"
)
set "char_speed="
set "char_time="
goto :EOF
:compare_char_range
set /a ccl_count=ccl_count-com_step
set /a diff_in=diff_in-com_step
set "com_char=0"
set "has_diff="
:compare_char_l2
set "com_char_1=!in_comp:~%ccl_count%,1!"
set "com_char_2=!in_comp2:~%ccl_count%,1!"
if defined has_diff if "%com_char_1%"=="%com_char_2%" goto :EOF
if "%com_char_1%"=="" goto :EOF
if "%com_char_2%"=="" goto :EOF
if not "%com_char_1%"=="%com_char_2%" (
	set "has_diff=0"
	set /a diff_count=diff_count+1
) else set /a diff_in=diff_in+1
if defined compare_limit if %diff_count%0 GEQ %compare_limit%0 (
	if defined compare_limit_method (
		call :long_string "%~1" "comp_str_long" "0"
		set /a diff_count=comp_str_long-diff_in
	) else (
		set /a diff_count=-2*deviation_a
	)
	goto :EOF
)
set /a ccl_count=ccl_count+1
goto compare_char_l2

rem call :clear_list "[list_name]"
:clear_list
echo [CLLT] 尝试清理列表"%~1"
for /f "tokens=1* delims==" %%a in ('set %~1 2^>nul') do (
	if not "%%~b"=="" set "%%~a="
)
goto :EOF

rem call :num_in_range "[16-bit integer]" "[range]" "[return]"
rem [range]: 33(median, unsigned),2(deviation, unsigned)
rem [return]: null (out of range) OR defined (in range)
:num_in_range
set "median=%~1"
for /f "tokens=1,2 delims=," %%a in ("%~2") do (
	set /a devia_min=%%~a-%%~b
	set /a devia_max=%%~a+%%~b
)
if %median% GEQ %devia_min% if %median% LEQ %devia_max% (
	set "%~3=t"
	goto :EOF
)
set "%~3="
goto :EOF

rem call :check_num "[16-bit integer]" "[unsigned deviation]" "[list_count_name]" "[list_name_2]" "[list_count1_in]"
:check_num
set "list_count_name=%~3"
if not "%~5"=="" set "list_count_name=!list_count_name:~%~5!"
call :num_in_range "%~1" "%~2" "num_check"
if not defined num_check (
	set "%~3="
	if not "%~4"=="" set "%~4%list_count_name%="
)
set "list_count_name="
goto :EOF

rem call :time_calculation "[start]" "[end]" "[return]"
rem 	THE [start] and [END] must be "%time%" or HH:mm:ss.ms
:time_calculation
if not "%~1"=="" set "t_start=%~1"
if not "%~2"=="" set "t_end=%~2"
set "t_start[0]=%t_start:~0,2%"
if "%t_start[0]:~0,1%"=="0" set "t_start[0]=%t_start[0]:~1%"
set "t_start[1]=%t_start:~3,2%"
if "%t_start[1]:~0,1%"=="0" set "t_start[1]=%t_start[1]:~1%"
set "t_start[2]=%t_start:~6,2%"
if "%t_start[2]:~0,1%"=="0" set "t_start[2]=%t_start[2]:~1%"
set "t_start[3]=%t_start:~9,2%"
if "%t_start[3]:~0,1%"=="0" set "t_start[3]=%t_start[3]:~1%"

set "t_end[0]=%t_end:~0,2%"
if "%t_end[0]:~0,1%"=="0" set "t_end[0]=%t_end[0]:~1%"
set "t_end[1]=%t_end:~3,2%"
if "%t_end[1]:~0,1%"=="0" set "t_end[1]=%t_end[1]:~1%"
set "t_end[2]=%t_end:~6,2%"
if "%t_end[2]:~0,1%"=="0" set "t_end[2]=%t_end[2]:~1%"
set "t_end[3]=%t_end:~9,2%"
if "%t_end[3]:~0,1%"=="0" set "t_end[3]=%t_end[3]:~1%"

set /a t_start_ms=t_start[0]*60*60*1000+t_start[1]*60*1000+t_start[2]*1000+t_start[3]*10
set /a t_end_ms=t_end[0]*60*60*1000+t_end[1]*60*1000+t_end[2]*1000+t_end[3]*10
set /a t_cache=t_end_ms-t_start_ms
if %t_cache% LSS 0 set /a t_end_ms=t_end_ms+86400000
if %t_cache% LSS 0 set /a t_cache=t_end_ms-t_start_ms
if %t_cache%==0 set "t_cache=LSS 10"
if "%~3" NEQ "" (
	set "%~3=%t_cache% ms"
) else if "%t_cache%"=="LSS 10" (
	echo [TIME] ^<%t_cache% ms
) else echo [TIME] %t_cache% ms


set "t_start="
set "t_start[0]="
set "t_start[1]="
set "t_start[2]="
set "t_start[3]="
set "t_cache="
set "t_end="
set "t_end[0]="
set "t_end[1]="
set "t_end[2]="
set "t_end[3]="

goto :EOF

rem call :Echo_Replace "[string]" "[write_to_file]"
:Echo_Replace
set "input_cache=%~1"
set "wtofile=%~2"
if not defined input_cache goto :EOF
if not defined wtofile set "wtofile=%USERPROFILE%\rforbat.log"
if not exist "%wtofile%" (
	echo.>"%wtofile%"
	if not exist "%wtofile%" (
		set "wtofile=%USERPROFILE%\rforbat.log"
	) else del /q "wtofile=%USERPROFILE%\rforbat.log"
) else echo.>NUL

if "%~3"=="" (
	echo "%input_cache:!=?%">>"%wtofile%"
) else echo "%input_cache:?=!%">>"%wtofile%"

set "input_cache="
set "output_cache="
set "replace_cache="
set "wtofile="
goto :EOF

rem call :Module_ReplaceBatch "[string]" "[replace_char]" "[to_char]" "[enableDE]"
rem NOTICE: This module's results will write into "%USERPROFILE%\rforbat.log"
rem
rem Replace for Batch (yyfll)
rem 	Version: V3_SP (SP: Only for RE:RenameSubtitles)
:Module_ReplaceBatch
setlocal DisableDelayedExpansion
if "%~1"=="" (
	goto RB.error_input
) else if "%~2"=="" (
	goto RB.error_input
)
set "input_string=%~1"
if "%input_string:~0,1%"=="" (
	echo [ERROR] 您没有输入任何字符！
	goto RB.error_input
)
set "for_delims=%~2"
if "%for_delims%"=="" (
	echo [ERROR] 您没有输入任何要替换的字符！
	goto RB.error_input
)
if not "%for_delims:~1%"=="" (
	echo [ERROR] Replace对象必须是单个字符
	goto RB.error_input
)
for /f "tokens=1* delims=%for_delims%" %%a in ("%input_string%") do (
	if "%%~a%%~b"=="%input_string%" (
		echo "%input_string%">"%USERPROFILE%\rforbat.log"
		goto RB.end_clear
	)
)
set "replace_to=%~3"
set "output_string="

if not "%replace_to%"=="@insert@" goto RB.choose_finish
set "insert_collect=@#$~`;'[]{}_,?\/"
set "working_insert=%insert_collect%"
:RB.choose_insert
set "insert=%working_insert:~0,1%"
if "%insert%"=="" (
	echo [ERROR] 您的输入中包含本模块无法处理的字符
	goto RB.error_input
)
for /f "tokens=2 delims=%insert%" %%a in ("^|%input_string%^|") do (
	if "%%~a"=="" (
		goto RB.choose_finish
	) else (
		set "working_insert=%working_insert:~1%"
		goto RB.choose_insert
	)
)
:RB.choose_finish


set "RB_working=%input_string%"
:RB.re_replace
set "RB_cache=%RB_working:~0,1%"
if "%RB_cache%"=="%for_delims%" (
	if "%replace_to%"=="@insert@" (
		set "output_string=%output_string%%insert%"
	) else set "output_string=%output_string%%replace_to%"
) else set "output_string=%output_string%%RB_cache%"
set "RB_working=%RB_working:~1%"
if not defined RB_working goto RB.replace_finish
goto RB.re_replace
:RB.replace_finish
if "%replace_to%"=="@insert@" (
	echo "%output_string%^|%insert%">"%USERPROFILE%\rforbat.log"
) else echo "%output_string%">"%USERPROFILE%\rforbat.log"
:RB.end_clear
if not "%~4"=="" setlocal EnableDelayedExpansion
set "RB_cache="
set "input_string="
set "RB.return="
set "output_string="
set "for_delims="
set "loop="
goto :EOF
:RB.error_input
echo [ERROR] 输入无效
pause
goto RB.end_clear