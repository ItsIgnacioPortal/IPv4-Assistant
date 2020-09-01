::---------------------------------------------------------------------

::Example of a PROFILE with STATIC IPv4 and STATIC DNS SERVERS

set PERFIL_IPV4TYPE=static
set PERFIL_IPV4ADDR=192.168.43.52
set PERFIL_IPV4MASK=255.255.255.0
set PERFIL_IPV4GATEWAY=192.168.43.1
set PERFIL_DNSTYPE=static
set PERFIL_DNS1=1.1.1.1
set PERFIL_DNS2=8.8.8.8




::Example of a PROFILE with STATIC IPv4 and DHCP DNS SERVERS

set PERFIL_IPV4TYPE=static
set PERFIL_IPV4ADDR=192.168.43.52
set PERFIL_IPV4MASK=255.255.255.0
set PERFIL_IPV4GATEWAY=192.168.43.1
set PERFIL_DNSTYPE=dhcp




::Example of a PROFILE with DHCP IPv4 and STATIC DNS SERVERS

set PERFIL_IPV4TYPE=dhcp
set PERFIL_DNSTYPE=static
set PERFIL_DNS1=1.1.1.1
set PERFIL_DNS2=8.8.8.8




::Example of a PROFILE with DHCP IPv4 and DHCP DNS SERVERS

set PERFIL_IPV4TYPE=dhcp
set PERFIL_DNSTYPE=dhcp


::---------------------------------------------------------------------
