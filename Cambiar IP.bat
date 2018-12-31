@echo off
:main
color 0a
mode 1000
::Se guarda el nombre de la interface en una variable, para configurarla luego
echo Selecciona tu interface: 
echo 1 - "Wi-fi"
echo 2 - "Wi-fi 2"
echo 3 - "Ethernet 2"
echo 99 - SALIR
echo ------------------------------
SET /p menu1="(1/2/3/99): "
if %menu1%==1 set interface=Wi-fi
::Wifi built-in la PC
if %menu1%==2 set interface=Wi-fi 2
::Wifi conectada por USB
if %menu1%==3 set interface=Ethernet 2
::Ethernet built-in la PC
if %menu1%==99 goto :bye

::Se configura la interface "interface"
cls
echo .
netsh interface ipv4 show config "%interface%"
echo .
echo Que desea hacer?:
echo 1 - Establecer IP tipica (192.168.0.31)
echo 2 - Custom IP
echo 3 - IP y DNSs en DHCP
echo 4 - Cargar PERFIL
echo 99 - SALIR
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
echo Estableciendo IP tipica (192.168.0.32)
::Se establece la IP y DNSs
netsh interface ipv4 set address name="%interface%" static 192.168.0.32
echo IP establecida (192.168.0.32)
netsh interface ipv4 add dnsserver name="%interface%" static 8.8.8.8 index=1
echo DNS Primario establecido (8.8.8.8)
netsh interface ipv4 add dnsserver name="%interface%" static 192.168.0.1 index=2
echo DNS Secundario establecido (192.168.0.1)
pause
goto :main

::-----------------------------------------------------------------------------------------------------------------

:ConfigCustom
cls
::Se pide la configuracion deseada
echo Que IPv4 desea?:
	SET /p IPv4con="(x.x.x.x / DHCP): "
echo Que SERVIDOR DNS PRIMARIO desea?:
	SET /p DNSPRIMARIO="(x.x.x.x / DHCP): "
	::Se saltea la configuracion de DNSSecundario si se selecciona dhcp
	if %DNSPRIMARIO%==dhcp goto :skipp
echo Que SERVIDOR DNS SECUNDARIO desea?
	SET /p DNSSECUNDARIO="(x.x.x.x): "
:skipp


::Se inicia la configuracion con los parametros dados anteriormente
::Configurar IP
if %IPv4con%==dchp (
	::IPv4 DHCP
	netsh interface ipv4 set address name=”%interface%” source=dhcp
	echo %interface% establecida a DHCP
) else (
	::IPv4 Estatica
	netsh interface ipv4 set address name="%interface%" static %IPv4con%
	echo %interface% establecida con la IPv4 %IPv4con%
)

::Configurar DNSs
if %DNSPRIMARIO%==DHCP (
	::DNSs IPv4 en DHCP
	netsh interface ipv4 set dnsservers name"%interface%" source=dhcp
	echo DNS de %interface% establecido a DHCP
) else (
	::DNSs IPv4 estaticos
	netsh interface ipv4 add dnsserver name="%interface%" static %DNSPRIMARIO% index=1
	echo DNS Primario de %interface% establecido a %DNSPRIMARIO%
	netsh interface ipv4 add dnsserver name="%interface%" static %DNSSECUNDARIO% index=2
	echo DNS Secundario de %interface% establecido a %DNSSECUNDARIO%
)

echo LISTO!
pause
goto :main

::-----------------------------------------------------------------------------------------------------------------

:ConfigDHCP
cls
echo Estableciendo configuracion IPv4 de la interface %interface% en DHCP...
	netsh interface ipv4 set address name=”%interface%” source=dhcp
	echo %interface% establecida a DHCP
echo Estableciendo DNSs IPv4 en DHCP...
	netsh interface ipv4 set dnsservers name"%interface%" source=dhcp
	echo DNSs de %interface% establecido a DHCP
echo Todo listo!
pause
goto :main

::-----------------------------------------------------------------------------------------------------------------

:ConfigPerfiles
echo Perfiles disponibles: 
echo ----------------------------------------
echo 1 - AndroidAP
echo 2 - WifiTipico(192.168.0.x)
echo 99 - VOLVER AL MENU PRINCIPAL
echo ----------------------------------------
SET /P ConfigPerfilesMenu1="(1/2/99): "
if %ConfigPerfilesMenu1%==1 goto :PERFIL1
if %ConfigPerfilesMenu1%==2 goto :PERFIL2
if %ConfigPerfilesMenu1%==99 goto :main

::-----------------------------------------------------------------------------------------------------------------

:PERFIL1
set PERFIL_IPV4ADDR=192.168.43.52
set PERFIL_IPV4MASK=255.255.255.0
set PERFIL_IPV4GATEWAY=192.168.43.1
set PERFIL_DNSTYPE=dhcp
goto :ConfigPerfilesAplicar

::-----------------------------------------------------------------------------------------------------------------

:PERFIL2
set PERFIL_IPV4ADDR=192.168.0.31
set PERFIL_IPV4MASK=255.255.255.0
set PERFIL_IPV4GATEWAY=192.168.0.1
set PERFIL_DNSTYPE=static
set PERFIL_DNS1=8.8.8.8
set PERFIL_DNS2=192.168.0.1
goto :ConfigPerfilesAplicar

::-----------------------------------------------------------------------------------------------------------------

:ConfigPerfilesAplicar
cls
echo Configuracion del perfil seleccionado:

echo Estableciendo configuracion IPv4...
netsh interface ipv4 set address name="%interface%" static %IPV4ADDR% mask=%IPV4MASK% gateway=%IPV4GATEWAY%
if DNSTYPE==dhcp (
	netsh interface ipv4 set dnsservers name"%interface%" source=dhcp
	echo     DNS de %interface% establecido a DHCP
) else (
	netsh interface ipv4 add dnsserver name="%interface%" static %PERFIL_DNS1% index=1
		echo     DNS Primario de %interface% establecido a %PERFIL_DNS1%
	netsh interface ipv4 add dnsserver name="%interface%" static %PERFIL_DNS2% index=2
		echo     DNS Secundario de %interface% establecido a %PERFIL_DNS2%
)
netsh interface ipv4 show config "%interface%"
pause
goto :main



::-----------------------------------------------------------------------------------------------------------------

:bye
::Salir del programa
cls
echo Hasta luego!
pause
exit