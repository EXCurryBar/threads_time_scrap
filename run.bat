@echo off
setlocal

REM 設定變數
set "LOCAL_FILE=.\don't touch\main.py"
set "DOWNLOAD_URL=https://example.com/main.py"
set "TEMP_FILE=.\don't touch\temp_main.py"

REM 建立目錄（如果尚未存在）
if not exist ".\don't touch" (
    mkdir ".\don't touch"
)

REM 下載網路上的檔案到臨時位置
bitsadmin /transfer updatejob /download /priority FOREGROUND "%DOWNLOAD_URL%" "%TEMP_FILE%" >nul 2>&1

REM 檢查下載是否成功
if not exist "%TEMP_FILE%" (
    echo 下載失敗
    exit /b 1
)

REM 檢查本地檔案是否存在
if not exist "%LOCAL_FILE%" (
    move "%TEMP_FILE%" "%LOCAL_FILE%" >nul 2>&1
    goto :end
)

REM 使用fc命令比較檔案
fc "%LOCAL_FILE%" "%TEMP_FILE%" >nul 2>&1

REM 根據比較結果決定是否更新
if errorlevel 1 (
    copy "%TEMP_FILE%" "%LOCAL_FILE%" >nul 2>&1
) 

REM 清理臨時檔案
if exist "%TEMP_FILE%" del "%TEMP_FILE%" >nul 2>&1

:end
endlocal
