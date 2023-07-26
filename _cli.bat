@echo off
@set ROOT=%~dp0..\
@for %%I in (.) do set CurrDirName=%%~nxI
@for /f "eol=- delims=" %%a in (container.conf) do set "%%a"
@set CONTAINER=%container%
ECHO Starting %container% in commandline
docker.exe run -it --rm -v %cd%:/work/%CurrDirName% -w /work/%CurrDirName% %CONTAINER% sh
pause