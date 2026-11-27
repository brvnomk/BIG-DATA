@echo off
REM =====================================================================
REM  CERAMICAS VALE - Ejecucion automatica del ETL
REM  Ejecuta SQL SCRIPTS\03_ETL_CARGA.sql con sqlcmd y guarda un log.
REM  Copiar este archivo en la carpeta del proyecto (junto a "SQL SCRIPTS")
REM  y programarlo con el Programador de tareas de Windows.
REM  Si tu servidor no es localhost, cambia la linea SERVIDOR (ej. .\SQLEXPRESS)
REM =====================================================================
setlocal
set SERVIDOR=localhost
set CARPETA=%~dp0
if not exist "%CARPETA%logs" mkdir "%CARPETA%logs"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set FECHA=%%i
set LOG=%CARPETA%logs\etl_%FECHA%.log

echo [%date% %time%] Inicio ETL > "%LOG%"
sqlcmd -S %SERVIDOR% -E -C -b -f 65001 -W -i "%CARPETA%SQL SCRIPTS\03_ETL_CARGA.sql" >> "%LOG%" 2>&1
if errorlevel 1 goto error

echo [%date% %time%] ETL finalizado correctamente >> "%LOG%"
exit /b 0

:error
echo [%date% %time%] ERROR en el ETL, revisar este log >> "%LOG%"
exit /b 1
