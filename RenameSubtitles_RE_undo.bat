@echo off
:Module_DEBUG
if not defined debug (
	echo [M_DE] 正在启动DEBUG层
	set "debug=1"
	cmd /c call "%~0" "%~1"
	set "debug="
	title %ComSpec%
	echo [M_DE] 运行结束
	pause
	goto :EOF
)
title RenameSubtitles RE: UNDOv1.0
echo [INFO] RenameSubtitles RE: UNDOv1.0
echo [INFO] Copyright(c) 2019 yyfll
echo.
if not "%~1"=="" if exist "%~1" (
	set "undof=%~1"
	echo [F_IN] 自动设定为"%~1"
)
if not defined undof set /p undof=[F_IN] UNDO文件路径:

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

echo [ERRU] 不受支持的非法路径
echo [INFO] 可能是您的路径中含有非法字符
goto :EOF

:fexist
for /f "tokens=*" %%a in ("%undof%") do if not "%%~nxa"=="undo_rename.log" (
	echo [ERRU] 文件名错误
	goto :EOF
)

for /f "usebackq tokens=1,2 delims=^|" %%a in ("%undof%") do (
	if exist "%%~a" (
		rename "%%~a" "%%~b"
		if exist "%%~dpa%%~b" (
			echo [SUCC] 成功重命名"%%~b"
		) else echo [FAIL] 无法重命名"%%~nxa"
	) else echo [FAIL] 找不到文件"%%~nxa"
)
echo.
pause
goto :EOF