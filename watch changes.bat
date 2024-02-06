@echo off
setlocal

set "FILENAME="
set /p FILENAME=Enter the filename to watch: 

set "EXTENSION="
set /p EXTENSION=Enter the extension (e.g., txt, pdf, etc.): 

set "FILE_TO_WATCH=%~dp0%FILENAME%.%EXTENSION%"
if not exist "%FILE_TO_WATCH%" (
    echo File not found!
    exit /b
)

echo Watching %FILE_TO_WATCH% for changes...

:LOOP
timeout /t 1 /nobreak >nul

REM Check if the file still exists
if not exist "%FILE_TO_WATCH%" goto :EOF

REM Get initial last modified date
for %%I in ("%FILE_TO_WATCH%") do set "LAST_MODIFIED=%%~tI"

:CHECK_MODIFICATION
timeout /t 1 /nobreak >nul

REM Get current last modified date
for %%I in ("%FILE_TO_WATCH%") do set "CURRENT_MODIFIED=%%~tI"

REM Compare last modified dates
if "%LAST_MODIFIED%" neq "%CURRENT_MODIFIED%" (
    echo %FILENAME%.%EXTENSION% has been modified. Zipping...
    "%ProgramFiles%\7-Zip\7z.exe" a "%~dp0%FILENAME%.zip" "%FILE_TO_WATCH%"
    echo File zipped as "%~dp0%FILENAME%.zip"
    REM Update last modified date
    set "LAST_MODIFIED=%CURRENT_MODIFIED%"

    REM Open the default mail app with the zip file attached
    powershell -command "Start-Process 'mailto:email@email.com'"

)

goto CHECK_MODIFICATION

endlocal
