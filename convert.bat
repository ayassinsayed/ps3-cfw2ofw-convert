@echo off

:: Based on original PS3_OFW_TOOLS_470 convert.bat file
:: Source http://www.maxconsole.com/threads/playstation-3-backup-games-now-working-on-ofw-v4-70-ps3.43138/


title PS3 CFW to OFW Game and App Converter v0.1                      esc0rtd3w 2017

color 0e

set waitTime=3
set wait=ping -n %waitTime% 127.0.0.1

set licenseStatus=1

set filetypes=99
set discID=BXXX00000
set gameID=NPXX00000

set detectedGame=0

set paramDumpTitle=0
set paramDumpTitleID=0
set paramDumpVersion=0
set paramDumpVersionTargetApp=0
set paramDumpVersionApp=0

set convertedTitleID=0
set convertedTitleIDTemp=0
set titleIDLetterCode=XXXX
set titleIDLetterCodeTemp=XXXX
set titleIDNumberCode=00000
set titleIDNumberCodeTemp=00000

:: Set Root Path
set root=%~dp0
set toolsPath=%root%\tool

:: Set Tool Variables
set dklic_validator="%toolsPath%\dklic_validator.exe"
set HashConsole="%toolsPath%\HashConsole.exe"
set klic_bruteforcer="%toolsPath%\klic_bruteforcer.exe"
set make_c00_edat="%toolsPath%\make_c00_edat.exe"
set make_npdata="%toolsPath%\make_npdata.exe"
set make_npdata_old="%toolsPath%\make_npdata_old.exe"
set ps3xport="%toolsPath%\ps3xport.exe"
set rap2rifkey="%toolsPath%\rap2rifkey.exe"
set sfk="%toolsPath%\sfk.exe"
set sfo_extractor="%toolsPath%\sfo_extractor.exe"
set sfoprint="%toolsPath%\sfoprint.exe"

:: Dump PARAM.SFO Info
%sfoprint% %root%\PS3_GAME\PARAM.SFO TITLE>"%root%\temp\PARAM_SFO_TITLE.txt"
%sfoprint% %root%\PS3_GAME\PARAM.SFO TITLE_ID>"%root%\temp\PARAM_SFO_TITLE_ID.txt"
%sfoprint% %root%\PS3_GAME\PARAM.SFO VERSION>"%root%\temp\PARAM_SFO_VERSION.txt"
::%sfoprint% %root%\PS3_GAME\PARAM.SFO TARGET_APP_VER>"%root%\temp\PARAM_SFO_TARGET_APP_VER.txt"
%sfoprint% %root%\PS3_GAME\PARAM.SFO APP_VER>"%root%\temp\PARAM_SFO_APP_VER.txt"


:: Loading Text
echo Loading PS3 CFW to OFW Game and App Converter....

:: Wait a second
set waitTime=2
%wait%>nul

:: Clear Screen After Dumping Info
cls


setlocal enabledelayedexpansion

:: Title
for /f "delims=: tokens=2" %%a in ('type temp\PARAM_SFO_TITLE.txt') do (
	echo %%a>"%root%\temp\TEMP_PARAM_SFO_TITLE.txt"
)
set /p paramDumpTitle=<"%root%\temp\TEMP_PARAM_SFO_TITLE.txt"

:: Title ID
for /f "delims=: tokens=2" %%a in ('type temp\PARAM_SFO_TITLE_ID.txt') do (
	echo %%a>"%root%\temp\TEMP_PARAM_SFO_TITLE_ID.txt"
)
set /p paramDumpTitleID=<"%root%\temp\TEMP_PARAM_SFO_TITLE_ID.txt"

:: Version
for /f "delims=: tokens=2" %%a in ('type temp\PARAM_SFO_VERSION.txt') do (
	echo %%a>"%root%\temp\TEMP_PARAM_SFO_VERSION.txt"
)
set /p paramDumpVersionApp=<"%root%\temp\TEMP_PARAM_SFO_VERSION.txt"

:: Target App Version
::for /f "delims=: tokens=2" %%a in ('type temp\PARAM_SFO_TARGET_APP_VER.txt') do (
::	echo %%a>"%root%\temp\TEMP_PARAM_SFO_TARGET_APP_VER.txt"
::)
::set /p paramDumpVersionTargetApp=<"%root%\temp\TEMP_PARAM_SFO_TARGET_APP_VER.txt"

:: App Version
for /f "delims=: tokens=2" %%a in ('type temp\PARAM_SFO_APP_VER.txt') do (
	echo %%a>"%root%\temp\TEMP_PARAM_SFO_APP_VER.txt"
)
set /p paramDumpVersion=<"%root%\temp\TEMP_PARAM_SFO_APP_VER.txt"


set paramDumpTitle=!paramDumpTitle:~1,64!
set paramDumpTitleID=!paramDumpTitleID:~1,64!
set paramDumpVersion=!paramDumpVersion:~1,64!
::set paramDumpVersionTargetApp=!paramDumpVersionApp:~1,64!
set paramDumpVersionApp=!paramDumpVersionApp:~1,64!

echo !paramDumpTitle!>"%root%\temp\TEMP_PARAM_SFO_TITLE.txt"
echo !paramDumpTitleID!>"%root%\temp\TEMP_PARAM_SFO_TITLE_ID.txt"
echo !paramDumpVersion!>"%root%\temp\TEMP_PARAM_SFO_VERSION.txt"
::echo !paramDumpVersionTargetApp!>"%root%\temp\TEMP_PARAM_SFO_TARGET_APP_VER.txt"
echo !paramDumpVersionApp!>"%root%\temp\TEMP_PARAM_SFO_APP_VER.txt"

set /p paramDumpTitle=<"%root%\temp\TEMP_PARAM_SFO_TITLE.txt"
set /p paramDumpTitleID=<"%root%\temp\TEMP_PARAM_SFO_TITLE_ID.txt"
set /p paramDumpVersion=<"%root%\temp\TEMP_PARAM_SFO_VERSION.txt"
::set /p paramDumpVersionTargetApp=<"%root%\temp\TEMP_PARAM_SFO_TARGET_APP_VER.txt"
set /p paramDumpVersionApp=<"%root%\temp\TEMP_PARAM_SFO_APP_VER.txt"

::echo Title: %paramDumpTitle%
::echo Title ID: %paramDumpTitleID%
::echo Version: %paramDumpVersion%
::echo Target App Version: %paramDumpVersionTargetApp%
::echo App Version: %paramDumpVersionApp%
::pause


:: Get conversion TITLE_ID
for /f "tokens=*" %%a in ('type %paramDumpTitleID%') do (
	echo %%a>"%root%\temp\TEMP_CONVERT_TITLE_ID.txt"
)

:: Get first 4 characters of TITLE_ID
set /p titleIDLetterCodeTemp=<"%root%\temp\TEMP_CONVERT_TITLE_ID.txt"
set titleIDLetterCodeTemp=!titleIDLetterCodeTemp:~0,-5!
echo !titleIDLetterCodeTemp!>"%root%\temp\TEMP_CONVERT_TITLE_LETTERCODE.txt"
set /p titleIDLetterCodeTemp=<"%root%\temp\TEMP_CONVERT_TITLE_LETTERCODE.txt"

:: Get last 5 digits of TITLE_ID
set /p titleIDNumberCodeTemp=<"%root%\temp\TEMP_CONVERT_TITLE_ID.txt"
set titleIDNumberCodeTemp=!titleIDNumberCodeTemp:~4,9!
echo !titleIDNumberCodeTemp!>"%root%\temp\TEMP_CONVERT_TITLE_NUMBERCODE.txt"
set /p titleIDNumberCodeTemp=<"%root%\temp\TEMP_CONVERT_TITLE_NUMBERCODE.txt"

:: Set new converted TITLE_ID
if %titleIDLetterCodeTemp%==BLJS set titleIDLetterCode=NPJB
if %titleIDLetterCodeTemp%==BLJM set titleIDLetterCode=NPJB
if %titleIDLetterCodeTemp%==BCJS set titleIDLetterCode=NPJA
if %titleIDLetterCodeTemp%==BLUS set titleIDLetterCode=NPUB
if %titleIDLetterCodeTemp%==BCUS set titleIDLetterCode=NPUA
if %titleIDLetterCodeTemp%==BLES set titleIDLetterCode=NPEB
if %titleIDLetterCodeTemp%==BCES set titleIDLetterCode=NPEA
if %titleIDLetterCodeTemp%==BLAS set titleIDLetterCode=NPHB
if %titleIDLetterCodeTemp%==BCAS set titleIDLetterCode=NPHA
if %titleIDLetterCodeTemp%==BLKS set titleIDLetterCode=NPKB
if %titleIDLetterCodeTemp%==BCKS set titleIDLetterCode=NPKA

set titleIDNumberCode=%titleIDNumberCodeTemp%
set convertedTitleID=%titleIDLetterCode%%titleIDNumberCode%


:: Main Menu

:getID

:: Set gameID to suggested conversion name by default
set gameID=%convertedTitleID%

cls
echo -------------------------------------------------------------------------------
echo Detected Game: [%paramDumpTitle%] [%paramDumpTitleID%] [%paramDumpVersion%] [%paramDumpVersionApp%]
echo -------------------------------------------------------------------------------
echo.
echo Disc                         HDD
echo.
echo BLJS12345/BLJM12345          NPJB12345
echo BCJS12345                    NPJA12345
echo BLUS12345                    NPUB12345
echo BCUS12345                    NPUA12345
echo BLES12345                    NPEB12345
echo BCES12345                    NPEA12345
echo BLAS12345                    NPHB12345
echo BCAS12345                    NPHA12345
echo BLKS12345                    NPKB12345
echo BCKS12345                    NPKA12345
echo.
echo.
echo Enter Game ID and press ENTER or just press ENTER to use defaults:
echo.
echo Suggested Conversion Name: [%convertedTitleID%]
echo.
echo.

set /p gameID=


:: Create the structure of directories and subdirectories of our game
mkdir "%gameID%"
mkdir "%gameID%\LICDIR"


:notConvert
set filetypes=0

cls
echo -------------------------------------------------------------------------------
echo Detected Game: [%paramDumpTitle%] [%paramDumpTitleID%] [%paramDumpVersion%] [%paramDumpVersionApp%]
echo -------------------------------------------------------------------------------
echo.
echo.
echo Choose Filetypes NOT To Convert and press ENTER:
echo.
echo Default is 0
echo.
echo.
echo.
echo 0) NOTHING (Convert All Files)
echo.
echo 1) SDAT
echo.
echo 2) SDAT/EDAT
echo.
echo 3) SDAT/EDAT/SPRX
echo.
echo 4) SDAT/EDAT/SPRX/SELF
echo.
echo.

set /p filetypes=

if %filetypes% gtr 4 goto notConvert


:: Check for a LIC.DAT file
if not exist "PS3_GAME\LICDIR\LIC.DAT" set licenseStatus=0

:: Copy TROPHY and GAME files
xcopy "PS3_GAME\TROPDIR" "%gameID%\TROPDIR" /s /i
xcopy "PS3_GAME\*.*" "%gameID%\*.*"

if %filetypes%==1 xcopy "PS3_GAME\USRDIR\*.sdat" "%gameID%\USRDIR\*.sdat" /e

if %filetypes%==2 xcopy "PS3_GAME\USRDIR\*.sdat" "%gameID%\USRDIR\*.sdat" /e
if %filetypes%==2 xcopy "PS3_GAME\USRDIR\*.edat" "%gameID%\USRDIR\*.edat" /e

if %filetypes%==3 xcopy "PS3_GAME\USRDIR\*.sdat" "%gameID%\USRDIR\*.sdat" /e
if %filetypes%==3 xcopy "PS3_GAME\USRDIR\*.edat" "%gameID%\USRDIR\*.edat" /e
if %filetypes%==3 xcopy "PS3_GAME\USRDIR\*.sprx" "%gameID%\USRDIR\*.sprx" /e

if %filetypes%==4 xcopy "PS3_GAME\USRDIR\*.sdat" "%gameID%\USRDIR\*.sdat" /e
if %filetypes%==4 xcopy "PS3_GAME\USRDIR\*.edat" "%gameID%\USRDIR\*.edat" /e
if %filetypes%==4 xcopy "PS3_GAME\USRDIR\*.sprx" "%gameID%\USRDIR\*.sprx" /e
if %filetypes%==4 xcopy "PS3_GAME\USRDIR\*.self" "%gameID%\USRDIR\*.self" /e


:: Create a list of files and directories of the USRDIR folder. It is necessary for make_npdata
dir /b /s /a:-d "PS3_GAME\USRDIR\">list.txt

if %filetypes%==0 type list.txt | findstr /i /v "EBOOT.BIN" > temp.txt
if %filetypes%==1 type list.txt | findstr /i /v ".sdat EBOOT.BIN" > temp.txt
if %filetypes%==2 type list.txt | findstr /i /v ".sdat .edat EBOOT.BIN" > temp.txt
if %filetypes%==3 type list.txt | findstr /i /v ".sdat .edat .sprx EBOOT.BIN" > temp.txt
if %filetypes%==4 type list.txt | findstr /i /v ".sdat .edat .sprx .self EBOOT.BIN" > temp.txt

del list.txt
rename temp.txt list.txt

Set infile=list.txt
Set find=%CD%\PS3_GAME\
Set replace=


for /F "tokens=*" %%n in (!infile!) do (
set LINE=%%n
set TMPR=!LINE:%find%=%replace%!
Echo !TMPR!>>TMP.TXT
)
move TMP.TXT %infile%

:: Convert to sdat all files from the USRDIR folder
@echo on
for /f "tokens=*" %%B in (!infile!) do make_npdata -e "PS3_GAME\%%~B" "%gameID%\%%~B" 0 1 3 0 16

endlocal


:: Create EDAT

if %licenseStatus%==0 (
xcopy /y "PS3_GAME\PARAM.SFO" "%root%\GAMES\CREATE_NEW_LICENSE\PS3_GAME\PARAM.SFO"

echo.
echo.
echo No License Found!
echo.
echo.
echo When the KDW app opens, press C and ENTER to create a new LIC.DAT
echo.
echo.

"%root%\kdw_license_gen.exe"

set waitTime=3
%wait%

mkdir "PS3_GAME\LICDIR"
xcopy /y "%root%\GAMES\CREATE_NEW_LICENSE\PS3_GAME\LICDIR\LIC.DAT" "PS3_GAME\LICDIR\LIC.DAT"

set licenseStatus=1

)

if %licenseStatus%==1 (
echo.
echo.
echo Creating New License....
echo.
echo.

make_npdata -e "PS3_GAME\LICDIR\LIC.DAT" "%gameID%\LICDIR\LIC.EDAT" 1 1 3 0 16 3 00 EP9000-%gameID%_00-0000000000000001 1
)



:: Cleaning Temp Files
del /q /f %infile%>nul
del /f /q temp\PARAM_SFO_TITLE.txt>nul
del /f /q temp\TEMP_PARAM_SFO_TITLE.txt>nul
del /f /q temp\PARAM_SFO_TITLE_ID.txt>nul
del /f /q temp\TEMP_PARAM_SFO_TITLE_ID.txt>nul
del /f /q temp\PARAM_SFO_VERSION.txt>nul
del /f /q temp\TEMP_PARAM_SFO_VERSION.txt>nul
del /f /q temp\PARAM_SFO_TARGET_APP_VER.txt>nul
del /f /q temp\TEMP_PARAM_SFO_TARGET_APP_VER.txt>nul
del /f /q temp\PARAM_SFO_APP_VER.txt>nul
del /f /q temp\TEMP_PARAM_SFO_APP_VER.txt>nul
del /f /q temp\TEMP_CONVERT_TITLE_LETTERCODE.txt>nul
del /f /q temp\TEMP_CONVERT_TITLE_NUMBERCODE.txt>nul

:: Finished
@echo off
color 0a
echo.
echo.
echo ===============================================================================
echo                                    END 
echo ===============================================================================

pause