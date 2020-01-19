@echo off
:Module_DEBUG
if not defined debug (
	echo [M_DE] ��������DEBUG��
	set "debug=1"
	cmd /c call "%~0" "%~1"
	set "debug="
	title %ComSpec%
	echo [M_DE] ���н���
	pause
	goto :EOF
)
title RenameSubtitles RE: UNDOv1.0
echo [INFO] RenameSubtitles RE: UNDOv1.0
echo [INFO] Copyright(c) 2019 yyfll
echo.
if not "%~1"=="" if exist "%~1" (
	set "undof=%~1"
	echo [F_IN] �Զ��趨Ϊ"%~1"
)
if not defined undof set /p undof=[F_IN] UNDO�ļ�·��:

cmd /c if "%undof%"=="%undof%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "undof=%undof%"
	goto fexist
)

cmd /c if "%undof:~1%"=="%undof:~1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "undof=%undof:~1%"
	goto fexist
)

cmd /c if "%undof:~0,-1%"=="%undof:~0,-1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "undof=%undof:~0,-1%"
	goto fexist
)

cmd /c if "%undof:~1,-1%"=="%undof:~1,-1%" echo. 2>NUL
if "%errorlevel%"=="0" (
	set "undof=%undof:~1,-1%"
	goto fexist
)

echo [ERRU] ����֧�ֵķǷ�·��
echo [INFO] ����������·���к��зǷ��ַ�
goto :EOF

:fexist
for /f "tokens=*" %%a in ("%undof%") do if not "%%~nxa"=="undo_rename.log" (
	echo [ERRU] �ļ�������
	goto :EOF
)

for /f "usebackq tokens=1,2 delims=^|" %%a in ("%undof%") do (
	if exist "%%~a" (
		rename "%%~a" "%%~b"
		if exist "%%~dpa%%~b" (
			echo [SUCC] �ɹ�������"%%~b"
		) else echo [FAIL] �޷�������"%%~nxa"
	) else echo [FAIL] �Ҳ����ļ�"%%~nxa"
)
echo.
pause
goto :EOF