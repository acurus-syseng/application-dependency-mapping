:: Nightly scheduled task that stops the current CurrPorts process, deletes the old log file, and starts the process again
:: kills the current running CurrPorts program
taskkill /f /im cports.exe

:: delete oldest cports log (4 days old)
del /Q "C:\Support\Programs\CurrPorts_x86\cports-4.log"

:: renames day 3 file to day 4
ren "C:\Support\Programs\CurrPorts_x86\cports-3.log" "C:\Support\Programs\CurrPorts_x86\cports-4.log"

:: renames day 2 file to day 3
ren "C:\Support\Programs\CurrPorts_x86\cports-2.log" "C:\Support\Programs\CurrPorts_x86\cports-3.log"

:: renames day 1 file to day 2
ren "C:\Support\Programs\CurrPorts_x86\cports-1.log" "C:\Support\Programs\CurrPorts_x86\cports-2.log"

:: renames todays log file to 1
ren "C:\Support\Programs\CurrPorts_x86\cports.log" "C:\Support\Programs\CurrPorts_x86\cports-1.log"

:: starts CurrPorts with a customized config file
start "" C:\Support\Programs\CurrPorts_x86\cports.exe /cfg C:\Support\Programs\CurrPorts_x86\customised.cfg /StartAsHidden 1
