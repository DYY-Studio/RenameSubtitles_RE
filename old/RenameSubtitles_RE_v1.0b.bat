@echo off
rem chcp 65001
:DEBUG
if not defined debug (
	echo [M_DE] ��������DEBUG��
	set "debug=1"
	cmd /c "%~0"
	set "debug="
	echo [M_DE] ���н���
	pause
	goto :EOF
)
title RenameSubtitles RE: Ver1.0 Beta ^| yyfll-GB2312
echo [INFO] RenameSubtitles RE: Ver1.0 Beta
echo [INFO] Copyright(c) 2019 yyfll

setlocal EnableDelayedExpansion

:MAIN
echo.
echo [ ��ƵĿ¼ ]
set /p path=[V_IN] V_PATH: 
if exist "%path%" (
	for /f "tokens=*" %%a in ("%path%") do set "chk_vpath=%%~aa"
) else (
	cls
	echo [ERRV] �Ҳ�����ƵĿ¼
	goto MAIN
)
if not "%chk_vpath:~0,1%"=="d" (
	cls
	echo [ERRV] �����Ӧ��Ŀ¼����Ӧ���ļ�
	goto MAIN
)
echo.
echo [ ��ĻĿ¼������Ĭ��ͬ��ƵĿ¼�� ]
set /p sub_path=[S_IN] S_PATH: 
if not defined sub_path set "sub_path=%path%"
if exist "%sub_path%" (
	for /f "tokens=*" %%a in ("%sub_path%") do set "chk_spath=%%~aa"
) else (
	cls
	echo [ERRS] �Ҳ�����ĻĿ¼
	goto MAIN
)
if not "%chk_spath:~0,1%"=="d" (
	cls
	echo [ERRS] �����Ӧ��Ŀ¼����Ӧ���ļ�
	goto MAIN
)
echo.
echo [ ƥ��������ƥ����Ƶ ���ð���ʺŴ��漯��   ]
echo [ ����[CASO][El_Cazador][GB_BIG5][01][DVDRIP]   ]
echo [ �滻��[CASO][El_Cazador][GB_BIG5][??][DVDRIP] ]
echo [ �����Ƶ�зǳ��鷳����У��ֵ���ļ�����β      ]
echo [ ��ʹ��ͨ��� ��[CASO][*][GB_BIG5][??][*       ]
echo [ ��Ƶƥ����� ]
set /p filter=[V_FI] V_FILTER: 
echo.
echo [ ��Ļƥ����� ]
set /p s_filter=[S_FI] S_FILTER: 
echo.
echo [ �缯��Χ���ǴӶ��ټ������ټ� ���� 1,24 ��ʾ   ]
echo [ �缯��Χ ]
set /p ep=[EP_R] EP_Range: 
echo.
echo [ ��Ļע����Ϣ���ļ���������� .CASO-sc ������  ]
echo [ �������ڱ�ʾ��Ļ������Ļ���Ե��ı� ����ע��   ]
echo [ ��[YYDM-11FANS][Rozen Maiden][01].CASO-sc.ass ]
echo [ ��Ļע�ͣ��������գ� ]
set /p s_rem=[SANN] S_Annotate: 
if defined s_rem if not "%s_rem:~0,1%"=="." set "s_rem=.%s_rem%"
echo.
echo [ ������Ŀ¼�� ����ָ����ĻĿ¼֮�µ�����Ŀ¼   ]
echo [ ���������Ļ�ļ��е��»�������������Ļ ���Ƽ� ]
echo [ һ��ƥ�������������ѡ�� �����о����Ƿ����� ]
echo [ ��Ŀ¼������y����^/nͣ�ã���ȱĬ��n�� ]
set /p ass_subdir=[SDIR] S_Dir: 
pause
if not defined ass_subdir set "ass_subdir=n"
if /i not "%ass_subdir%"=="y" if /i not "%ass_subdir%"=="n" (
	cls
	echo [ERR_] ѡ��������� ��������"y"��"n"
	goto MAIN
)

cls

echo [WORK] ����ƥ�������Ѱ�Ҿ缯λ��...
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
echo [VINS] ����Ƶƥ��������ҵ�λ��%instr[0]%������%instr[1]%

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
echo [SINS] ����Ļƥ��������ҵ�λ��%s_instr[0]%������%s_instr[1]%
echo.

:LOOP_NUM
for /f "tokens=1,2 delims=," %%a in ("%ep%") do (
	for /l %%c in (%%~a,1,%%~b) do (
		echo [LOOP] ����ƥ��缯%%~c
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
		echo [VGET] ƥ�䵽��Ƶ"%%~nxa"
		goto got_video
	)
)
echo [ERR_] δ��ƥ�䵽��Ƶ
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
		echo [SGET] ƥ�䵽��Ļ"%%~nxa"
		if defined ass_subdir (
			if "%%~dpa"=="%ass_path%" (
				call :rename_sub
			) else (
				echo [ERR_] ƥ����Ļ����Ŀ¼��
			)
		) else (
			call :rename_sub
		)
		goto got_sub
	)
)
echo [ERR_] δ��ƥ�䵽��Ļ
:got_sub
goto :EOF
:rename_sub
for /f "tokens=*" %%b in ("%video%") do (
	rename "%%~a" "%%~nb%s_rem%%%~xa"
	if not exist "%ass_path%%%~nb%s_rem%%%~xa" (
		echo [ERR_] δ����������Ļ
	) else (
		echo [REN_] �ɹ���������Ļ
		echo "%ass_path%%%~nb%s_rem%%%~xa"^|"%%~a">>"%ass_path%undo_rename.log"
	)
	echo.
)
goto :EOF