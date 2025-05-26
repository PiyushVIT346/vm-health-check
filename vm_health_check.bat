@echo off
setlocal enabledelayedexpansion

REM Check for "explain" argument
set explain=0
if /I "%1"=="explain" set explain=1

REM CPU Usage
for /f "skip=1 tokens=2 delims=," %%a in ('wmic cpu get loadpercentage /value ^| find "="') do (
    set cpu=%%a
)

REM Memory Usage
for /f "skip=1 tokens=2" %%a in ('wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value ^| find "="') do (
    if not defined mem set mem=%%a
    set last=%%a
)
set FreeMem=%mem%
set TotalMem=%last%
REM Convert to float and calculate used percent
set /a UsedMemKB=(TotalMem-FreeMem)
set /a MemUsage=100*UsedMemKB/TotalMem

REM Disk Usage (C: drive, change if needed)
for /f "skip=1 tokens=3" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace,Size /value ^| find "="') do (
    if not defined disk set disk=%%a
    set lastdisk=%%a
)
set FreeDisk=%disk%
set TotalDisk=%lastdisk%
set /a UsedDisk=TotalDisk-FreeDisk
set /a DiskUsage=100*UsedDisk/TotalDisk

REM Health check logic
set status=Healthy
set reason=

if %cpu% gtr 60 (
    set status=Not Healthy
    set reason=!reason!CPU usage is above threshold (%cpu%%%). 
)
if %MemUsage% gtr 60 (
    set status=Not Healthy
    set reason=!reason!Memory usage is above threshold (%MemUsage%%%). 
)
if %DiskUsage% gtr 60 (
    set status=Not Healthy
    set reason=!reason!Disk usage is above threshold (%DiskUsage%%%). 
)

echo Health Status: %status%
if %explain%==1 (
    if "%reason%"=="" (
        echo Reason: All parameters are within healthy limits. CPU: %cpu%%%, Memory: %MemUsage%%%, Disk: %DiskUsage%%%
    ) else (
        echo Reason: %reason%
    )
)
