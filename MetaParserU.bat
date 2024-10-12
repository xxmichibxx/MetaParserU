@echo off
cls
color 1F
mode con cols=80 lines=30
title MetaParserU
set ScriptVersion=v1.0.0
REM Small fix for Windows 2000
ver | find "5.0" >nul
if "%errorlevel%"=="1" chcp 65001 >nul
set "inputMeta=%~1"
if "%inputMeta%"=="" goto missingInput
if exist "%inputMeta%\meta\meta.xml" (
	set "inputMeta=%inputMeta%\meta\meta.xml"
	goto startParsing
)
if exist "%inputMeta%\meta.xml" (
	set "inputMeta=%inputMeta%\meta.xml"
	goto startParsing
)
goto startParsing

:startParsing
REM Simple check if meta.xml is vaild
findstr /c:"product_code" "%inputMeta%" >nul 2>&1
if "%errorlevel%"=="1" goto invalidInput
cls
echo.
echo.
echo                     ########################################
echo                     #          MetaParserU %ScriptVersion%          #
echo                     ########################################
echo.
echo.
echo   Parsing XML file. Please wait...
echo.
REM Basic parsing
for /f "tokens=3 delims=><" %%G in ('findstr /c:"<version" "%inputMeta%"') DO if not defined WU-Meta-Version set "WU-Meta-Version=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"product_code" "%inputMeta%"') DO if not defined WU-Product-Code set "WU-Product-Code=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"company_code" "%inputMeta%"') DO if not defined WU-Company-Code set "WU-Company-Code=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"<longname_en" "%inputMeta%"') DO if not defined WU-Longname1 set "WU-Longname1=%%G" >nul
for /f "tokens=1 delims=><" %%G in ('findstr /c:"</longname_en>" "%inputMeta%"') DO if not defined WU-Longname2 set "WU-Longname2=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"publisher_en" "%inputMeta%"') DO if not defined WU-Company set "WU-Company=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"app_launch_type" "%inputMeta%"') DO if not defined WU-App_Launch_Type set "WU-App_Launch_Type=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"title_id" "%inputMeta%"') DO if not defined WU-Title_ID set "WU-Title_ID=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"title_version" "%inputMeta%"') DO if not defined WU-Title_Version set "WU-Title_Version=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"region" "%inputMeta%"') DO if not defined WU-Region set "WU-Region=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"mastering_date" "%inputMeta%"') DO if not defined WU-Date set "WU-Date=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"no_event_log" "%inputMeta%"') DO if not defined WU-Event-Log set "WU-Event-Log=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"launching_flag" "%inputMeta%"') DO if not defined WU-Flag set "WU-Flag=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"drc_use" "%inputMeta%"') DO if not defined WU-DRC set "WU-DRC=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"network_use" "%inputMeta%"') DO if not defined WU-Network set "WU-Network=%%G" >nul
for /f "tokens=3 delims=><" %%G in ('findstr /c:"online_account_use" "%inputMeta%"') DO if not defined WU-Online-Acc set "WU-Online-Acc=%%G" >nul
REM Fine tuning
REM Removing unsupported chars
set "WU-Longname1=%WU-Longname1:&amp;=^&%"
set "WU-Longname1=%WU-Longname1:&apos;=^'%"
set "WU-Longname1=%WU-Longname1: :=%"
set "WU-Longname1=%WU-Longname1::=%"
set "WU-Longname1=%WU-Longname1:^?=%"
set "WU-Longname1=%WU-Longname1:(=%"
set "WU-Longname1=%WU-Longname1:)=%"
set "WU-Longname2=%WU-Longname2:&amp;=^&%"
set "WU-Longname2=%WU-Longname2:&apos;=^'%"
set "WU-Longname2=%WU-Longname2: :=%"
set "WU-Longname2=%WU-Longname2::=%"
set "WU-Longname2=%WU-Longname2:^?=%"
set "WU-Longname2=%WU-Longname2:(=%"
set "WU-Longname2=%WU-Longname2:)=%"
set "WU-Title_Rev=Rev 0"
if "%WU-Meta-Version%"=="1" set "WU-Meta-Version=Homebrew"
REM Determine app type
if /i "%WU-Product-Code:~4,-5%"=="P" (
	if %WU-Title_Version% GTR 1 (
		REM Some updates are using the product code for games instead for updates
		set "WU-App_Type=Update Data"
		if "%WU-Title_Version%"=="16" (
			REM Fix for later game revisions
			set "WU-App_Type=Game"
		)
	) else (
		set "WU-App_Type=Game"
	)
	if "%WU-Meta-Version%"=="33" set "WU-Meta-Version=NUS"
	if "%WU-Meta-Version%"=="32" set "WU-Meta-Version=Retail"
	goto MP-App-TypeOK
)
if /i "%WU-Product-Code:~4,-5%"=="M" (
	set "WU-App_Type=DLC"
	set "WU-Meta-Version=NUS"
	goto MP-App-TypeOK
)
if /i "%WU-Product-Code:~4,-5%"=="U" (
	set "WU-App_Type=Update Data"
	set "WU-Meta-Version=NUS"
	goto MP-App-TypeOK
)
if /i "%WU-Product-Code:~4,-5%"=="N" (
	set "WU-Meta-Version=NUS"
	if "%WU-Flag%"=="00000005" (
		set "WU-App_Type=Virtual Console"
	) else (
		set "WU-App_Type=System App"
		if "%WU-Event-Log%"=="00000002" set "WU-App_Type=Game [vWii]"
	)
)
:MP-App-TypeOK
REM Changing results in something more readable
if "%WU-App_Launch_Type%"=="00000000" set "WU-App_Launch_Type=Launchable from Wii U menu"
if "%WU-App_Launch_Type%"=="00000001" set "WU-App_Launch_Type=Autostart"
if "%WU-Region%"=="00000001" (
	set "WU-Region=JPN"
	set "WU-Region-Full=Japan"
	chcp 932 >nul
	goto MP-RegionOK
)
if "%WU-Region%"=="00000002" (
	set "WU-Region=USA"
	set "WU-Region-Full=North America"
	goto MP-RegionOK
)
if "%WU-Region%"=="00000004" (
	set "WU-Region=EUR"
	set "WU-Region-Full=Europe/Australia"
	goto MP-RegionOK
)
if "%WU-Region%"=="00000007" (
	set "WU-Region=RF"
	set "WU-Region-Full=Region free"
	goto MP-RegionOK
)
if /i "%WU-Region%"=="FFFFFFFF" (
	set "WU-Region=RF"
	set "WU-Region-Full=Region free"
)
:MP-RegionOK
if "%WU-DRC%"=="0" set "WU-DRC=No"
if "%WU-DRC%"=="1" set "WU-DRC=Yes [Normal]"
if "%WU-DRC%"=="2" set "WU-DRC=Yes [Mirrored only]"
if "%WU-Network%"=="0" set "WU-Network=No"
if "%WU-Network%"=="1" set "WU-Network=Yes [Optional]"
if "%WU-Network%"=="2" set "WU-Network=Yes [Required]"
if "%WU-Online-Acc%"=="0" set "WU-Online-Acc=No"
if "%WU-Online-Acc%"=="1" set "WU-Online-Acc=Yes [Optional]"
if "%WU-Online-Acc%"=="2" set "WU-Online-Acc=Yes [Required]"
REM Fixing an issue if some values are not set in XML
if "%WU-Date%"=="/mastering_date" set "WU-Date=N/A"
if "%WU-Company%"==" " set "WU-Company=N/A"
if "%WU-Longname1%"==" " set "WU-Longname1=N/A"
REM Fixing an issue if longname_en doesnt split up into two lines
if "%WU-Longname2%"=="  " (
	REM False, Game name doesnt split up
	set "toggleName=0"
) else (
	REM True, Game name does split up
	set "toggleName=1"
)
goto doneParsing

:doneParsing
if "%toggleName%"=="0" title MetaParserU - %WU-Longname1% [%WU-Product-Code:~-4%%WU-Company-Code:~-2%]
if "%toggleName%"=="1" title MetaParserU - %WU-Longname1% %WU-Longname2% [%WU-Product-Code:~-4%%WU-Company-Code:~-2%]
cls
echo.
echo.
echo                     ########################################
echo                     #          MetaParserU %ScriptVersion%          #
echo                     ########################################
echo.
echo.
echo   App type           = %WU-App_Type% [%WU-Meta-Version%]
if "%toggleName%"=="0" echo   Game name          = %WU-Longname1%
if "%toggleName%"=="1" echo   Game name          = %WU-Longname1% %WU-Longname2%
echo   Product code       = %WU-Product-Code%
echo   Loadiine ID        = %WU-Product-Code:~-4%%WU-Company-Code:~-2%
echo   Title ID           = %WU-Title_ID:~0,8%-%WU-Title_ID:~-8% [v%WU-Title_Version%]
echo   Company code       = %WU-Company-Code% [%WU-Company%]
echo   Region             = %WU-Region-Full% [%WU-Region%]
echo   App launch type    = %WU-App_Launch_Type%
echo   Mastering date     = %WU-Date%
echo   Gamepad support    = %WU-DRC%
echo   Network use        = %WU-Network%
echo   NNID use           = %WU-Online-Acc%
if /i "%WU-Product-Code%"=="WUP-P-ABCD" if "%WU-Company-Code%"=="ZZZZ" (
	echo   Note               = This is meta.xml from a System title, not from a real
	echo                        Game. This file is created when extracting a WUD.
)
echo.
pause
exit

:missingInput
cls
echo.
echo.
echo                     ########################################
echo                     #          MetaParserU %ScriptVersion%          #
echo                     ########################################
echo.
echo.
echo  The batch cannot be run directly. Please drag and drop
echo  onto this batch. Compatible formats:
echo.
echo  - meta.xml file
echo  - Game folder [Loadliine format]
echo.
pause
exit

:invalidInput
cls
echo.
echo.
echo                     ########################################
echo                     #          MetaParserU %ScriptVersion%          #
echo                     ########################################
echo.
echo.
echo  A valid meta.xml file could not be found. Please verify
echo  your file or folder and try again.
echo.
pause
exit