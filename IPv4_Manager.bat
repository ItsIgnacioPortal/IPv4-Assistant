
@echo off
title IPv4 Manager
:main
color 0a
mode 1000

::The name of the interface is saved in a variable, to configure it later...


echo Selecciona tu interface: 
echo 1 - "Wi-fi"
echo 2 - "Wi-fi 2"
echo 3 - "Ethernet 2"
echo 99 - SALIR
echo ------------------------------
SET /p menu1="(1/2/3/99): "
if %menu1%==1 set interface=Wi-fi
::Wifi built-in the PC
if %menu1%==2 set interface=Wi-fi 2
::Wifi USB
if %menu1%==3 set interface=Ethernet 2
::PC built-in Ethernet
if %menu1%==99 goto :bye


::-----------------------------------------------------------------------------------------------------------------


::The interface "interface" is configured
cls
echo .
netsh interface ipv4 show config "%interface%"
echo .
echo What do you want to do?:
echo 1 - Set Tipical STATIC IP (192.168.0.32)
echo 2 - Custom IP
echo 3 - DHCP
echo 4 - Load PROFILE
echo 99 - Exit
echo -----------------------------
SET /p menu2="(1/2/3/99): "
if %menu2%==1 goto :ConfigIPTipica
if %menu2%==2 goto :ConfigCustom
if %menu2%==3 goto :ConfigDHCP
if %menu2%==4 goto :ConfigPerfiles
if %menu2%==99 goto :bye

::-----------------------------------------------------------------------------------------------------------------

:ConfigIPTipica
cls
echo Stablishing Tipic IPv4 Configuration... (192.168.0.32)
::Se establece la IP y DNSs
netsh interface ipv4 set address name="%interface%" static 192.168.0.32
echo IP establecida (192.168.0.32)
netsh interface ipv4 add dnsserver name="%interface%" static 1.1.1.1 index=1
echo Primary DNS set (1.1.1.1)
netsh interface ipv4 add dnsserver name="%interface%" static 192.168.0.1 index=2
echo Secondary DNS set (192.168.0.1)
pause
goto :main

::-----------------------------------------------------------------------------------------------------------------

:ConfigCustom
cls
::Asking for the desired configuration..
echo Which IPv4 do you want?:
	SET /p IPv4con="(x.x.x.x / DHCP): "
echo Wich primary DNS server do you want?:
	SET /p DNSPRIMARIO="(x.x.x.x / DHCP): "
	::The secondary DNS question is skiped if the user picks "DHCP"..
	if %DNSPRIMARIO%==dhcp goto :skipp
echo Wich secondary DNS server do you want?
	SET /p DNSSECUNDARIO="(x.x.x.x): "
:skipp


::The desired interface is configured with the information collected before
if %IPv4con%==dchp (
	::IPv4 DHCP
	netsh interface ipv4 set address name=”%interface%” source=dhcp
	echo %interface% set to DHCP
) else (
	::Static IPv4
	netsh interface ipv4 set address name="%interface%" static %IPv4con%
	echo %interface% set with the IPv4 %IPv4con%
)

::Configure DNSs
if %DNSPRIMARIO%==DHCP (
	::DNSs IPv4 en DHCP
	netsh interface ipv4 set dnsservers name"%interface%" source=dhcp
	echo DNS de %interface% establecido a DHCP
) else (
	::Static IPv4 DNSs
	netsh interface ipv4 add dnsserver name="%interface%" static %DNSPRIMARIO% index=1
	echo Primary DNS of %interface% set to %DNSPRIMARIO%
	netsh interface ipv4 add dnsserver name="%interface%" static %DNSSECUNDARIO% index=2
	echo Secondary DNS of %interface% set to %DNSSECUNDARIO%
)

echo Ready!
pause
goto :main

::-----------------------------------------------------------------------------------------------------------------

:ConfigDHCP
cls
echo Seting %interface% on DHCP...
	netsh interface ipv4 set address name=”%interface%” source=dhcp
	echo %interface% set to DHCP
echo Setting DNSs on DHCP
	netsh interface ipv4 set dnsservers name"%interface%" source=dhcp
	echo DNSs of %interface% set to DHCP
echo All done!
pause
goto :main

::-----------------------------------------------------------------------------------------------------------------

:ConfigPerfiles
cls
echo Avalible Profiles: 
echo ----------------------------------------
echo 1 - AndroidAP
echo 2 - Tipical wifi(192.168.0.x)
echo 3 - IMPORT profile from file..
echo 4 - See example profile file
echo 99 - BACK TO MAIN MENU
echo ----------------------------------------
SET /P ConfigPerfilesMenu1="(1/2/99): "
if %ConfigPerfilesMenu1%==1 goto :PERFIL1
if %ConfigPerfilesMenu1%==2 goto :PERFIL2
if %ConfigPerfilesMenu1%==3 goto :ImportProfileFromFile
if %ConfigPerfilesMenu1%==4 goto :ShowExampleFile
if %ConfigPerfilesMenu1%==99 goto :main

::-----------------------------------------------------------------------------------------------------------------

:PERFIL1
set PERFIL_IPV4TYPE=static
set PERFIL_IPV4ADDR=192.168.43.52
set PERFIL_IPV4MASK=255.255.255.0
set PERFIL_IPV4GATEWAY=192.168.43.1
set PERFIL_DNSTYPE=dhcp
goto :ConfigPerfilesAplicar

::-----------------------------------------------------------------------------------------------------------------

:PERFIL2
set PERFIL_IPV4TYPE=static
set PERFIL_IPV4ADDR=192.168.0.31
set PERFIL_IPV4MASK=255.255.255.0
set PERFIL_IPV4GATEWAY=192.168.0.1
set PERFIL_DNSTYPE=static
set PERFIL_DNS1=1.1.1.1
set PERFIL_DNS2=192.168.0.1
goto :ConfigPerfilesAplicar



::-----------------------------------------------------------------------------------------------------------------

:ShowExampleFile
cls
TYPE exampleProfile.cmd
pause
goto :ConfigPerfiles

::-----------------------------------------------------------------------------------------------------------------

:ImportProfileFromFile
cls
echo "======================================================="
cd CustomProfiles
echo The avalible profiles are:
dir *.cmd
echo "	('CANCEL' to cancel).."
SET /P ImportProfileFILE="Write a filename: "
if %ImportProfileFILE%=="CANCEL" goto :ConfigPerfiles
goto :ConfigPerfilesAplicar

::-----------------------------------------------------------------------------------------------------------------

:ConfigPerfilesAplicar
cls

echo Stablishing the requested IPv4 configuration on %interface% ..
if PERFIL_IPV4TYPE==dhcp(

	::Apply DHCP IPv4
	netsh interface ipv4 set address name=”%interface%” source=dhcp
	echo %interface% set to DHCP

) else (

	::Apply STATIC IPv4
	netsh interface ipv4 set address name="%interface%" static %PERFIL_IPV4ADDR% mask=%PERIFL_IPV4MASK% gateway=%PERFIL_IPV4GATEWAY%

)
if PERFIL_DNSTYPE==dhcp (

	::Apply DHCP DNS
	netsh interface ipv4 set dnsservers name="%interface%" source=dhcp
	echo     DNS of %interface% set to DHCP

) else (

	::Apply STATIC DNS
	netsh interface ipv4 add dnsserver name="%interface%" static %PERFIL_DNS1% index=1
	echo     Primary DNS of %interface% set to %PERFIL_DNS1%
	netsh interface ipv4 add dnsserver name="%interface%" static %PERFIL_DNS2% index=2
	echo     Secondary DNS of %interface% set to %PERFIL_DNS2%

)

netsh interface ipv4 show config "%interface%"
pause
goto :main



::-----------------------------------------------------------------------------------------------------------------

:bye
::Salir del programa
cls
echo Bye bye!
pause
exit