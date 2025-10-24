@echo off
REM Detecteer vrije RAM in KB
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /Value') do set /a freeKB=%%a

REM 90% van vrije RAM berekenen
set /a ramMB=freeKB/1024*9/10

REM Limiteer tot max 8192 MB
if %ramMB% gtr 8192 set ramMB=8192

REM Min RAM fallback
if %ramMB% lss 1024 set ramMB=1024

echo Toewijzing: %ramMB% MB RAM

REM Zet JVM argumenten
setx PRISM_RAM_ARGS "-Xms512M -Xmx%ramMB%m"
