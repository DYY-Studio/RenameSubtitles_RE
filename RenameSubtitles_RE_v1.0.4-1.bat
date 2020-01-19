@echo off
rem chcp 65001
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

rem [count_range]
rem 控制compare_list进行比较的项数，可以加快AUTO，但错误率增大
set "count_range=15"
rem 可用值 
rem 	{1~n(非负整数)}（从0开始计数，即=15时会比较16项）
rem 	{留空}（不启用，即全项目检索）
rem 推荐值
rem 	{10~20}（不建议少于10）
rem 	{≥100}（对于集数超过100的）

rem [ls_step]
rem 控制long_string每一循环计数的字符量，值越大对长字符串的计数就越快，但对短字符串就越慢
set "ls_step=5"
rem 可用值
rem 	{1~n(非负整数)}
rem 推荐值
rem 	{5~10}

rem [com_step]
rem 控制compare_string每一循环计数的字符量，值越大对长字符串的计数就越快，但对短字符串就越慢
set "com_step=5"
rem 可用值
rem 	{1~n(非负整数)}
rem 推荐值
rem 	{5~10}

set "bat_ver=RenameSubtitles RE: Ver1.0.4 GB2312"
title %bat_ver% [(c) yyfll]
echo [INFO] %bat_ver%
echo [INFO] Copyright(c) 2019 yyfll

setlocal EnableDelayedExpansion

:MAIN
echo.
echo [ 视频目录 ]
set /p v_path=[V_IN] V_PATH: 
rem goto v_check_end
echo [CHKV] 正在检查视频目录CMD兼容性及可用性
call :check_path_cmd
if defined path_inv (
	set "path_inv="
	goto MAIN
)
if not exist "%v_path%" (
	echo [V_EX] 找不到视频路径
	goto MAIN
)
echo [CHKV] 视频目录确认成功

:MAIN_S
echo.
echo [ 字幕目录（留空默认同视频目录） ]
set /p sub_path=[S_IN] S_PATH: 
if not defined sub_path (
	echo [VOID] 自动套用视频目录
	set "sub_path=%v_path%"
	goto s_check_end
)

echo [CHEK] 正在检查字幕目录CMD兼容性及可用性
echo.
rem goto s_check_end

call :check_path_cmd_s
if defined path_inv (
	set "path_inv="
	goto MAIN_S
)
if not exist "%sub_path%" (
	echo [S_EX] 找不到字幕路径
	goto MAIN_S
)

echo [CHKS] 字幕目录确认成功
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
echo [ 匹配规则即如何匹配视频 请用半角问号代替集数   ]
echo [ 例如[CASO][El_Cazador][GB_BIG5][01][DVDRIP]   ]
echo [ 替换成[CASO][El_Cazador][GB_BIG5][??][DVDRIP] ]
echo [ 如果视频有非常麻烦的如校验值在文件名结尾      ]
echo [ 请使用通配符 如[CASO][*][GB_BIG5][??][*       ]
echo [ 视频匹配规则 ]
set /p filter=[V_FI] V_FILTER: 
echo.
echo [ 字幕匹配规则 ]
set /p s_filter=[S_FI] S_FILTER: 
echo.
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
echo [ 字幕注释（可以留空） ]
set /p s_rem=[SANN] S_Annotate: 
if not defined s_rem goto norem_sub
if not "%s_rem%"=="" if not "%s_rem:~0,1%"=="." set "s_rem=.%s_rem%"
:norem_sub
if defined auto goto AUTO
echo.
echo [ 搜索子目录即 搜索指定字幕目录之下的所有目录   ]
echo [ 如果您的字幕文件夹底下还有其他类似字幕 不推荐 ]
echo [ 一般匹配规则可以替代该选项 请自行决定是否启用 ]
echo [ 子目录搜索（[y]启用^/[n]停用） ]
set /p ass_subdir=[SDIR] S_Dir[y/n]: 
if "%ass_subdir%"=="1" (
	set "ass_subdir=y"
) else if "%ass_subdir%"=="2" (
	set "ass_subdir=n"
) else (
	set "ass_subdir=n"
)
:AUTO_BACK

cls
echo [WORK] 正在匹配规则中寻找剧集位置...
:GET_COUNT

set "get_loop=0"
set "instr[0]="
set "instr[1]="
set "get_count=0"
set "stop_count=0"
:FIND_COUNT
set "a_char=!filter:~%get_loop%,1!"
if "%a_char%"=="?" (
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
:FIND_SUB_COUNT
set "a_char=!s_filter:~%get_loop%,1!"
if "%a_char%"=="?" (
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

set "s_instr[1]=%get_count%"
echo [SINS] 在字幕匹配规则中找到位置%s_instr[0]%，长度%s_instr[1]%
echo.

if not "%sub_path:~0,-1%"=="\" set "sub_path=%sub_path%\"
if exist "%sub_path%undo_rename.log" del /q "%sub_path%undo_rename.log"
if exist "%sub_path%rename_preview.log" del /q "%sub_path%rename_preview.log"
if exist "%sub_path%rename_log.log" del /q "%sub_path%rename_log.log"
:LOOP_NUM
title %bat_ver% ^| 视频字幕匹配中...
for /f "tokens=1,2 delims=," %%a in ("%ep%") do (
	for /l %%c in (%%~a,1,%%~b) do (
		echo [LOOP] 尝试匹配剧集%%~c
		call :SEARCH_VIDEO "%%~c"
		if not defined not_work (
			call :SEARCH_ASS "%sub_path%" "%s_filter%" "%%~c" "%ass_subdir%"
		) else set "not_work="
	)
)

if not exist "%sub_path%rename_preview.log" (
	echo [ERR_] 找不到匹配的重命名项
	goto end_batch
)
if not exist "%sub_path%rename_log.log" (
	echo [ERR_] 找不到匹配的重命名项
	goto end_batch
)

:preview_check
cls
title %bat_ver% ^| 重命名预览
echo [PREV] 重命名预览
echo.
type "%sub_path%rename_preview.log"
echo [PREV] 预览显示完毕
choice /M "[CHK_] 要执行这样的重命名吗？"
if %errorlevel%==0 goto preview_check
if %errorlevel%==1 (
	echo.
	for /f "usebackq tokens=1,2 delims=^|" %%a in ("%sub_path%rename_log.log") do (
		call :rename_sub "%%~a" "%%~b"
	)
)
if exist "%sub_path%rename_preview.log" del /q "%sub_path%rename_preview.log"
if exist "%sub_path%rename_log.log" del /q "%sub_path%rename_log.log"
	
:end_batch
setlocal DisableDelayedExpansion
goto :EOF

:SEARCH_VIDEO
if not "%v_path:~-1%"=="\" (
	set "v_path_1=%v_path%\"
) else set "v_path_1=%v_path%"
set "vid_num=%~1"
set "zero_loop=0"
if "%instr[1]%"=="1" goto :end_add_zero
:add_zero
set "vid_num_r=%vid_num%"
set "vid_num=00000000000000000000000%vid_num%"
set "vid_num=!vid_num:~-%instr[1]%!"
:end_add_zero
set "not_work="
for /f "tokens=*" %%a in ('set /a instr[0]+instr[1]') do (
	set "vid_path=!filter:~0,%instr[0]%!%vid_num%!filter:~%%~a!"
	set "vid_path_1=!filter:~0,%instr[0]%!%vid_num_r%!filter:~%%~a!"
)
for /f "tokens=*" %%a in ("%v_path_1%%vid_path%") do (
	if exist "%%~a" (
		set "video=%%~a"
		echo [VGET] 匹配到视频"%%~nxa"
		goto got_video
	)
)
for /f "tokens=*" %%a in ("%v_path_1%%vid_path_1%") do (
	if exist "%%~a" (
		set "video=%%~a"
		echo [VGET] 匹配到视频"%%~nxa"
		goto got_video
	)
)
echo [ERR_] 未能匹配到视频
set "not_work=0"
:got_video
goto :EOF

rem call :SEARCH_ASS "[sub_path]" "[filter]" "[ep_num]" "[sub-dir][y/n] [unset]"
:SEARCH_ASS
set "ass_path=%~1"
if not "%~2"=="" ( 
	rem for /f "tokens=* delims=^|" %%a in ("%s_filter%") do (
	rem	call :CHECK_EXT "%%~xa" "n"
	rem )
	set "s_filter=%~2" 
) else set "s_filter=*.ass"
if /i "%~4"=="y" (
	set "ass_subdir=0"
) else set "ass_subdir="

if not exist "%~1" (
	echo [ERROR] Subtitles Path No Found
	pause
	goto :EOF
)
set "sub_num=%~3"
set "zero_loop=0"
if "%s_instr[1]%"=="1" goto :end_s_add_zero
:s_add_zero
set "sub_num_r=%sub_num%"
set "sub_num=00000000000000000000000%sub_num%"
set "sub_num=!sub_num:~-%s_instr[1]%!"
:end_s_add_zero
for /f "tokens=*" %%a in ('set /a s_instr[0]+s_instr[1]') do (
	set "s_path=!s_filter:~0,%s_instr[0]%!%sub_num%!s_filter:~%%~a!"
	set "s_path_1=!s_filter:~0,%s_instr[0]%!%sub_num_r%!s_filter:~%%~a!"
)
for /r "%ass_path%" %%a in ("%s_path%") do (
	if exist "%%~a" (
		echo [SGET] 匹配到字幕"%%~nxa"
		if defined ass_subdir (
			if "%%~dpa"=="%ass_path%" (
				call :preview_sub "%%~a"
			) else (
				echo [ERR_] 匹配字幕不在目录下
			)
		) else (
			call :preview_sub "%%~a"
		)
		goto got_sub
	)
)
for /r "%ass_path%" %%a in ("%s_path_1%") do (
	if exist "%%~a" (
		echo [SGET] 匹配到字幕"%%~nxa"
		if defined ass_subdir (
			if "%%~dpa"=="%ass_path%" (
				call :preview_sub "%%~a"
			) else (
				echo [ERR_] 匹配字幕不在目录下
			)
		) else (
			call :preview_sub "%%~a"
		)
		goto got_sub
	)
)
echo [ERR_] 未能匹配到字幕
:got_sub
goto :EOF
:rename_sub
rename "%~1" "%~nx2"
if not exist "%~2" (
	echo [ERR_] 未能重命名字幕"%~nx1"
) else (
	echo [REN_] 成功重命名字幕"%~nx2"
	echo "%~2"^|"%~nx1">>"%ass_path%undo_rename.log"
)
goto :EOF
:preview_sub
for /f "tokens=*" %%a in ("%video%") do (
	(echo "%~nx1"
	echo --^> "%%~na%s_rem%%~x1"
	echo.)>>"%ass_path%rename_preview.log"
	echo "%~1"^|"%ass_path%%%~na%s_rem%%~x1">>"%ass_path%rename_log.log"
)
goto :EOF

:Module_AUTO-SEARCH
:AUTO
echo [AUTO] 自动搜索模块 VER1.0 Alpha

set "subext=ass;ssa;srt;idx;pgs;sup;smi;"
set "vidext=mp4;m4v;mkv;m2ts;avi;mpeg;mpg;"

:ToLIST
echo [LIST] 正在转换扩展名表
set "ass_loop=0"
set "ass_count=0"
set "ass_start=0"
:GET_EXT_LOOP_ASS
set "a_char=!subext:~%ass_loop%,1!"
if "%a_char%"=="" goto :END_GET_EXT_LOOP_ASS
if not "%a_char%"==";" (
	set /a ass_loop=ass_loop+1
	goto GET_EXT_LOOP_ASS
)
for /f "tokens=*" %%a in ('set /a ass_loop-ass_start') do (
	set "subext[%ass_count%]=.!subext:~%ass_start%,%%~a!"
)
set /a ass_count=ass_count+1
set /a ass_loop=ass_loop+1
set "ass_start=%ass_loop%"
goto :GET_EXT_LOOP_ASS

:END_GET_EXT_LOOP_ASS

set "ass_loop=0"
set "ass_count=0"
set "ass_start=0"
:GET_EXT_LOOP_VIDEO
set "a_char=!vidext:~%ass_loop%,1!"
if "%a_char%"=="" goto :END_GET_EXT_LOOP_VIDEO
if not "%a_char%"==";" (
	set /a ass_loop=ass_loop+1
	goto GET_EXT_LOOP_VIDEO
)
for /f "tokens=*" %%a in ('set /a ass_loop-ass_start') do (
	set "vidext[%ass_count%]=.!vidext:~%ass_start%,%%~a!"
)
set /a ass_count=ass_count+1
set /a ass_loop=ass_loop+1
set "ass_start=%ass_loop%"
goto :GET_EXT_LOOP_VIDEO

:END_GET_EXT_LOOP_VIDEO

echo [LIST] Complete making EXT lists.
set "rf=%~dp0auto_rename\"
if not exist "%rf%" mkdir "%rf%" 1>nul 2>nul

:AUTO_MAIN
del /q "%rf%*.log" 2>nul
cls
title %bat_ver% ^| 自动匹配视频规则中...
call :try_video
cls
title %bat_ver% ^| 自动匹配字幕规则中...
del /q "%rf%*.log" 2>nul
call :try_subtitles
cls
del /q "%rf%*.log" 2>nul
rmdir "%rf%" 2>nul
echo [AUTO] 自动视频匹配规则: "%filter%"
echo [AUTO] 自动字幕匹配规则: "%s_filter%"
goto AUTO_BACK

:try_video
echo [WORK] 正在匹配视频...
for /f "tokens=1* delims==" %%a in ('set vidext[') do (
	for /r "%v_path%" %%c in ("*%%~b") do (
		if exist "%%~c" (
			echo [%%~b] 在目录中找到文件"%%~nxc"
			echo "%%~nxc">>"%rf%%%~a.log"
		)
	)
	if not exist "%rf%%%~a.log" (
		set "count_v_%%~a=0"
		echo;>"%rf%%%~a.log"
	)
)
set "log_count=0"
for /r "%rf%" %%a in ("*.log") do set /a log_count=log_count+1
if not %log_count% GTR 0 (
	echo [ERRA] 找不到视频
	goto MAIN
)
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
set "largest_vid=%l_largest:~14%"
echo [LSTR] 正在计算文件名长度
for /f "tokens=1* delims==" %%a in ('set log_v_%l_largest:~8%') do (
	call :cut_string "%%~b" "%%~a"
)
echo [NAPR] 正在选择出现次数最多的文件名长度
call :list_appear "long_v%largest_vid%"
call :list_appear_most "long_v%largest_vid%" "num_appear"
echo [LIST] 正在列表文件名
for /f "tokens=1* delims==" %%a in ('set long_v') do (
	if "%%~b"=="%appear_most%" (
		call :cut_string_2 "%%~a"
	)
)

echo [COMP] 列表内差异计算
call :compare_list "c_v" "%count_range%"
call :list_appear "comp_diff"
call :list_appear_most "comp_diff" "num_appear"
echo [CHKN] 容差值计算 ±2
for /f "tokens=1* delims==" %%a in ('set comp_diff%l_largest:~12%') do (
	for /f "tokens=1,2 delims=," %%c in ("%%~b") do (
		for /f "tokens=1* delims==" %%e in ('set comp_diff') do (
			for /f "tokens=1,2 delims=," %%g in ("%%~f") do (
				call :check_num "%%~g" "%%~c,2" "%%~e" "c_v"
				call :check_num "%%~h" "%%~d,1" "%%~e" "c_v"
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
set "filter=!vf:~0,%vf_s%!"
call :add_char "?" "%vf_c%" "filter"
set "filter=%filter%*%vf_x%"
echo [V_FI] 计算出视频过滤规则"%filter%"
call :clear_list "comp_diff_1"
call :clear_list "comp_diff_2"
call :clear_list "comp_diff"
call :clear_list "v_diff"
call :clear_list "count_v_vidext" 

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
for /f "tokens=1* delims==" %%a in ('set subext[') do (
	for /r "%sub_path%" %%c in ("*%%~b") do (
		if exist "%%~c" (
			echo [%%~b] 在目录中找到文件"%%~nxc"
			echo "%%~nxc">>"%rf%%%~a.log"
		)
	)
	if not exist "%rf%%%~a.log" (
		set "count_s_%%~a=0"
		echo;>"%rf%%%~a.log"
	)
)
set "log_count=0"
for /r "%rf%" %%a in ("*.log") do set /a log_count=log_count+1
if not %log_count% GTR 0 (
	echo [ERRA] 找不到字幕
	goto MAIN
)
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
		call :list_largest "count_s_subext" "%%~1"
	) else (
		for /f "tokens=1* delims==" %%b in ('set count_s_subext[') do (
			set "l_largest=%%~b"
		)
	)
)
set "largest_sid=%l_largest:~14%"
echo [LSTR] 正在计算文件名长度
for /f "tokens=1* delims==" %%a in ('set log_s_%l_largest:~8%') do (
	call :cut_string_s "%%~b" "%%~a"
)
echo [NAPR] 正在选择出现次数最多的文件名长度
call :list_appear "long_s%largest_sid%"
call :list_appear_most "long_s%largest_sid%" "num_appear"
echo [LIST] 正在列表文件名
for /f "tokens=1* delims==" %%a in ('set long_s') do (
	if "%%~b"=="%appear_most%" (
		call :cut_string_s_2 "%%~a"
	)
)

echo [COMP] 列表内差异计算
call :compare_list "c_s" "%count_range%"
call :list_appear "comp_diff"
call :list_appear_most "comp_diff" "num_appear"
echo [CHKN] 容差值计算 ±2
for /f "tokens=1* delims==" %%a in ('set comp_diff%l_largest:~12%') do (
	for /f "tokens=1,2 delims=," %%c in ("%%~b") do (
		for /f "tokens=1* delims==" %%e in ('set comp_diff') do (
			for /f "tokens=1,2 delims=," %%g in ("%%~f") do (
				call :check_num "%%~g" "%%~c,2" "%%~e" "c_s"
				call :check_num "%%~h" "%%~d,1" "%%~e" "c_s"
			)
		)
	)
)
echo [LIST] 开始制表文件名
for /f "tokens=1* delims==" %%a in ('set comp_diff') do (
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
call :add_char "?" "%sf_c%" "s_filter"
set "s_filter=%s_filter%*%sf_x%"
echo [V_FI] 计算出字幕过滤规则"%s_filter%"
call :clear_list "comp_diff_1"
call :clear_list "comp_diff_2"
call :clear_list "comp_diff"
call :clear_list "count_s_subext" 
call :clear_list "s_diff"
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

rem call :long_string "[string]" "[return]"
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
echo [LSTR] 返回"%~2"，长度为"%string_long%"
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
call :list_appear "str_diff"
call :list_appear_most "str_diff" "num_appear"
for /f "tokens=1* delims==" %%a in ('set str_diff%l_largest:~12%') do (
	echo [COMP] 差异位置与差异值为"%%~b"
	call :number_list "comp_diff" "%%~b"
)
set "comp_count="
goto :EOF
:check_selcount
if "%comp_count%"=="%selcount%" set "selcount_ok=0"
goto :EOF
:compare_char
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
set "comp_1=!in_comp:~%ccl_count%,%com_step%!"
set "comp_2=!in_comp2:~%ccl_count%,%com_step%!"
if "%comp_1%"=="" goto list_compare_diff
if "%comp_2%"=="" goto list_compare_diff
if not "%comp_1%"=="%comp_2%" (
	if not defined diff_in (
		set "diff_in=%ccl_count%"
	)
	call :compare_char_range
	goto compare_char_loop
)
if defined diff_in if "%comp_1%"=="%comp_2%" (
	goto list_compare_diff
)
goto compare_char_loop
:list_compare_diff
if defined diff_count if defined diff_in (
	echo - 发现差异于"%diff_in%,%diff_count%"
	call :number_list "str_diff" "%diff_in%,%diff_count%"
)
goto :EOF
:compare_char_range
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

rem call :check_path_cmd
:check_path_cmd
cmd /c if "%v_path%"=="%v_path%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "v_path=%v_path%"
	goto :EOF
)

cmd /c if "%v_path:~1%"=="%v_path:~1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "v_path=%v_path:~1%"
	goto :EOF
)

cmd /c if "%v_path:~0,-1%"=="%v_path:~0,-1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "v_path=%v_path:~0,-1%"
	goto :EOF
)

cmd /c if "%v_path:~1,-1%"=="%v_path:~1,-1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "v_path=%v_path:~1,-1%"
	goto :EOF
)

echo [ERRV] 不受支持的非法路径
echo [INFO] 可能是您的路径中含有非法字符
set "path_inv=1"
goto :EOF

rem call :check_path_cmd
:check_path_cmd_s
cmd /c if "%sub_path%"=="%sub_path%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "sub_path=%sub_path%"
	goto :EOF
)

cmd /c if "%sub_path:~1%"=="%sub_path:~1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "sub_path=%sub_path:~1%"
	goto :EOF
)

cmd /c if "%sub_path:~0,-1%"=="%sub_path:~0,-1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "sub_path=%sub_path:~0,-1%"
	goto :EOF
)

cmd /c if "%sub_path:~1,-1%"=="%sub_path:~1,-1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "sub_path=%sub_path:~1,-1%"
	goto :EOF
)

echo [ERRV] 不受支持的非法路径
echo [INFO] 可能是您的路径中含有非法字符
set "path_inv=1"
goto :EOF