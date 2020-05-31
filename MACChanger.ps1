#requires -RunAsAdministrator
rv * -ErrorAction SilentlyContinue
echo "This file will temporarily disable your Wi-Fi adapter"
While (!($C1)){
$choice1 = Read-Host -Prompt "Would you like to proceed? [Y/N]"
switch ($choice1) {
   "N" {echo "Ok, press any key to exit this file:"
        cmd /c pause > $null; exit}
   "Y" {echo "Ok, proceeding with operation"; [int]$C1 = 1; break}
   }
if (!($C1)){echo "Invalid input"}
}
rv * -ErrorAction SilentlyContinue

netsh interface set interface Wi-Fi disable;

$getwifi = netsh interface show interface | findstr "Wi-Fi"
if ($getwifi.substring(0,7) -ne "disable"){echo "Unexpected error: Press any key to exit"
                                           cmd /c pause > $null; exit}
echo "Wi-Fi has been succesfully disabled, proceeding with operation"

While (!($C1)){
    $choice1 = Read-Host -Prompt "Would you like to randomize your MAC Address or customize it? [R/C]"
    switch ($choice1) {
        "R" {
            $MAC = bash -c "openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'"
            $MAC = $MAC -replace ":"
            $C1 = 1}
        "C" {$C1 = 2}
    }
if (!($C1)){echo "Invalid input"}
}

if(!($MAC)){
do{
echo "What would you like to change your MAC address to?`nRemember to always have the second digit of your MAC address to always be a number`nFormat: 11BBCCDDEEFF";
$MAC = read-host -prompt "Input your MAC address here [no spaces or hyphens]";
if ($MAC.length -eq 12){$C1 = 1};
if (!($MAC.length -eq 12)){echo "Invalid input: Follow the format"; rv MAC}
} while(!($MAC))
}
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0011" /v NetworkAddress /d $MAC /f >$null
<#
Replace this REG command with the path of YOUR NIC card that you can find in your getmac /v 
command under the "Transport Name" label of "Connection Name" Wi-Fi or whatever you want to change
#>
netsh interface set interface Wi-Fi enable
echo "Operation Successful"
echo "$MAC is your new MAC address"
pause
