@echo off
rem 設定檔案路徑和網址
set LOCAL_FILE=".\don't touch\main.py"
set REMOTE_URL="https://raw.githubusercontent.com/EXCurryBar/threads_time_scrap/refs/heads/main/don't touch/main.py"
set TEMP_FILE=%TEMP%\temp_download.py

rem 檢查本地檔案是否存在
if not exist "%LOCAL_FILE%" (
    echo Local file not found, downloading...
    goto DOWNLOAD
)

rem 下載遠端檔案到臨時位置
curl -s -o "%TEMP_FILE%" "%REMOTE_URL%" >nul 2>&1
if errorlevel 1 (
    echo Download failed
    goto CLEANUP
)

rem 比較檔案內容
fc /B "%LOCAL_FILE%" "%TEMP_FILE%" >nul 2>&1
if errorlevel 1 (
    echo Files are different, updating local file...
    goto UPDATE
) else (
    echo Files are identical, no update needed
    goto CLEANUP
)

:UPDATE
copy "%TEMP_FILE%" "%LOCAL_FILE%" >nul 2>&1
if errorlevel 0 (
    echo File updated successfully
) else (
    echo Update failed
)
goto CLEANUP

:DOWNLOAD
curl -s -o "%LOCAL_FILE%" "%REMOTE_URL%" >nul 2>&1
if errorlevel 0 (
    echo File downloaded successfully
) else (
    echo Download failed
)
goto CLEANUP

:CLEANUP
if exist "%TEMP_FILE%" del "%TEMP_FILE%" >nul 2>&1
