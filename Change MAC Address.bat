@echo off
dism >nul
if %errorlevel% NEQ 0 goto Elevate
(call )
netsh interface set interface Wi-Fi disable
  timeout /t 1 /nobreak >null
netsh interface set interface Wi-Fi enable
cls && (call )
choice /c RCd /m "Would you like to randomize your MAC adress or customize it?"
  if %Errorlevel% EQU 2 goto custom
  if %errorlevel% EQU 3 set MAC=0ENULL && goto after
set loopcount=5
  :loop
    set /a loopcount=loopcount-1
    if %loopcount% LEQ 0 (goto exitloop)
    set /a "ascii = %random% * 26 / 32768 + 65"
    cmd /c exit /b %ascii%
    set "rl1=%rl1%%=ExitCodeAscii%
  goto loop

:exitloop
  set MAC="%random:~0,2%%random:~0,2%%rl1:~0,2%%random:~0,2%%rl1:~3,2%%rl1:~-1%%random:~0,1%"
goto after

:custom
  echo What would you like to change your MAC address to?
  echo Remember to always have the second digit of your MAC address to always be a number
  echo Format: 11BBCCDDEEFF
  echo/
  set /p MAC="Input your MAC address here (no spaces or hyphens)> "

:after
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0011" /v NetworkAddress /d %MAC% /f >null
  :: Replace this REG command with the path of YOUR NIC card that you can find in your getmac /v 
  :: command under the "Transport Name" label of "Connection Name" Wi-Fi or whatever you want to change
  netsh interface set interface Wi-Fi disable
    timeout /t 1 /nobreak >null
  netsh interface set interface Wi-Fi enable
  echo Operation Successful
  echo %mac% is your new MAC address
  pause
goto :eof

:Elevate
  Echo Error: The requested operation requires elevation
  Echo Run file again as admin
  Echo Closing file in 10 seconds...
  timeout /t 10 /nobreak >nul
goto :eof
