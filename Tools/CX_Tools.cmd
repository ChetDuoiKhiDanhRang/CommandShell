@echo off
color 03

setlocal enabledelayedexpansion
:clearAndMenu
cls
:menu
echo -----------------------------------
echo Author: github.com/ChetDuoiKhiDanhRang
echo Github: github.com/ChetDuoiKhiDanhRang/CMD
echo Time  : %date%-%Time%
echo Folder: %~dp0
echo File  : %~nx0
::declare menu items
set itemsCount=9
set MenuItems[0]=EXIT
set MenuItems[1]=Takeown file or folder and child-items
set MenuItems[2]=Set Everyone full access control
set MenuItems[3]=Set owner to Everone
set MenuItems[4]=
set MenuItems[5]=
set MenuItems[6]=
set MenuItems[7]=
set MenuItems[8]=
set MenuItems[9]=

::draw menu
echo -----------------------------------
for /l %%i in (1,1,%itemsCount%) do (
	if "!MenuItems[%%i]!" neq "" (
		echo   [%%i] - !MenuItems[%%i]!
	)
)
echo   [0] - %MenuItems[0]%
echo -----------------------------------
choice /c 1234567890 /n /m "Press key to choice:"
set key=%errorlevel%
for /f "tokens=%key%" %%i in ("1 2 3 4 5 6 7 8 9 0") do (
	set keychar=%%i
)
::--------------------------------------------------------
echo Selected: [!keychar!] - !MenuItems[%keychar%]!
timeout 3
cls
echo [!keychar!] - !MenuItems[%keychar%]!
goto %keychar%
::--------------------------------------------------------
:Input
set InputPath=
set /p InputPath=Input path (leave empty to back to menu):
::replace chars if user paste as path from clipboard
if "!InputPath!" neq "" (
	set InputPath=!InputPath:"=!
	set InputPath=!InputPath:'=!
) else (
	set InputPath=
	goto clearAndMenu
)
::check if input path is not exist
if not exist "!InputPath!" (
	set InputPath=
	echo Input path is not exist!
	timeout 3
	goto clearAndMenu
)
::check is file or folder's path
set isFolder=true
if not exist "!InputPath!\" set isFolder=false
goto %resume%

::Takeown folder and child
:1
set resume=r1
goto Input
:r1
::takeown
if "%isFolder%"=="true" (
	echo It's a folder
	takeown /F "!InputPath!" /R /SKIPSL /D Y"
) else (
	echo It's a file
	takeown /F "!InputPath!" /D Y
)
::    /F           filename        Specifies the filename or directory
::                                 name pattern. Wildcard "*" can be used
::                                 to specify the pattern. Allows
::                                 sharename\filename.
::
::    /A                           Gives ownership to the administrators
::                                 group instead of the current user.
::
::    /R                           Recurse: instructs tool to operate on
::                                 files in specified directory and all
::                                 subdirectories.
::
::    /D           prompt          Default answer used when the current user
::                                 does not have the "list folder" permission
::                                 on a directory.  This occurs while operating
::                                 recursively (/R) on sub-directories. Valid
::                                 values "Y" to take ownership or "N" to skip.
::
::    /SKIPSL                      Do not follow symbolic links.
::                                 Only applicable with /R.
pause
goto clearAndMenu
::--------------------------------------------------------
:2
set resume=r2
goto Input
:r2
::Disable inheritance
icacls "!InputPath!" /inheritance:d /T /C
	::    /inheritance:e|d|r
	::      e - enables inheritance
	::      d - disables inheritance and copy the ACEs
	::      r - remove all inherited ACEs
::Reset to default system permissions
icacls "!InputPath!" /reset /T /C
::Grant Everyone to Full access on Input and child items
icacls "!InputPath!" /grant Everyone:F /T /C
pause
goto clearAndMenu
::--------------------------------------------------------
:3
set resume=r3
goto Input
:r3
icacls "!InputPath!" /setowner Everyone /T /C
pause
goto clearAndMenu
::--------------------------------------------------------
:0
endlocal
echo Exit program.
timeout 3