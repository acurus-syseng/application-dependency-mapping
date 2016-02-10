@echo off

SET CENTRALLOCATION=\\centralfilerepository_servername\sharename$

REM ========================= Kill the cports.exe task if already running. Error trapping for Xcopy failure ==============
taskkill /f /im "cports.exe"

echo.
echo.

REM ===================================== Create requisite folders =======================================================
echo COPYING FILES
mkdir c:\Support
mkdir c:\sumo

echo.
echo.


REM ==================================================== Copy Stuff ======================================================
robocopy %CENTRALLOCATION%\Support c:\Support  /E /XO /R:0 /W:0
robocopy %CENTRALLOCATION%\sumo c:\sumo  /E /XO /R:0 /W:0

echo.
echo.


REM ======== Create scheduled task to run CURRPORTS everyday at 2355 hours. Run current Currports output to CSV file ======
SCHTASKS /CREATE /RU "NT AUTHORITY\SYSTEM" /SC daily /TN "Currports Logging" /TR "C:\Support\Scripts\Currports_Daily_Process.bat" /ST 23:55 /F
C:\Support\Programs\CurrPorts\cports.exe /scomma C:\Support\Programs\CurrPorts\%computername%.csv /sort "state"

echo.
echo.


REM ========================= Running sydi inventory tool and copying output to central location ==========================
cscript c:\support\Programs\sydi\sydi-server.vbs -t%computername% -ex -sh -oc:\support\programs\sydi\xml\%computername%.xml

echo.
echo.


REM =========================================== Run scheduled task for currports ===========================================

SCHTASKS /RUN /TN "Currports Logging"

echo. 
echo.  


REM ============================================ Capturing scheduled tasks =================================================
SCHTASKS /QUERY /FO:CSV>c:\support\programs\%computername%-stsks.csv

echo.
echo.


REM ========================= Copying Currports.csv, SYDI.xml and Schdtsks.csv to Central Location =========================
copy c:\Support\programs\sydi\xml\%computername%.xml %CENTRALLOCATION%\Collections\SYDI-output\%computername%.xml
COPY C:\Support\Programs\CurrPorts\%computername%.csv %CENTRALLOCATION%\Collections\%computername%.csv
copy c:\support\programs\%computername%-stsks.csv %CENTRALLOCATION%\Collections\SchTasks-output\%computername%-stsks.csv

echo.
echo.


REM ================================== StartInstall and Start the Sumo Collector Service ===================================
start "" "c:\Support\Programs\Sumo Logic Collector\InstallCollector-NT.bat"
timeout 2
start "" "C:\support\Programs\Sumo Logic Collector\startCollectorService.bat"

PAUSE

echo.
echo.


REM ===== Below lines to be used when script run interactively. Confirm Cports.log exists. If not rerun scheduled task======
c:\support\programs\currports