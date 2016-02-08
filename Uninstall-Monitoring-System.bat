:: Uninstall script to remove company monitoring platform from servers
:: NOTE - must be run as administrator

:: kills currently running CurrPorts task
taskkill /f /IM cports.exe

:: removes CurrPorts Scheduled Task
SCHTASKS /Delete /TN "Currports logging" /F

:: stops SumoLogic Collector
sc stop sumo-collector

:: removes SumoLogic service
CALL "C:\Support\Programs\Sumo Logic Collector\UninstallCollector-NT.bat"

:: removes the Support folder, including all subfolders and files
Start c:\support
pause
rd C:\sumo /S /Q
rd C:\Support /S /Q

cls

echo CONFIRM FOLDERS AND SUMOLOGIC SERVICE ARE NOT FOUND

dir "c:\program files\"sumo* /A:D /b
dir "C:\support" /b
dir "C:\sumo" /b
net start | findstr "SumoLogic"
