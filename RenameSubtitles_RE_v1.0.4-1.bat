@echo off
rem chcp 65001
:DEBUG
if not defined debug (
	echo [M_DE] ��������DEBUG��
	set "debug=1"
	cmd /c call "%~0"
	set "debug="
	title %ComSpec%
	echo [M_DE] ���н���
	pause
	goto :EOF
)

rem [count_range]
rem ����compare_list���бȽϵ����������Լӿ�AUTO��������������
set "count_range=15"
rem ����ֵ 
rem 	{1~n(�Ǹ�����)}����0��ʼ��������=15ʱ��Ƚ�16�
rem 	{����}�������ã���ȫ��Ŀ������
rem �Ƽ�ֵ
rem 	{10~20}������������10��
rem 	{��100}�����ڼ�������100�ģ�

rem [ls_step]
rem ����long_stringÿһѭ���������ַ�����ֵԽ��Գ��ַ����ļ�����Խ�죬���Զ��ַ�����Խ��
set "ls_step=5"
rem ����ֵ
rem 	{1~n(�Ǹ�����)}
rem �Ƽ�ֵ
rem 	{5~10}

rem [com_step]
rem ����compare_stringÿһѭ���������ַ�����ֵԽ��Գ��ַ����ļ�����Խ�죬���Զ��ַ�����Խ��
set "com_step=5"
rem ����ֵ
rem 	{1~n(�Ǹ�����)}
rem �Ƽ�ֵ
rem 	{5~10}

set "bat_ver=RenameSubtitles RE: Ver1.0.4 GB2312"
title %bat_ver% [(c) yyfll]
echo [INFO] %bat_ver%
echo [INFO] Copyright(c) 2019 yyfll

setlocal EnableDelayedExpansion

:MAIN
echo.
echo [ ��ƵĿ¼ ]
set /p v_path=[V_IN] V_PATH: 
rem goto v_check_end
echo [CHKV] ���ڼ����ƵĿ¼CMD�����Լ�������
call :check_path_cmd
if defined path_inv (
	set "path_inv="
	goto MAIN
)
if not exist "%v_path%" (
	echo [V_EX] �Ҳ�����Ƶ·��
	goto MAIN
)
echo [CHKV] ��ƵĿ¼ȷ�ϳɹ�

:MAIN_S
echo.
echo [ ��ĻĿ¼������Ĭ��ͬ��ƵĿ¼�� ]
set /p sub_path=[S_IN] S_PATH: 
if not defined sub_path (
	echo [VOID] �Զ�������ƵĿ¼
	set "sub_path=%v_path%"
	goto s_check_end
)

echo [CHEK] ���ڼ����ĻĿ¼CMD�����Լ�������
echo.
rem goto s_check_end

call :check_path_cmd_s
if defined path_inv (
	set "path_inv="
	goto MAIN_S
)
if not exist "%sub_path%" (
	echo [S_EX] �Ҳ�����Ļ·��
	goto MAIN_S
)

echo [CHKS] ��ĻĿ¼ȷ�ϳɹ�
:s_check_end
echo.
echo [ �Զ�����ƥ����� ��ͨ�������ļ���Ѱ��ƥ����� ]
echo [ ���������������Ƚϼ� ���������ʱȽϴ�     ]
echo [ �����Զ� �ǳ����� �ǳ����� �ǳ����� �ǳ�����  ]
echo [ ���Ǻ������˷ǳ��ǳ��ǳ������ֶ�����ƥ�����  ]
echo [ Ԥ��ʱ�� Լ6�������13������ �� ���2DuoP8400 ]
echo [ �Զ�ƥ�� ��[y]����/[n]�����ԣ� ]
set /p auto=[AUTO] Auto[y/n]?: 
if /i "%auto%"=="y" (
	goto AUTO_POINT
) else if /i "%auto%"=="n" (
	set "auto="
) else (
	set "auto="
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
:AUTO_POINT
if defined auto (
	cls
	echo ���Զ�����֮ǰ��������Ҫ����дһЩ��Ҫ��Ϣ
	echo.
)
echo [ �缯��Χ���ǴӶ��ټ������ټ� ���� 1,24 ��ʾ   ]
echo [ ���ҵ�Ƭ��52�� �ӵ�01����ʼ ��ô�Ҿ�д1,52    ]
echo [ ע�����Ҫ�ð�Ƕ��� , ���򲻱�ʶ��           ]
:re_get_ep
echo [ �缯��Χ ]
set /p ep=[EP_R] EP_Range: 
for /f "tokens=1,2 delims=," %%a in ("%ep%") do (
	if "%%~a"=="" (
		echo [ERRE] �缯��������
		goto re_get_ep
	)
	if "%%~b"=="" (
		echo [ERRE] �缯��������
		goto re_get_ep
	)
)
echo.
echo [ ��Ļע����Ϣ���ļ���������� .CASO-sc ������  ]
echo [ �������ڱ�ʾ��Ļ������Ļ���Ե��ı� ����ע��   ]
echo [ ��[YYDM-11FANS][Rozen Maiden][01].CASO-sc.ass ]
echo [ ��Ļע�ͣ��������գ� ]
set /p s_rem=[SANN] S_Annotate: 
if not defined s_rem goto norem_sub
if not "%s_rem%"=="" if not "%s_rem:~0,1%"=="." set "s_rem=.%s_rem%"
:norem_sub
if defined auto goto AUTO
echo.
echo [ ������Ŀ¼�� ����ָ����ĻĿ¼֮�µ�����Ŀ¼   ]
echo [ ���������Ļ�ļ��е��»�������������Ļ ���Ƽ� ]
echo [ һ��ƥ�������������ѡ�� �����о����Ƿ����� ]
echo [ ��Ŀ¼������[y]����^/[n]ͣ�ã� ]
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

if not "%sub_path:~0,-1%"=="\" set "sub_path=%sub_path%\"
if exist "%sub_path%undo_rename.log" del /q "%sub_path%undo_rename.log"
if exist "%sub_path%rename_preview.log" del /q "%sub_path%rename_preview.log"
if exist "%sub_path%rename_log.log" del /q "%sub_path%rename_log.log"
:LOOP_NUM
title %bat_ver% ^| ��Ƶ��Ļƥ����...
for /f "tokens=1,2 delims=," %%a in ("%ep%") do (
	for /l %%c in (%%~a,1,%%~b) do (
		echo [LOOP] ����ƥ��缯%%~c
		call :SEARCH_VIDEO "%%~c"
		if not defined not_work (
			call :SEARCH_ASS "%sub_path%" "%s_filter%" "%%~c" "%ass_subdir%"
		) else set "not_work="
	)
)

if not exist "%sub_path%rename_preview.log" (
	echo [ERR_] �Ҳ���ƥ�����������
	goto end_batch
)
if not exist "%sub_path%rename_log.log" (
	echo [ERR_] �Ҳ���ƥ�����������
	goto end_batch
)

:preview_check
cls
title %bat_ver% ^| ������Ԥ��
echo [PREV] ������Ԥ��
echo.
type "%sub_path%rename_preview.log"
echo [PREV] Ԥ����ʾ���
choice /M "[CHK_] Ҫִ����������������"
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
		echo [VGET] ƥ�䵽��Ƶ"%%~nxa"
		goto got_video
	)
)
for /f "tokens=*" %%a in ("%v_path_1%%vid_path_1%") do (
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
		echo [SGET] ƥ�䵽��Ļ"%%~nxa"
		if defined ass_subdir (
			if "%%~dpa"=="%ass_path%" (
				call :preview_sub "%%~a"
			) else (
				echo [ERR_] ƥ����Ļ����Ŀ¼��
			)
		) else (
			call :preview_sub "%%~a"
		)
		goto got_sub
	)
)
for /r "%ass_path%" %%a in ("%s_path_1%") do (
	if exist "%%~a" (
		echo [SGET] ƥ�䵽��Ļ"%%~nxa"
		if defined ass_subdir (
			if "%%~dpa"=="%ass_path%" (
				call :preview_sub "%%~a"
			) else (
				echo [ERR_] ƥ����Ļ����Ŀ¼��
			)
		) else (
			call :preview_sub "%%~a"
		)
		goto got_sub
	)
)
echo [ERR_] δ��ƥ�䵽��Ļ
:got_sub
goto :EOF
:rename_sub
rename "%~1" "%~nx2"
if not exist "%~2" (
	echo [ERR_] δ����������Ļ"%~nx1"
) else (
	echo [REN_] �ɹ���������Ļ"%~nx2"
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
echo [AUTO] �Զ�����ģ�� VER1.0 Alpha

set "subext=ass;ssa;srt;idx;pgs;sup;smi;"
set "vidext=mp4;m4v;mkv;m2ts;avi;mpeg;mpg;"

:ToLIST
echo [LIST] ����ת����չ����
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
title %bat_ver% ^| �Զ�ƥ����Ƶ������...
call :try_video
cls
title %bat_ver% ^| �Զ�ƥ����Ļ������...
del /q "%rf%*.log" 2>nul
call :try_subtitles
cls
del /q "%rf%*.log" 2>nul
rmdir "%rf%" 2>nul
echo [AUTO] �Զ���Ƶƥ�����: "%filter%"
echo [AUTO] �Զ���Ļƥ�����: "%s_filter%"
goto AUTO_BACK

:try_video
echo [WORK] ����ƥ����Ƶ...
for /f "tokens=1* delims==" %%a in ('set vidext[') do (
	for /r "%v_path%" %%c in ("*%%~b") do (
		if exist "%%~c" (
			echo [%%~b] ��Ŀ¼���ҵ��ļ�"%%~nxc"
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
	echo [ERRA] �Ҳ�����Ƶ
	goto MAIN
)
for /r "%rf%" %%a in ("*.log") do (
	echo [CONT] ���ڼ���"%%~a"
	for /f "usebackq tokens=*" %%b in ("%%~a") do (
		call :number_list "log_v_%%~na" "%%~b"
		set /a count_v_%%~na=count_v_%%~na+1
	)
)
echo [LARG] �����б���Ѱ������������չ��
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
echo [LSTR] ���ڼ����ļ�������
for /f "tokens=1* delims==" %%a in ('set log_v_%l_largest:~8%') do (
	call :cut_string "%%~b" "%%~a"
)
echo [NAPR] ����ѡ����ִ��������ļ�������
call :list_appear "long_v%largest_vid%"
call :list_appear_most "long_v%largest_vid%" "num_appear"
echo [LIST] �����б��ļ���
for /f "tokens=1* delims==" %%a in ('set long_v') do (
	if "%%~b"=="%appear_most%" (
		call :cut_string_2 "%%~a"
	)
)

echo [COMP] �б��ڲ������
call :compare_list "c_v" "%count_range%"
call :list_appear "comp_diff"
call :list_appear_most "comp_diff" "num_appear"
echo [CHKN] �ݲ�ֵ���� ��2
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
echo [LIST] ��ʼ�Ʊ��ļ���
for /f "tokens=1* delims==" %%a in ('set comp_diff') do (
	call :make_list "%%~a" "%%~b" "c_v" "9"
)
set "list_count=-1"
for /f "tokens=*" %%a in ('set v_diff') do (
	set /a list_count=list_count+1
)
echo [LIST] �Ʊ����ֵ
for /l %%a in (0,1,%list_count%) do (
	for /f "tokens=1* delims==" %%b in ('set v_diff[%%~a]') do (
		for /f "tokens=1,2,3 delims=," %%d in ("%%~c") do (
			set "comp_diff_1[%%~a]=%%~d"
			set "comp_diff_2[%%~a]=%%~e"
		)
	)
)

echo [MINI] ����λ������Сֵ
call :list_minimum "comp_diff_1" "%list_count%"
echo [MINI] ����λ��"%n_minimum%"��λ�ڱ�"%l_minimum%"
echo [MAXN] �����������ֵ
call :list_largest "comp_diff_2" "%list_count%"
echo [MAXN] ������"%n_largest%"��λ�ڱ�"%l_largest%"

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
echo [V_FI] �������Ƶ���˹���"%filter%"
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
echo [WORK] ����ƥ����Ļ...
for /f "tokens=1* delims==" %%a in ('set subext[') do (
	for /r "%sub_path%" %%c in ("*%%~b") do (
		if exist "%%~c" (
			echo [%%~b] ��Ŀ¼���ҵ��ļ�"%%~nxc"
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
	echo [ERRA] �Ҳ�����Ļ
	goto MAIN
)
for /r "%rf%" %%a in ("*.log") do (
	echo [CONT] ���ڼ���"%%~a"
	for /f "usebackq tokens=*" %%b in ("%%~a") do (
		call :number_list "log_s_%%~na" "%%~b"
		set /a count_s_%%~na=count_s_%%~na+1
	)
)
echo [LARG] �����б���Ѱ������������չ��
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
echo [LSTR] ���ڼ����ļ�������
for /f "tokens=1* delims==" %%a in ('set log_s_%l_largest:~8%') do (
	call :cut_string_s "%%~b" "%%~a"
)
echo [NAPR] ����ѡ����ִ��������ļ�������
call :list_appear "long_s%largest_sid%"
call :list_appear_most "long_s%largest_sid%" "num_appear"
echo [LIST] �����б��ļ���
for /f "tokens=1* delims==" %%a in ('set long_s') do (
	if "%%~b"=="%appear_most%" (
		call :cut_string_s_2 "%%~a"
	)
)

echo [COMP] �б��ڲ������
call :compare_list "c_s" "%count_range%"
call :list_appear "comp_diff"
call :list_appear_most "comp_diff" "num_appear"
echo [CHKN] �ݲ�ֵ���� ��2
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
echo [LIST] ��ʼ�Ʊ��ļ���
for /f "tokens=1* delims==" %%a in ('set comp_diff') do (
	call :make_list_s "%%~a" "%%~b" "c_s" "9"
)
set "list_count=-1"
for /f "tokens=*" %%a in ('set s_diff') do (
	set /a list_count=list_count+1
)
echo [LIST] �Ʊ����ֵ
for /l %%a in (0,1,%list_count%) do (
	for /f "tokens=1* delims==" %%b in ('set s_diff[%%~a]') do (
		for /f "tokens=1,2,3 delims=," %%d in ("%%~c") do (
			set "comp_diff_1[%%~a]=%%~d"
			set "comp_diff_2[%%~a]=%%~e"
		)
	)
)

echo [MINI] ����λ������Сֵ
call :list_minimum "comp_diff_1" "%list_count%"
echo [MINI] ����λ��"%n_minimum%"��λ�ڱ�"%l_minimum%"
echo [MAXN] �����������ֵ
call :list_largest "comp_diff_2" "%list_count%"
echo [MAXN] ������"%n_largest%"��λ�ڱ�"%l_largest%"

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
echo [V_FI] �������Ļ���˹���"%s_filter%"
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


rem ����ģ���� �����������㷽ʽ��򻯺���
rem �÷�һ��д�ڸú�����ǰһ��
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
echo [LSTR] ����"%~2"������Ϊ"%string_long%"
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
	echo [COMP] ����"%list_count%"������ֵ"%selcount%"���Զ�����Ϊ"%selcount%"
	set "list_count=%selcount%"
)
:compare_list.non_selcount
for /l %%a in (0,1,%list_count%) do (
	if defined %~1[%%~a] for /f "tokens=1* delims==" %%b in ('set %~1[%%~a]') do (
		echo [COMP] ���ڱȽϱ�"%~1"��"%%~a"
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
echo [COMP] ���ڱ�"%~2"�м���"%~1"�Ĳ���ֵ
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
	echo [COMP] ����λ�������ֵΪ"%%~b"
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
	echo - ���ֲ�����"%diff_in%,%diff_count%"
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
echo [CLLT] ���������б�"%~1"
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

echo [ERRV] ����֧�ֵķǷ�·��
echo [INFO] ����������·���к��зǷ��ַ�
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

echo [ERRV] ����֧�ֵķǷ�·��
echo [INFO] ����������·���к��зǷ��ַ�
set "path_inv=1"
goto :EOF