:: Nightly scheduled task that stops the current CurrPorts process, deletes the old log file, and starts the process again
:: kills the current running CurrPorts program
taskkill /f /im cports.exe

:: delete yesterdays cports log
del /Q "C:\Support\Programs\CurrPorts\cports-yesterday.log"

:: renames todays log file to yesterday
ren "C:\Support\Programs\CurrPorts\cports.log" "C:\Support\Programs\CurrPorts\cports-yesterday.log

:: starts CurrPorts with a customized config file
start "" C:\Support\Programs\CurrPorts\cports.exe /cfg C:\Support\Programs\CurrPorts\customised.cfg /StartAsHidden 1
