@echo off

:: set central file repository
SET CENTRALLOCATION=\\centralfilerepository_servername\sharename$

:: kill any currently running currports process
taskkill /f /im "cports.exe"

echo. 
echo.

:: create folders on local system
echo "Creating folders on local system"
mkdir c:\Acurus
mkdir c:\sumo

echo.
echo.

::=========================================
:: copy monitoring software from repository to local system
echo "Copying monitoring software to local system"
xcopy %CENTRALLOCATION%\Acurus c:\Acurus  /E /D /Y
xcopy %CENTRALLOCATION%\sumo c:\Sumo  /E /D /Y

::===================================

echo.
echo.

:: capturing scheduled tasks
echo "Export all currently listed scheduled tasks"
SCHTASKS /QUERY /FO:CSV>c:\Acurus\Programs\%computername%-stsks.csv

:: Copy schdtsks.csv to Central Location
copy C:\Acurus\Programs\%computername%-stsks.csv %CENTRALLOCATION%\Collections\SchTasks-output\%computername%-stsks.csv


echo.
echo.

:: find architecture of current operating system
if /i "%processor_architecture%"=="AMD64" GOTO AMD64
if /i "%processor_architecture%"=="x86" GOTO x86
GOTO ERR

:: ======================================================

:AMD64
:: 64 bit operating system

echo "Operating system is 64 bit"

:: create scheduled task to run CURRPORTS everyday at 2355 hours. Run current Currports output to CSV file
echo "Creating scheduled task to run CurrPorts"
SCHTASKS /CREATE /RU "NT AUTHORITY\SYSTEM" /SC daily /TN "Currports Logging" /TR "C:\Acurus\Scripts\Start_Currports.bat" /ST 23:55 /F

:: export a current state csv of running ports
C:\Acurus\Programs\CurrPorts\cports.exe /scomma C:\Acurus\Programs\CurrPorts\%computername%.csv /sort "state"

:: copying Currports.csv to Central Location
COPY C:\Acurus\Programs\CurrPorts\%computername%.csv %CENTRALLOCATION%\Collections\CurrPorts-Output\%computername%.csv

echo.
echo.

:: StartInstall and Start the Sumo Collector Service
start "" "c:\Acurus\Programs\SumoLogic\InstallCollector-NT.bat"
timeout 2
start "" "C:\Acurus\Programs\SumoLogic\startCollectorService.bat"

PAUSE

echo.
echo.

GOTO SYDI

:: ======================================================

:x86
:: 32 bit operating system

echo "Operating system is 32 bit"

:: delete 64 bit local program folders
del /Q C:\Acurus\Programs\CurrPorts
del /Q C:\Acurus\Programs\SumoLogic

:: rename x86 folders
rename C:\Acurus\Programs\CurrPorts_x86 
rename C:\Acurus\Programs\SumoLogic_x86 

:: create scheduled task to run CURRPORTS everyday at 2355 hours. Run current Currports output to CSV file
echo "Creating scheduled task to run CurrPorts"
SCHTASKS /CREATE /RU "NT AUTHORITY\SYSTEM" /SC daily /TN "Currports Logging" /TR "C:\Acurus\Scripts\Start_Currports.bat" /ST 23:55 /F

:: export a current state csv of running ports
C:\Acurus\Programs\CurrPorts\cports.exe /scomma C:\Acurus\Programs\CurrPorts\%computername%.csv /sort "state"

:: copying Currports.csv to Central Location
COPY C:\Acurus\Programs\CurrPorts\%computername%.csv %CENTRALLOCATION%\Collections\CurrPorts-Output\%computername%.csv

echo.
echo.

:: StartInstall and Start the Sumo Collector Service
start "" "c:\Acurus\Programs\SumoLogic\InstallCollector-NT.bat"
timeout 2
start "" "C:\Acurus\Programs\SumoLogic\startCollectorService.bat"

PAUSE

echo.
echo.

GOTO SYDI

:: ======================================================

:SYDI

:: running SYDI inventory tool and copying output to central location
echo "Running SYDI to document the local system"
cscript C:\Acurus\Programs\SYDI\sydi-server.vbs -t%computername% -ex -sh -oC:\Acurus\Programs\SYDI\xml\%computername%.xml

:: copy SYDI.xml to Central Location
copy C:\Acurus\Programs\SYDI\xml\%computername%.xml %CENTRALLOCATION%\Collections\SYDI-output\%computername%.xml

:: run scheduled task for currports and begin logging
echo "Run CurrPorts scheduled task to begin CurrPorts logging"
SCHTASKS /RUN /TN "Currports Logging"

echo.
echo.

GOTO END

:ERR
@echo Unsupported architecture "%processor_architecture%"!
pause

:END