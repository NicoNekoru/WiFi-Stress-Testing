@echo off
title MainPingCenter
(call )
choice /c DC /m "Would you like to ping the default gateway or a custom IP/Web Address?"
    IF %ERRORLEVEL% EQU 1 (
        (for /f "tokens=2,3 delims={,}" %%a in ('"WMIC NICConfig where IPEnabled="True" ^
        get DefaultIPGateway /value | find "I" "') do (echo Default IP Gateway : %%~a & set i=%%~a)
        )
    goto add)
set /p i="Type in the IP address or website address you want to ping: "

:add
    set /p loopcount="How many cmds do you want to ping with? "
    set /p Bytes="How many bytes of data do you want to ping with? "
    set /a loopcount=loopcount+1

:loop
    set /a loopcount=loopcount-1
    if %loopcount% LEQ 0 (goto exitloop)
    start /min cmd.exe /k ping %i% /l %Bytes% /t
goto loop

:exitloop
    echo Success
    echo Commands are running in background
    pause

:back
    choice /c CP /m "Would you like to create more ping cmds or proceed? "
        IF %ERRORLEVEL% EQU 1 goto add
        IF %ERRORLEVEL% EQU 2 goto choose

:choose
    (call )
    choice /c YNTC /m "Would you like to close all cmd processes? (Yes, No, Timer, Cancel)"
        IF %ERRORLEVEL% EQU 1 goto yes
        IF %ERRORLEVEL% EQU 2 goto no
        IF %ERRORLEVEL% EQU 3 goto timer
        IF %ERRORLEVEL% EQU 4 goto back

:yes
    echo Closing all instances of cmd excluding this...
    taskkill /im cmd.exe /t /f /fi "windowtitle ne MainPingCenter"
    echo Taskkill complete. Press any key to continue...
    pause >nul
    title Command Prompt
goto :eof

:no
    echo Ok, press any key to end this file...
    pause >nul
    title Command Prompt
goto :eof

:timer
    set /p timer="Set amount of seconds until processes are closed: "
    choice /c YN /m "Would you ike it to close automatically when the time is finished? "
        IF %ERRORLEVEL% EQU 1 (timeout /t %timer% /nobreak & goto yes)
    timeout /t %timer% /nobreak
    echo Time is up. Press any key to terminate all command prompts
    pause >nul
goto yes
