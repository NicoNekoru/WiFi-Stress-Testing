Remove-Variable * -ErrorAction SilentlyContinue
$host.ui.RawUI.WindowTitle = "Main Ping Center"
while (!($p)) {
    $choice = read-host "Do you want to ping the default gateway, localhost, or a custom address? `n[D,L,C]"
    switch ($choice) {
        "D" {$p = WMIC NICConfig where IPEnabled="True" get DefaultIPGateway /value |findstr "{"; $p = $p.trimstart('DefaultIPGateway={"'); $p = $p.trimend('"}'); break}
        "L" {$p = "localhost"; break}
        "C" {$p = read-host "What address do you want to ping?"; break}
    }
    if (!($p)){echo "Invalid input"}
}
$p
while (!($lc -is [int])){
    $lc = read-host "How many cmds do you want to ping with? "
    $ErrorActionPreference = 'SilentlyContinue'
    [int]$lc = $lc
    if (!($lc -is [int])){echo "Invalid input"}
}
while (!($bytes -is [int])){
    $Bytes = read-host "How many bytes of data do you want to ping with? "
    $ErrorActionPreference = 'SilentlyContinue'
    [int]$bytes = $bytes
    if (!($bytes -is [int])){echo "Invalid input"}
}
$ErrorActionPreference = 'continue'
$nametitle = (Get-Random)*([math]::pi)*(Get-Random)
$p
do {
    saps cmd.exe -argumentlist "/k", "title $nametitle", "&", "ping $p /l $Bytes /t" -windowstyle Minimized
    $lc--
} until ( $lc -eq 0 )
write "Success`nCommands are running in background"
pause
while (!($C2)) {
    $choice2 = read-host "Would you like to close all cmd processes? (Yes/Y, No/N, Timer/T)"
    switch ($choice2) {
        "Yes" {$C2 = "Yes"}
        "Y" {$C2 = "Yes"}
        "No" {$C2 = "No"}
        "N" {$C2 = "No"}
        "Timer" {$C2 = "Time"}
        "T" {$C2 = "Time"}
    }
    if (!($C2)){echo "Invalid input"}
}
$tempo = Get-WmiObject win32_process | where {$_.ParentProcessId -eq $pid} | findstr /b "ProcessId"
$tempo = $tempo.trimstart("ProcessId                  : ")
$tempo = $tempo | Select-Object -Skip 1
switch ($C2) {
    "Yes" {echo "Closing all instances of cmd excluding this..."
        for($i = 0 ; $i -lt $tempo.length; $i++){echo $tempo[$i]; taskkill /t /f /pid $tempo[$i]}
        echo "Taskkill complete. Press any key to continue..."
        cmd /c pause | out-null
        exit}
    "No" {cd "$home\desktop" 
        echo $nametitle > PingName.txt
        echo $tempo >> PingName.txt
        echo "Ok, sending pid and name of ping cmds to text file..."
        echo "Press any key to exit this file..."
        cmd /c pause | out-null
        exit}
    "Time" {$timer = read-host "Set amount of seconds until processes are closed"
        timeout /t $timer /nobreak
        echo "Closing all instances of cmd excluding this..."
        for($i = 0 ; $i -lt $tempo.length; $i++){taskkill /t /f /pid $tempo[$i]}
        echo "Taskkill complete. Press any key to continue..."
        cmd /c pause | out-null
        exit
        exit}
}