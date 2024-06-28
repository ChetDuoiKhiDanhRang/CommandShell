@echo off
color 03
::--------------------------------------------------------
setlocal enabledelayedexpansion
::--------------------------------------------------------
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
set MenuItems[1]=MenuItems[1]
set MenuItems[2]=MenuItems[2]
set MenuItems[3]=MenuItems[3]
set MenuItems[4]=MenuItems[4]
set MenuItems[5]=MenuItems[5]
set MenuItems[6]=MenuItems[6]
set MenuItems[7]=MenuItems[7]
set MenuItems[8]=MenuItems[8]
set MenuItems[9]=MenuItems[9]
::--------------------------------------------------------
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
:1
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:2
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:3
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:4
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:5
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:6
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:7
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:8
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:9
echo Empty!
echo Write code here.
pause
goto clearAndMenu
::--------------------------------------------------------
:0
endlocal
echo Exit program.
timeout 3