@echo off

setlocal enableDelayedExpansion

Rem #################################
Rem ## Begin of user-editable part ##
Rem #################################

set "POOL=asia1.ethermine.org:4444"
set "POOL2=asia.ethermine.org:4444" 
set "WALLET=0x6ff85749ffac2d3a36efa2bc916305433fa93731.szz5lix0ffnn5w9"										

set "EXTRAPARAMETERS="

Rem #################################
Rem ##  End of user-editable part  ##
Rem #################################


if exist "%CD%\FN.exe" goto infolder
echo "Searching for FN.exe, because is not in this folder.That could take sometime..."
for /f "delims=" %%F in ('dir /b /s "C:\FN.exe" 2^>nul') do set MyVariable=%%F
if exist "%MyVariable%" goto WindowsVer
echo "FN.exe is not found in the system, that could be blocked by Windows Defender or Antivirus "
goto END

:infolder
set MyVariable=%CD%\FN.exe


:WindowsVer
echo "Running FN from %MyVariable%"
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" goto W10
goto OtherW

:W10
"%MyVariable%"  --algo ETHASH --pool !POOL! --user !WALLET! --pool !POOL2! --user !WALLET!  --watchdog exit !EXTRAPARAMETERS!
if %ERRORLEVEL% == 42 (
	timeout 10
	goto W10
)
goto END

:OtherW
"%MyVariable%"  --algo ETHASH --pool !POOL! --user !WALLET! --pool !POOL2! --user !WALLET! --watchdog exit !EXTRAPARAMETERS! --nocolor
if %ERRORLEVEL% == 42 (
	timeout 10
	goto OtherW
)

:END
pause

