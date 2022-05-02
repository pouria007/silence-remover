@echo off
set filename=%1
set cutDB=%2

if defined filename (goto cutoff) else (goto error1)

:cutoff
if defined cutDB (goto predifined) else (goto autodefine)

:autodefine
SET /A a = 5 
SETLOCAL
call :finddb meanDB
echo The meanDB is %meanDB%
SET /A cutDB=meanDB-17
echo The cutDB is %cutDB%
goto :main

:predifined
SETLOCAL
call :finddb meanDB
echo The meanDB is %meanDB%
echo The cutDB is %cutDB%
goto :main

:main
ffmpeg.exe -i %filename% -af silenceremove=stop_periods=-1:stop_duration=0.1:stop_threshold="%cutDB%"dB "trimmed%cutDB%_%filename%.mp3"
goto :EOF

:error1
echo Please enter the file name. Example: silence-remover.bat input.mp3
goto :EOF

:finddb


for /F "tokens=5" %%f in ('ffmpeg.exe -i %filename% -af "volumedetect" -vn -sn -dn -f null /dev/null 2^>^&1 ^| findstr /i /r /c:"mean.*dB"') DO (
  set count=%%f
)
set %1=%count%
EXIT /B 0