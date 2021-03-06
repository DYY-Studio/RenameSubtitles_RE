@echo off
rem chcp 65001
:DEBUG
if not defined debug (
	echo [M_DE] 正在启动DEBUG层
	set "debug=1"
	cmd /c "%~0"
	set "debug="
	echo [M_DE] 运行结束
	pause
	goto :EOF
)
title RenameSubtitles RE: Ver1.0 Beta ^| yyfll-GB2312
echo [INFO] RenameSubtitles RE: Ver1.0 Beta
echo [INFO] Copyright(c) 2019 yyfll

setlocal EnableDelayedExpansion

:MAIN
echo.
echo [ 视频目录 ]
set /p path=[V_IN] V_PATH: 
if exist "%path%" (
	for /f "tokens=*" %%a in ("%path%") do set "chk_vpath=%%~aa"
) else (
	cls
	echo [ERRV] 找不到视频目录
	goto MAIN
)
if not "%chk_vpath:~0,1%"=="d" (
	cls
	echo [ERRV] 输入的应是目录而不应是文件
	goto MAIN
)
echo.
echo [ 字幕目录（留空默认同视频目录） ]
set /p sub_path=[S_IN] S_PATH: 
if not defined sub_path set "sub_path=%path%"
if exist "%sub_path%" (
	for /f "tokens=*" %%a in ("%sub_path%") do set "chk_spath=%%~aa"
) else (
	cls
	echo [ERRS] 找不到字幕目录
	goto MAIN
)
if not "%chk_spath:~0,1%"=="d" (
	cls
	echo [ERRS] 输入的应是目录而不应是文件
	goto MAIN
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
echo [ 剧集范围即是从多少集到多少集 请以 1,24 表示   ]
echo [ 剧集范围 ]
set /p ep=[EP_R] EP_Range: 
echo.
echo [ 字幕注释信息即文件名后跟的如 .CASO-sc 这样的  ]
echo [ 这种用于表示字幕组与字幕语言的文本 就是注释   ]
echo [ 如[YYDM-11FANS][Rozen Maiden][01].CASO-sc.ass ]
echo [ 字幕注释（可以留空） ]
set /p s_rem=[SANN] S_Annotate: 
if defined s_rem if not "%s_rem:~0,1%"=="." set "s_rem=.%s_rem%"
echo.
echo [ 搜索子目录即 搜索指定字幕目录之下的所有目录   ]
echo [ 如果您的字幕文件夹底下还有其他类似字幕 不推荐 ]
echo [ 一般匹配规则可以替代该选项 请自行决定是否启用 ]
echo [ 子目录搜索（y启用^/n停用，空缺默认n） ]
set /p ass_subdir=[SDIR] S_Dir: 
pause
if not defined ass_subdir set "ass_subdir=n"
if /i not "%ass_subdir%"=="y" if /i not "%ass_subdir%"=="n" (
	cls
	echo [ERR_] 选项输入错误 必须输入"y"或"n"
	goto MAIN
)

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

:LOOP_NUM
for /f "tokens=1,2 delims=," %%a in ("%ep%") do (
	for /l %%c in (%%~a,1,%%~b) do (
		echo [LOOP] 尝试匹配剧集%%~c
		call :SEARCH_VIDEO "%%~c"
		if not defined not_work (
			call :SEARCH_ASS "%sub_path%" "%s_filter%" "%%~c" "%ass_subdir%"
		) else set "not_work="
	)
)
setlocal DisableDelayedExpansion
pause
goto :EOF

:SEARCH_VIDEO

set "vid_num=%~1"
set "zero_loop=0"
if "%instr[1]%"=="1" goto :end_add_zero
:add_zero
set "vid_num=00000000000000000000000%vid_num%"
set "vid_num=!vid_num:~-%instr[1]%!"
:end_add_zero
for /f "tokens=*" %%a in ('set /a instr[0]+instr[1]') do (
	set "vid_path=!filter:~0,%instr[0]%!%vid_num%!filter:~%%~a!"
)
for /r "%path%" %%a in ("%vid_path%") do (
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

rem call :SEARCH_ASS "[path]" "[filter]" "[ep_num]" "[sub-dir][y/n] [unset]"
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
if "%s_instr[1]%"=="1" goto :end_add_zero
:s_add_zero
set "sub_num=00000000000000000000000%sub_num%"
set "sub_num=!sub_num:~-%s_instr[1]%!"
:end_s_add_zero
for /f "tokens=*" %%a in ('set /a s_instr[0]+s_instr[1]') do (
	set "s_path=!s_filter:~0,%s_instr[0]%!%sub_num%!s_filter:~%%~a!"
)
if not "%ass_path:~0,-1%"=="\" set "ass_path=%ass_path%\"
if exist "%ass_path%undo_rename.log" del /q "%ass_path%undo_rename.log"
for /r "%ass_path%" %%a in ("%s_path%") do (
	if exist "%%~a" (
		echo [SGET] 匹配到字幕"%%~nxa"
		if defined ass_subdir (
			if "%%~dpa"=="%ass_path%" (
				call :rename_sub
			) else (
				echo [ERR_] 匹配字幕不在目录下
			)
		) else (
			call :rename_sub
		)
		goto got_sub
	)
)
echo [ERR_] 未能匹配到字幕
:got_sub
goto :EOF
:rename_sub
for /f "tokens=*" %%b in ("%video%") do (
	rename "%%~a" "%%~nb%s_rem%%%~xa"
	if not exist "%ass_path%%%~nb%s_rem%%%~xa" (
		echo [ERR_] 未能重命名字幕
	) else (
		echo [REN_] 成功重命名字幕
		echo "%ass_path%%%~nb%s_rem%%%~xa"^|"%%~a">>"%ass_path%undo_rename.log"
	)
	echo.
)
goto :EOF