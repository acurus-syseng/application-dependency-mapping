:: Nightly scheduled task that stops the current CurrPorts process, deletes the old log file, and starts the process again
:: kills the current running CurrPorts program
taskkill /f /im cports.exe

:: deletes cport log files older than 3 days
forfiles /P "C:\Support\Programs\CurrPorts" /M *cports.log /D -3 /C "cmd /c del @path"

:: renames cports log file to date format
for /f "tokens=1-5 delims=/ " %%d in ("%date%") do rename "C:\Support\Programs\CurrPorts\cports.log" %%e-%%f-%%g-cports.txt

:: starts CurrPorts with a customized config file
start "" C:\Support\Programs\CurrPorts\cports.exe /cfg C:\Support\Programs\CurrPorts\customised.cfg /StartAsHidden 1
