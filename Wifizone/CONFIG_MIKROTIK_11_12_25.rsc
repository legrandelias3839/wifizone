# 2025-12-11 06:06:15 by RouterOS 7.19.4
# software id = 852L-HVUN
#
# model = L009UiGS-2HaxD
# serial number = HF2097CG5C7
/interface bridge
add name=BRIDGE_FAMILLE
add name=HOTSPOT
/interface ethernet
set [ find default-name=ether1 ] advertise=100M-baseT-full,1G-baseT-full \
    name="STARLINK 1 WAN"
set [ find default-name=ether5 ] name="ether5 M5 M2"
set [ find default-name=ether6 ] name="ether6 M2"
set [ find default-name=ether7 ] advertise=\
    10M-baseT-full,100M-baseT-full,1G-baseT-full rx-flow-control=auto \
    tx-flow-control=auto
set [ find default-name=ether8 ] advertise=\
    10M-baseT-full,100M-baseT-full,1G-baseT-full rx-flow-control=auto \
    tx-flow-control=auto
/interface wifi
set [ find default-name=wifi1 ] configuration.country="United States" .mode=\
    ap .ssid="D I S P L A Y   M K T" disabled=no name="Wifi 6" \
    security.authentication-types=wpa2-psk,wpa3-psk
/interface wireguard
add comment=back-to-home-vpn listen-port=43278 mtu=1420 name=back-to-home-vpn
/interface list
add name=WAN
add name=LAN
/ip hotspot profile
add dns-name=display.bj hotspot-address=10.10.10.1 html-directory=\
    "DISPLAY TEST" http-cookie-lifetime=4w2d login-by=\
    cookie,http-chap,https,http-pap,mac-cookie name=hsprof1
/ip hotspot user profile
set [ find default=yes ] on-login="Redirection Status Apr\E8s Login"
add name=Famille shared-users=3
add name=Admin shared-users=10
add name="Salari\E9" shared-users=2
add name=MTC shared-users=10
/ip pool
add name=vpn ranges=192.168.89.2-192.168.89.255
add name=dhcp_famille_pool5 ranges=11.11.11.2-11.11.11.254
add comment="ADRESSES dhcp_pool0 de Secours 3" name=dhcp_pool0Secours3 \
    ranges=10.10.40.1-10.10.40.254
/ip dhcp-server
add add-arp=yes address-pool=dhcp_famille_pool5 always-broadcast=yes \
    conflict-detection=no interface=BRIDGE_FAMILLE lease-time=10m name=dhcp2 \
    use-framed-as-classless=no
/ip pool
add comment="ADRESSES dhcp_pool0 de Secours 2" name=dhcp_pool0Secours2 \
    next-pool=dhcp_pool0Secours3 ranges=10.10.30.1-10.10.30.254
add comment="ADRESSES dhcp_pool0 de Secours 1" name=dhcp_pool0Secours1 \
    next-pool=dhcp_pool0Secours2 ranges=10.10.20.1-10.10.20.254
add name=dhcp_pool0 next-pool=dhcp_pool0Secours1 ranges=\
    10.10.10.31-10.10.10.254
/ip dhcp-server
add address-pool=dhcp_pool0 interface=HOTSPOT lease-time=3h name=dhcp1
/ip hotspot
add address-pool=dhcp_pool0 disabled=no interface=HOTSPOT name=hotspot1 \
    profile=hsprof1
/ip hotspot user profile
add address-pool=dhcp_pool0 keepalive-timeout=5m mac-cookie-timeout=1d name=\
    "TRIAL PROFILES" on-login=":local voucher \$user\
    \n:local loginDate [/system clock get date]\
    \n:local loginTime [/system clock get time]\
    \n:local suffix [:pick \$loginTime 6 11]\
    \n:local schedName (\"del-\" . \$voucher . \"-\" . \$suffix)\
    \n/system scheduler add name=\$schedName \\\
    \n  start-date=\$loginDate start-time=\$loginTime interval=\"1d\" \\\
    \n  on-event=\"/ip hotspot active remove [find user=\\\"\$voucher\\\"]; \\\
    \n            /ip hotspot user remove [find name=\\\"\$voucher\\\"]; \\\
    \n            /system scheduler remove [find name=\\\"\$schedName\\\"]\"" \
    rate-limit=2M/2M session-timeout=15m status-autorefresh=5m
add address-pool=dhcp_pool0 mac-cookie-timeout=2m name=2MIN on-login=":local v\
    oucher \$user\
    \n:local loginDate [/system clock get date]\
    \n:local loginTime [/system clock get time]\
    \n\
    \n/system scheduler add name=(\"del-\" . \$voucher) \\\
    \n    start-date=\$loginDate \\\
    \n    start-time=\$loginTime \\\
    \n    interval=\"00:02:00\" \\\
    \n    on-event=\"/ip hotspot active remove [find user=\\\"\$voucher\\\"]; \
    \\\
    \n              /ip hotspot user remove [find name=\\\"\$voucher\\\"]; \\\
    \n              /system scheduler remove [find name=(\\\"del-\\\" . \\\"\$\
    voucher\\\")]\"" parent-queue=none rate-limit=10M/10M session-timeout=2m
add address-pool=dhcp_pool0 mac-cookie-timeout=1d name=CODENORMAL on-login=":l\
    ocal voucher \$user\
    \n:local loginDate [/system clock get date]\
    \n:local loginTime [/system clock get time]\
    \n\
    \n/system scheduler add name=(\"del-\" . \$voucher) \\\
    \n    start-date=\$loginDate \\\
    \n    start-time=\$loginTime \\\
    \n    interval=\"1d\" \\\
    \n    on-event=\"/ip hotspot active remove [find user=\\\"\$voucher\\\"]; \
    \\\
    \n              /ip hotspot user remove [find name=\\\"\$voucher\\\"]; \\\
    \n              /system scheduler remove [find name=(\\\"del-\\\" . \\\"\$\
    voucher\\\")]\"" parent-queue=none rate-limit=15M/15M session-timeout=1d
add address-pool=dhcp_pool0 mac-cookie-timeout=1d name=CODEPRENIUM on-login=":\
    local voucher \$user\
    \n:local loginDate [/system clock get date]\
    \n:local loginTime [/system clock get time]\
    \n\
    \n/system scheduler add name=(\"del-\" . \$voucher) \\\
    \n    start-date=\$loginDate \\\
    \n    start-time=\$loginTime \\\
    \n    interval=\"1d\" \\\
    \n    on-event=\"/ip hotspot active remove [find user=\\\"\$voucher\\\"]; \
    \\\
    \n              /ip hotspot user remove [find name=\\\"\$voucher\\\"]; \\\
    \n              /system scheduler remove [find name=(\\\"del-\\\" . \\\"\$\
    voucher\\\")]\"" parent-queue=none rate-limit=25M/25M session-timeout=1d
add address-pool=dhcp_pool0 mac-cookie-timeout=2d name=CODEVIP on-login=":loca\
    l voucher \$user\
    \n:local loginDate [/system clock get date]\
    \n:local loginTime [/system clock get time]\
    \n\
    \n/system scheduler add name=(\"del-\" . \$voucher) \\\
    \n    start-date=\$loginDate \\\
    \n    start-time=\$loginTime \\\
    \n    interval=\"2d\" \\\
    \n    on-event=\"/ip hotspot active remove [find user=\\\"\$voucher\\\"]; \
    \\\
    \n              /ip hotspot user remove [find name=\\\"\$voucher\\\"]; \\\
    \n              /system scheduler remove [find name=(\\\"del-\\\" . \\\"\$\
    voucher\\\")]\"" parent-queue=none rate-limit=30M/30M session-timeout=2d
add address-pool=dhcp_pool0 name=CODEILLIMITE on-login=":local voucher \$user\
    \n:local loginDate [/system clock get date]\
    \n:local loginTime [/system clock get time]\
    \n\
    \n/system scheduler add name=(\"del-\" . \$voucher) \\\
    \n    start-date=\$loginDate \\\
    \n    start-time=\$loginTime \\\
    \n    interval=\"3d\" \\\
    \n    on-event=\"/ip hotspot active remove [find user=\\\"\$voucher\\\"]; \
    \\\
    \n              /ip hotspot user remove [find name=\\\"\$voucher\\\"]; \\\
    \n              /system scheduler remove [find name=(\\\"del-\\\" . \\\"\$\
    voucher\\\")]\"" parent-queue=none rate-limit=100M/100M session-timeout=\
    3d
add address-pool=dhcp_pool0 name=CODEFLASH on-login=":local voucher \$user\
    \n:local loginDate [/system clock get date]\
    \n:local loginTime [/system clock get time]\
    \n\
    \n/system scheduler add name=(\"del-\" . \$voucher) \\\
    \n    start-date=\$loginDate \\\
    \n    start-time=\$loginTime \\\
    \n    interval=\"3d\" \\\
    \n    on-event=\"/ip hotspot active remove [find user=\\\"\$voucher\\\"]; \
    \\\
    \n              /ip hotspot user remove [find name=\\\"\$voucher\\\"]; \\\
    \n              /system scheduler remove [find name=(\\\"del-\\\" . \\\"\$\
    voucher\\\")]\"" parent-queue=none rate-limit=50M/50M session-timeout=3d
add address-pool=dhcp_pool0 keepalive-timeout=30s name=3MIN on-login=":local v\
    oucher \$user\
    \n:local loginDate [/system clock get date]\
    \n:local loginTime [/system clock get time]\
    \n\
    \n/system scheduler add name=(\"del-\" . \$voucher) \\\
    \n    start-date=\$loginDate \\\
    \n    start-time=\$loginTime \\\
    \n    interval=\"00:03:00\" \\\
    \n    on-event=\"/ip hotspot active remove [find user=\\\"\$voucher\\\"]; \
    \\\
    \n              /ip hotspot user remove [find name=\\\"\$voucher\\\"]; \\\
    \n              /system scheduler remove [find name=(\\\"del-\\\" . \\\"\$\
    voucher\\\")]\"" session-timeout=3m status-autorefresh=10s
/port
set 0 name=serial0
/ppp profile
set *FFFFFFFE dns-server=10.10.10.1 local-address=192.168.89.1 \
    remote-address=vpn
/user group
add comment="API only" name=api policy="api,rest-api,!local,!telnet,!ssh,!ftp,\
    !reboot,!read,!write,!policy,!test,!winbox,!password,!web,!sniff,!sensitiv\
    e,!romon"
/user-manager limitation
add name=" 1-HEURE VITESSE NORMALE" rate-limit-rx=1000000B rate-limit-tx=\
    1000000B uptime-limit=1h
add name="1-HEURE VITESSE RAPIDE" rate-limit-rx=3000000B rate-limit-tx=\
    3000000B uptime-limit=1h
add name="2-JOUR VITESSE NORMALE" rate-limit-rx=1000000B rate-limit-tx=\
    1000000B uptime-limit=2d
add name="2-JOUR VITESSE RAPIDE" rate-limit-rx=3000000B rate-limit-tx=\
    3000000B uptime-limit=2d
add name="1-SEMAINE VITESSE NORMALE" rate-limit-rx=1000000B rate-limit-tx=\
    1000000B uptime-limit=1w
add name="1-SEMAINE VITESSE RAPIDE" rate-limit-rx=3000000B rate-limit-tx=\
    3000000B uptime-limit=1w
add name="5-HEURES VITESSE NORMALE" rate-limit-rx=1000000B rate-limit-tx=\
    1000000B uptime-limit=5h
add name="5-HEURES VITESSE RAPIDE" rate-limit-rx=3000000B rate-limit-tx=\
    3000000B uptime-limit=5h
add name="10-HEURES VITESSE NORMALE" rate-limit-rx=1000000B rate-limit-tx=\
    1000000B uptime-limit=10h
add name="1-MOIS VITESSE NORMALE" rate-limit-rx=1000000B rate-limit-tx=\
    1000000B uptime-limit=4w3d
add name="1-MOIS VITESSE RAPIDE" rate-limit-rx=3000000B rate-limit-tx=\
    3000000B uptime-limit=4w3d
add name="10-HEURES VITESSE RAPIDE" rate-limit-rx=3000000B rate-limit-tx=\
    3000000B uptime-limit=10h
add download-limit=10000000000B name=1-GIGAS upload-limit=10000000000B
add download-limit=50000000000B name=5-GIGAS upload-limit=50000000000B
add download-limit=100000000000B name=10-GIGAS upload-limit=100000000000B
add download-limit=200000000000B name=20-GIGAS upload-limit=200000000000B
add download-limit=150000000000B name=15-GIGAS upload-limit=150000000000B
add name="SOIREE 23H \E0 7H" uptime-limit=8h
add name=FAMILLE
/user-manager profile
add name="1-HEURE VITESSE NORMALE" name-for-users="1-HEURE VITESSE NORMALE" \
    price=200 starts-when=first-auth validity=1d
add name="1-HEURE VITESSE RAPIDE" name-for-users="1-HEURE VITESSE RAPIDE" \
    price=300 starts-when=first-auth validity=1d
add name="2-JOURS VITESSE NORMALE" name-for-users="2-JOURS VITESSE NORMALE" \
    price=500 starts-when=first-auth validity=2d
add name="2-JOURS VITESSE RAPIDE" name-for-users="2-JOURS VITESSE RAPIDE" \
    price=700 starts-when=first-auth validity=2d
add name="1-SEMAINE VITESSE NORMALE" name-for-users=\
    "1-SEMAINE VITESSE NORMALE" price=1500 starts-when=first-auth validity=1w
add name="1-SEMAINE VITESSE RAPIDE" name-for-users="1-SEMAINE VITESSE RAPIDE" \
    price=2000 starts-when=first-auth validity=1w
add name="1-MOIS VITESSE NORMALE" name-for-users="1-MOIS VITESSE NORMALE" \
    price=5000 starts-when=first-auth validity=4w3d
add name="1-MOIS VITESSE RAPIDE" name-for-users="1-MOIS VITESSE RAPIDE" \
    price=7000 starts-when=first-auth validity=4w3d
add name="5-HEURES VITESSE NORMALE" name-for-users="5-HEURES VITESSE NORMALE" \
    price=1000 starts-when=first-auth validity=1w
add name="5-HEURES VITESSE RAPIDE" name-for-users="5-HEURES VITESSE RAPIDE" \
    price=1200 starts-when=first-auth validity=1w
add name="10-HEURES VITESSE NORMALE" name-for-users=\
    "10-HEURES VITESSE NORMALE" price=2000 starts-when=first-auth validity=1w
add name="10-HEURES VITESSE RAPIDE" name-for-users="10-HEURES VITESSE RAPIDE" \
    price=2200 starts-when=first-auth validity=1w
add name=1-GIGA name-for-users=1-GIGA price=100 starts-when=first-auth \
    validity=1w
add name=5-GIGAS name-for-users=5-GIGAS price=300 starts-when=first-auth \
    validity=1w
add name=10-GIGAS name-for-users=10-GIGAS price=500 starts-when=first-auth \
    validity=1w
add name=15-GIGAS name-for-users=15-GIGAS price=1000 starts-when=first-auth \
    validity=1w
add name=20-GIGAS name-for-users=20-GIGAS price=1500 starts-when=first-auth \
    validity=1w
add name="SOIREE 23H A 7H" name-for-users="SOIREE 23H A 7H" price=200 \
    starts-when=first-auth validity=1d
add name=FAMILLE name-for-users=FAMILLE starts-when=first-auth validity=\
    unlimited
add name=4-HEURES name-for-users=4-HEURES price=200 starts-when=first-auth \
    validity=3d
/user-manager user
add name=soir shared-users=5
add name=benin
add name=5656
/disk settings
set auto-media-interface=HOTSPOT auto-media-sharing=yes auto-smb-sharing=yes
/interface bridge port
add bridge=HOTSPOT interface=ether2
add bridge=HOTSPOT interface=ether3
add bridge=HOTSPOT interface=ether4
add bridge=HOTSPOT interface="ether5 M5 M2"
add bridge=HOTSPOT interface="ether6 M2"
add bridge=BRIDGE_FAMILLE interface=ether7
add bridge=HOTSPOT interface=ether8
add bridge=HOTSPOT interface="Wifi 6"
/ip firewall connection tracking
set enabled=yes
/interface detect-internet
set detect-interface-list=all
/interface l2tp-server server
set enabled=yes use-ipsec=yes
/interface list member
add interface="STARLINK 1 WAN" list=WAN
add interface=HOTSPOT list=LAN
/interface ovpn-server server
add mac-address=FE:68:06:D1:C8:3D name=ovpn-server1
/ip address
add address=10.10.10.1/24 interface=HOTSPOT network=10.10.10.0
add address=11.11.11.1/24 interface=BRIDGE_FAMILLE network=11.11.11.0
/ip cloud
set back-to-home-vpn=enabled ddns-enabled=yes ddns-update-interval=10m
/ip cloud back-to-home-user
add allow-lan=yes comment="DISPLAY | L009UiGS-2HaxD" name="A73 de Elias" \
    private-key="+Oco+2rxqAxneRrPD71L+M7QDvL1U6DAAo3i8CjFa2c=" public-key=\
    "PHzNBpLYGoCLlWkX+Zu8wzV6v1tJ9IiBtH4ekeELyD0="
/ip dhcp-client
add interface="STARLINK 1 WAN"
/ip dhcp-server lease
add address=10.10.10.240 client-id=1:4c:60:ba:d2:e6:f0 comment=\
    "CAMERA BUREAU FENETRE" mac-address=4C:60:BA:D2:E6:F0 server=dhcp1
add address=10.10.10.160 comment="PC LENOVO" mac-address=EE:4A:BE:89:98:ED \
    use-src-mac=yes
add address=10.10.10.16 always-broadcast=yes client-id=1:98:25:4a:e1:e6:23 \
    comment="Ventilateur Bureau connectee" mac-address=98:25:4A:E1:E6:23
add address=10.10.10.34 client-id=1:ee:4a:be:ee:4a:be comment=\
    "REPETEUR WIFI RE200 BUREAU" mac-address=EE:4A:BE:EE:4A:BE server=dhcp1
/ip dhcp-server network
add address=10.10.10.0/24 dns-server=10.10.10.1,1.1.1.1 gateway=10.10.10.1
add address=10.10.20.0/24 comment="ADRESS SECOURS DE 10.10.10.0/24" \
    dns-server=10.10.10.1,1.1.1.1 gateway=10.10.20.1
add address=10.10.30.0/24 comment="ADRESS SECOURS DE 10.10.20.0/24" \
    dns-server=10.10.10.1,1.1.1.1 gateway=10.10.30.1
add address=10.10.40.0/24 comment="ADRESS SECOURS DE 10.10.30.0/24" \
    dns-server=10.10.10.1,1.1.1.1 gateway=10.10.40.1
add address=11.11.11.0/24 dns-server=11.11.11.1,1.1.1.1 gateway=11.11.11.1 \
    netmask=24
/ip dns
set allow-remote-requests=yes doh-max-concurrent-queries=300 \
    doh-max-server-connections=30 max-concurrent-queries=400 servers=\
    10.10.10.1,1.1.1.1
/ip dns static
add address=10.10.10.1 name=display.com ttl=1h type=A
add address=10.10.10.1 name=display.net ttl=1h type=A
add address=10.10.10.1 name=display.fr ttl=1h type=A
add address=10.10.10.2 name=play.bj ttl=5m type=A
/ip firewall filter
add action=accept chain=forward comment="Serveur tickets" dst-address=\
    10.10.10.160 dst-port=5656 protocol=tcp
add action=accept chain=output comment="443 SORTANT Fast VPN" dst-port=443 \
    protocol=tcp
add action=drop chain=forward comment="Bloquer non-authentifies" disabled=yes
add action=accept chain=input comment="HTTPS Elias Configuration" dst-port=\
    443 protocol=tcp
add action=accept chain=input comment="allow IPsec NAT" dst-port=4500 \
    protocol=udp
add action=accept chain=input comment="allow IKE" dst-port=500 protocol=udp
add action=accept chain=input comment="allow l2tp" dst-port=1701 protocol=udp
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=accept chain=forward src-address=10.10.10.160
add action=accept chain=input dst-address=10.10.10.160
add action=accept chain=input dst-address=10.10.10.1
add action=accept chain=input comment="HTTP Elias Configuration" dst-port=80 \
    protocol=tcp
add action=accept chain=input comment="FTP Elias Configuration" dst-port=21 \
    protocol=tcp
add action=accept chain=input comment="SMTP Elias Configuration" dst-port=25 \
    protocol=tcp
add action=accept chain=input comment="DNS Elias Configuration" dst-port=53 \
    protocol=tcp
add action=accept chain=input comment="UDP DNS Elias Configuration" dst-port=\
    53 protocol=udp
add action=accept chain=input comment="RDP Elias Configuration" dst-port=3389 \
    protocol=tcp
add action=accept chain=input comment="VPN PPTP Elias Configuration" \
    dst-port=1723 protocol=tcp
add action=accept chain=input comment="OPEN VPN Elias Configuration" \
    dst-port=1194 protocol=udp
add action=accept chain=input comment="MIKROTIK WINBOX Elias Configuration" \
    dst-port=8291 protocol=tcp
add action=accept chain=input comment="SIP Elias Configuration" dst-port=5060 \
    protocol=udp
add action=accept chain=input comment="RTSP Elias Configuration" dst-port=554 \
    protocol=tcp
add action=accept chain=input comment="RTSP Elias Configuration" dst-port=\
    8899 protocol=tcp
add action=accept chain=forward comment="Allow HTTP traffic Elias" dst-port=\
    80 protocol=tcp
add action=accept chain=hs-input comment=\
    "Allow DNS for authenticated users Elias" dst-port=53 protocol=udp
add action=accept chain=hs-unauth-to comment=\
    "Allow DNS to unauthenticated users Elias" dst-port=53 protocol=udp
add action=accept chain=input comment="Allow SSH access Elias" dst-port=22 \
    protocol=tcp
add action=accept chain=output comment="Allow outgoing DNS requests Elias" \
    dst-port=53 protocol=udp
add action=accept chain=pre-hs-input comment=\
    "Allow ICMP before Hotspot processing Elias" protocol=icmp
add action=accept chain=forward comment="Allow RTSP traffic Elias CAMERA" \
    dst-port=554 protocol=tcp
add action=accept chain=forward comment="Allow HTTP (camera) traffic Elias" \
    dst-port=8080 protocol=tcp
add action=accept chain=forward src-mac-address=28:D2:44:89:98:ED
add action=accept chain=input dst-port=80,443 protocol=tcp src-address=\
    192.168.1.127
add action=accept chain=input dst-port=8081 protocol=tcp
add action=accept chain=input comment="Allow API Access" dst-port=80 \
    protocol=tcp
add action=accept chain=input dst-port=8728 protocol=tcp
add action=accept chain=input comment="Allow API Access" dst-port=8728 log=\
    yes log-prefix="Allow API Access" protocol=tcp
add action=accept chain=input comment="Allow API-SSL  Access" dst-port=8729 \
    log=yes log-prefix="Allow API-SSL Access" protocol=tcp
add action=accept chain=input comment="Allow Established" connection-state=\
    established,related
add action=accept chain=input dst-port=8728 protocol=tcp
add action=accept chain=input disabled=yes dst-port=5000 protocol=tcp
add action=accept chain=input comment="Python Server Port 5656" dst-port=5656 \
    protocol=tcp
add action=accept chain=forward comment="Trafic etabli" connection-state=\
    established,related
add action=accept chain=forward comment="Autoriser VPN vers LAN" dst-address=\
    10.10.10.0/24 src-address=192.168.216.0/24
add action=accept chain=forward comment="Autoriser accs Emby depuis Internet" \
    dst-port=8096 protocol=tcp
/ip firewall mangle
add action=change-ttl chain=postrouting new-ttl=set:2 out-interface=HOTSPOT \
    passthrough=no
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface="STARLINK 1 WAN" \
    src-address=10.10.10.0/24
add action=masquerade chain=srcnat out-interface="STARLINK 1 WAN" \
    src-address=11.11.11.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=10.10.10.0/24
add action=masquerade chain=srcnat comment="masq. vpn traffic" src-address=\
    192.168.89.0/24
add action=redirect chain=hs-unauth comment=\
    "Redirect unauthenticated users to captive portal Elias" dst-port=80 \
    protocol=tcp to-ports=64872
add action=dst-nat chain=dstnat comment="EMBY HTTP ELIAS" dst-address=\
    10.10.10.2 dst-port=80 protocol=tcp to-addresses=10.10.10.2 to-ports=8096
add action=redirect chain=dstnat comment=\
    "redirection NAT pour utiliser le Web Proxy" dst-address=10.10.10.2 \
    dst-port=80 protocol=tcp to-ports=80
add action=dst-nat chain=dstnat comment=\
    "FILEZILLA Ports de Redirection 49152-65534" dst-port=49152-65534 \
    protocol=tcp to-addresses=10.10.10.2 to-ports=49152-65534
add action=dst-nat chain=dstnat comment="FILEZILLA Ports de Redirection 21" \
    dst-port=21 protocol=tcp to-addresses=10.10.10.2 to-ports=21
add action=dst-nat chain=dstnat comment=\
    "Redirection PORT EMBY pour acces distance" disabled=yes dst-port=8096 \
    protocol=tcp to-addresses=10.10.10.2
add action=dst-nat chain=dstnat comment="IP PUBLIQUE to IP LOCAL" \
    dst-address=129.222.206.192 dst-port=80 protocol=tcp to-addresses=\
    10.10.10.1 to-ports=80
add action=accept chain=dstnat dst-port=8728 protocol=tcp
add action=dst-nat chain=dstnat comment="Python Server Port 5656" \
    dst-address=10.10.10.1 dst-port=5656 protocol=tcp to-addresses=\
    10.10.10.160 to-ports=5656
add action=dst-nat chain=dstnat comment="Redirection Emby" dst-port=8096 \
    protocol=tcp to-addresses=10.10.10.2 to-ports=8096
/ip hotspot ip-binding
add address=10.10.10.2 comment="DISPLAY MEDIA" mac-address=00:E2:6C:68:48:66 \
    type=bypassed
add comment="Jaures Telephone" mac-address=F4:30:8B:C1:C6:02 server=hotspot1 \
    type=bypassed
add comment="WOUBI Telephone" disabled=yes mac-address=56:F8:B2:B0:A7:E5 \
    server=hotspot1 type=bypassed
add comment="Jaures Tablette" mac-address=00:08:22:E2:8F:FC server=hotspot1 \
    type=bypassed
add comment="PRISE connectee" mac-address=78:8C:B5:44:83:1B server=hotspot1 \
    type=bypassed
add comment="Ventilateur Bureau connectee" mac-address=98:25:4A:E1:E6:23 \
    type=bypassed
add comment="A30 Elias" mac-address=C0:BD:C8:CE:E0:41 server=hotspot1 type=\
    bypassed
add comment="Camera device 1 Mon peu" mac-address=02:00:00:00:00:00 server=\
    hotspot1 type=bypassed
add address=10.10.8.9 mac-address=EE:4A:BE:D2:E6:F0 server=hotspot1 type=\
    bypassed
add comment="Repeteur Wifi Mon Peu" mac-address=1C:3B:F3:EE:4A:BE server=\
    hotspot1 type=bypassed
add comment="A71 PAPA" mac-address=98:B8:BC:F3:15:00 type=bypassed
add comment="Camera mon peu" mac-address=EE:4A:BE:D4:0B:10 type=bypassed
add address=47.254.128.102 comment="Camera mon peu ip1" type=bypassed
add address=8.209.70.173 comment="Camera mon peu ip2" type=bypassed
add address=146.19.236.232 comment="Camera mon peu ip3" type=bypassed
add comment="NanoStation M2 N\C2\B02" mac-address=AC:8B:A9:C0:81:80 type=\
    bypassed
add comment="NanoStation M2 N\C2\B01" mac-address=AC:8B:A9:C0:80:BF type=\
    bypassed
add address=10.10.10.19 comment="CAMERA BUREAU" mac-address=4C:60:BA:D2:E6:F0 \
    type=bypassed
add address=10.10.10.240 comment="CAMERA BUREAU FENETRE" mac-address=\
    4C:60:BA:D2:E6:F0 type=bypassed
add address=10.10.10.27 comment="NanoStation M5" mac-address=\
    F4:92:BF:4C:FE:5C type=bypassed
add address=10.10.10.34 comment="REPETEUR WIFI RE200 BUREAU" mac-address=\
    EE:4A:BE:EE:4A:BE type=bypassed
add address=10.10.10.14 comment="TEST REPETEUR WIFI 2" type=bypassed
add address=10.10.10.14 comment="RE200 Repeteur Bureau" mac-address=\
    1C:3B:F3:EE:4A:BE type=bypassed
add comment="banni 1" disabled=yes mac-address=C6:95:29:43:7F:CB server=\
    hotspot1 type=blocked
add comment="banni 1" disabled=yes mac-address=8A:4A:BE:9D:A6:4C server=\
    hotspot1 type=blocked
add comment="banni 1" disabled=yes mac-address=7E:4A:BE:9F:5C:69 server=\
    hotspot1 type=blocked
add comment="banni 1" disabled=yes mac-address=7A:A3:A6:56:B6:41 server=\
    hotspot1 type=blocked
/ip hotspot user
add name=admin profile=Admin
add name=jaures profile=Famille
add name=ashley profile=Famille
add name=56565699 profile=Admin
add name=SERVEUR-DISPLAY profile=Admin
add limit-uptime=6h name=62771810 profile=*4 server=hotspot1
add name=mtc profile=MTC
add name=test profile=Famille
add name=X profile=Admin
add name=NOR8278 profile=CODENORMAL server=hotspot1
add name=NOR2500 profile=CODENORMAL server=hotspot1
add name=NOR6648 profile=CODENORMAL server=hotspot1
add name=NOR9501 profile=CODENORMAL server=hotspot1
add name=NOR2256 profile=CODENORMAL server=hotspot1
add name=NOR6017 profile=CODENORMAL server=hotspot1
add name=NOR9404 profile=CODENORMAL server=hotspot1
add name=NOR7419 profile=CODENORMAL server=hotspot1
add name=NOR5787 profile=CODENORMAL server=hotspot1
add name=NOR5873 profile=CODENORMAL server=hotspot1
add name=NOR1854 profile=CODENORMAL server=hotspot1
add disabled=yes name=NOR7031 profile=CODENORMAL server=hotspot1
add disabled=yes name=NOR2731 profile=CODENORMAL server=hotspot1
add name=NOR7012 profile=CODENORMAL server=hotspot1
add name=NOR6232 profile=CODENORMAL server=hotspot1
add name=NOR9678 profile=CODENORMAL server=hotspot1
add name=NOR8115 profile=CODENORMAL server=hotspot1
add name=NOR4156 profile=CODENORMAL server=hotspot1
add name=NOR1006 profile=CODENORMAL server=hotspot1
add name=NOR8711 profile=CODENORMAL server=hotspot1
add name=NOR2420 profile=CODENORMAL server=hotspot1
add name=NOR2856 profile=CODENORMAL server=hotspot1
add name=NOR3924 profile=CODENORMAL server=hotspot1
add name=NOR7688 profile=CODENORMAL server=hotspot1
add name=NOR5253 profile=CODENORMAL server=hotspot1
add name=NOR2553 profile=CODENORMAL server=hotspot1
add name=NOR3037 profile=CODENORMAL server=hotspot1
/ip hotspot walled-garden
add comment="place hotspot rules here" disabled=yes
add dst-host=wansview.com dst-port=554,8080 server=hotspot1
add dst-host=www.wansview.com dst-port=554,8080 server=hotspot1
add dst-host=cloud.wansview.com dst-port=554,8080 server=hotspot1
add dst-host=display.bj dst-port=80 server=hotspot1
add comment="Bouton Nous Contacter " dst-host="https://api.whatsapp.com/send/\
    \?phone=22956565699&text&type=phone_number&app_absent=0" dst-port=80 \
    server=hotspot1
add comment="Bouton Nous Contacter " dst-host=https://wa.me/22956565699 \
    dst-port=80 server=hotspot1
add comment="Bouton Nous Contacter " dst-host=https://api.whatsapp.com \
    dst-port=80 server=hotspot1
add dst-host=display.bj/audio/audio.mp3 path=\
    "/DISPLAY PORTAIL TEST 4/audio/audio.mp3" server=hotspot1
add dst-host=*.fedapay.com
add dst-host=*.wansview.com
add dst-host=*.p2pserver.com
add dst-host=*.wanscam.com
add comment=WANSWEW dst-host=sdc-portal.ajcloud.net
/ip ipsec profile
set [ find default=yes ] dpd-interval=2m dpd-maximum-failures=5
/ip kid-control
add fri=0s-1d mon=0s-1d name=system-dummy sat=0s-1d sun=0s-1d thu=0s-1d tue=\
    0s-1d tur-fri=0s-1d tur-mon=0s-1d tur-sat=0s-1d tur-sun=0s-1d tur-thu=\
    0s-1d tur-tue=0s-1d tur-wed=0s-1d wed=0s-1d
/ip proxy
set enabled=yes
/ip proxy access
add action=deny comment="DENY PLAY.BJ" dst-host=play.bj
/ip route
add dst-address=192.168.1.127 gateway=192.168.1.1
/ip service
set www-ssl disabled=no
/ip upnp
set allow-disable-external-interface=yes enabled=yes
/ip upnp interfaces
add interface=HOTSPOT type=internal
add interface="STARLINK 1 WAN" type=external
/ppp secret
add name=vpn
add name=56565699 profile=default-encryption
/radius
add address=127.0.0.1 require-message-auth=no timeout=300ms
/radius incoming
set accept=yes
/system clock
set time-zone-autodetect=no time-zone-name=Africa/Porto-Novo
/system identity
set name=DISPLAY
/system logging
add action=disk prefix=-> topics=hotspot,info,debug
/system ntp client
set enabled=yes
/system ntp client servers
add address=time.google.com
add address=pool.ntp.org
/system routerboard settings
set enter-setup-on=delete-key
/system scheduler
add comment="Mikhmon Expire Monitor" interval=1m name=Mikhmon-Expire-Monitor \
    on-event=":local dateint do={:local montharray ( \"jan\",\"feb\",\"mar\",\
    \"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );\
    :local days [ :pick \$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [\
    \_:pick \$d 7 11 ];:local monthint ([ :find \$montharray \$month]);:local \
    month (\$monthint + 1);:if ( [len \$month] = 1) do={:local zero (\"0\");:r\
    eturn [:tonum (\"\$year\$zero\$month\$days\")];} else={:return [:tonum (\"\
    \$year\$month\$days\")];}};:local timeint do={:local hours [ :pick \$t 0 2\
    \_];:local minutes [ :pick \$t 3 5 ];:return (\$hours * 60 + \$minutes) ;}\
    ;:local date [ /system clock get date ];:local time [ /system clock get ti\
    me ];:local today [\$dateint d=\$date] ;:local curtime [\$timeint t=\$time\
    ] ;:local tyear [ :pick \$date 7 11 ];:local lyear (\$tyear-1);:foreach i \
    in [ /ip hotspot user find where comment~\"/\$tyear\" || comment~\"/\$lyea\
    r\" ] do={:local comment [ /ip hotspot user get \$i comment]; :local limit\
    \_[ /ip hotspot user get \$i limit-uptime]; :local name [ /ip hotspot user\
    \_get \$i name]; :local gettime [:pic \$comment 12 20];:if ([:pic \$commen\
    t 3] = \"/\" and [:pic \$comment 6] = \"/\") do={:local expd [\$dateint d=\
    \$comment] ;:local expt [\$timeint t=\$gettime] ;:if ((\$expd < \$today an\
    d \$expt < \$curtime) or (\$expd < \$today and \$expt > \$curtime) or (\$e\
    xpd = \$today and \$expt < \$curtime) and \$limit != \"00:00:01\") do={ :i\
    f ([:pic \$comment 21] = \"N\") do={[ /ip hotspot user set limit-uptime=1s\
    \_\$i ];[ /ip hotspot active remove [find where user=\$name] ];} else={[ /\
    ip hotspot user remove \$i ];[ /ip hotspot active remove [find where user=\
    \$name] ];}}}}}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-05-16 start-time=00:00:00
add comment="Monitor Profile 2MIN" interval=2m39s name=2MIN on-event=":local d\
    ateint do={:local montharray ( \"jan\",\"feb\",\"mar\",\"apr\",\"may\",\"j\
    un\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );:local days [ :pick\
    \_\$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [ :pick \$d 7 11 ];\
    :local monthint ([ :find \$montharray \$month]);:local month (\$monthint +\
    \_1);:if ( [len \$month] = 1) do={:local zero (\"0\");:return [:tonum (\"\
    \$year\$zero\$month\$days\")];} else={:return [:tonum (\"\$year\$month\$da\
    ys\")];}}; :local timeint do={ :local hours [ :pick \$t 0 2 ]; :local minu\
    tes [ :pick \$t 3 5 ]; :return (\$hours * 60 + \$minutes) ; }; :local date\
    \_[ /system clock get date ]; :local time [ /system clock get time ]; :loc\
    al today [\$dateint d=\$date] ; :local curtime [\$timeint t=\$time] ; :for\
    each i in [ /ip hotspot user find where profile=\"2MIN\" ] do={ :local com\
    ment [ /ip hotspot user get \$i comment]; :local name [ /ip hotspot user g\
    et \$i name]; :local gettime [:pic \$comment 12 20]; :if ([:pic \$comment \
    3] = \"/\" and [:pic \$comment 6] = \"/\") do={:local expd [\$dateint d=\$\
    comment] ; :local expt [\$timeint t=\$gettime] ; :if ((\$expd < \$today an\
    d \$expt < \$curtime) or (\$expd < \$today and \$expt > \$curtime) or (\$e\
    xpd = \$today and \$expt < \$curtime)) do={ [ /ip hotspot user remove \$i \
    ]; [ /ip hotspot active remove [find where user=\$name] ];}}}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-05-16 start-time=05:59:30
add comment="Monitor Profile CODENORMAL" interval=2m37s name=CODENORMAL \
    on-event=":local dateint do={:local montharray ( \"jan\",\"feb\",\"mar\",\
    \"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );\
    :local days [ :pick \$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [\
    \_:pick \$d 7 11 ];:local monthint ([ :find \$montharray \$month]);:local \
    month (\$monthint + 1);:if ( [len \$month] = 1) do={:local zero (\"0\");:r\
    eturn [:tonum (\"\$year\$zero\$month\$days\")];} else={:return [:tonum (\"\
    \$year\$month\$days\")];}}; :local timeint do={ :local hours [ :pick \$t 0\
    \_2 ]; :local minutes [ :pick \$t 3 5 ]; :return (\$hours * 60 + \$minutes\
    ) ; }; :local date [ /system clock get date ]; :local time [ /system clock\
    \_get time ]; :local today [\$dateint d=\$date] ; :local curtime [\$timein\
    t t=\$time] ; :foreach i in [ /ip hotspot user find where profile=\"CODENO\
    RMAL\" ] do={ :local comment [ /ip hotspot user get \$i comment]; :local n\
    ame [ /ip hotspot user get \$i name]; :local gettime [:pic \$comment 12 20\
    ]; :if ([:pic \$comment 3] = \"/\" and [:pic \$comment 6] = \"/\") do={:lo\
    cal expd [\$dateint d=\$comment] ; :local expt [\$timeint t=\$gettime] ; :\
    if ((\$expd < \$today and \$expt < \$curtime) or (\$expd < \$today and \$e\
    xpt > \$curtime) or (\$expd = \$today and \$expt < \$curtime)) do={ [ /ip \
    hotspot user remove \$i ]; [ /ip hotspot active remove [find where user=\$\
    name] ];}}}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-07-15 start-time=04:16:15
add comment="Monitor Profile CODEPRENIUM" interval=2m41s name=CODEPRENIUM \
    on-event=":local dateint do={:local montharray ( \"jan\",\"feb\",\"mar\",\
    \"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );\
    :local days [ :pick \$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [\
    \_:pick \$d 7 11 ];:local monthint ([ :find \$montharray \$month]);:local \
    month (\$monthint + 1);:if ( [len \$month] = 1) do={:local zero (\"0\");:r\
    eturn [:tonum (\"\$year\$zero\$month\$days\")];} else={:return [:tonum (\"\
    \$year\$month\$days\")];}}; :local timeint do={ :local hours [ :pick \$t 0\
    \_2 ]; :local minutes [ :pick \$t 3 5 ]; :return (\$hours * 60 + \$minutes\
    ) ; }; :local date [ /system clock get date ]; :local time [ /system clock\
    \_get time ]; :local today [\$dateint d=\$date] ; :local curtime [\$timein\
    t t=\$time] ; :foreach i in [ /ip hotspot user find where profile=\"CODEPR\
    ENIUM\" ] do={ :local comment [ /ip hotspot user get \$i comment]; :local \
    name [ /ip hotspot user get \$i name]; :local gettime [:pic \$comment 12 2\
    0]; :if ([:pic \$comment 3] = \"/\" and [:pic \$comment 6] = \"/\") do={:l\
    ocal expd [\$dateint d=\$comment] ; :local expt [\$timeint t=\$gettime] ; \
    :if ((\$expd < \$today and \$expt < \$curtime) or (\$expd < \$today and \$\
    expt > \$curtime) or (\$expd = \$today and \$expt < \$curtime)) do={ [ /ip\
    \_hotspot user remove \$i ]; [ /ip hotspot active remove [find where user=\
    \$name] ];}}}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-07-15 start-time=01:24:45
add comment="Monitor Profile CODEVIP" interval=2m25s name=CODEVIP on-event=":l\
    ocal dateint do={:local montharray ( \"jan\",\"feb\",\"mar\",\"apr\",\"may\
    \",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );:local days [\
    \_:pick \$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [ :pick \$d 7\
    \_11 ];:local monthint ([ :find \$montharray \$month]);:local month (\$mon\
    thint + 1);:if ( [len \$month] = 1) do={:local zero (\"0\");:return [:tonu\
    m (\"\$year\$zero\$month\$days\")];} else={:return [:tonum (\"\$year\$mont\
    h\$days\")];}}; :local timeint do={ :local hours [ :pick \$t 0 2 ]; :local\
    \_minutes [ :pick \$t 3 5 ]; :return (\$hours * 60 + \$minutes) ; }; :loca\
    l date [ /system clock get date ]; :local time [ /system clock get time ];\
    \_:local today [\$dateint d=\$date] ; :local curtime [\$timeint t=\$time] \
    ; :foreach i in [ /ip hotspot user find where profile=\"CODEVIP\" ] do={ :\
    local comment [ /ip hotspot user get \$i comment]; :local name [ /ip hotsp\
    ot user get \$i name]; :local gettime [:pic \$comment 12 20]; :if ([:pic \
    \$comment 3] = \"/\" and [:pic \$comment 6] = \"/\") do={:local expd [\$da\
    teint d=\$comment] ; :local expt [\$timeint t=\$gettime] ; :if ((\$expd < \
    \$today and \$expt < \$curtime) or (\$expd < \$today and \$expt > \$curtim\
    e) or (\$expd = \$today and \$expt < \$curtime)) do={ [ /ip hotspot user r\
    emove \$i ]; [ /ip hotspot active remove [find where user=\$name] ];}}}" \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-07-16 start-time=03:11:14
add comment="Monitor Profile CODEILLIMITE" interval=2m32s name=CODEILLIMITE \
    on-event=":local dateint do={:local montharray ( \"jan\",\"feb\",\"mar\",\
    \"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );\
    :local days [ :pick \$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [\
    \_:pick \$d 7 11 ];:local monthint ([ :find \$montharray \$month]);:local \
    month (\$monthint + 1);:if ( [len \$month] = 1) do={:local zero (\"0\");:r\
    eturn [:tonum (\"\$year\$zero\$month\$days\")];} else={:return [:tonum (\"\
    \$year\$month\$days\")];}}; :local timeint do={ :local hours [ :pick \$t 0\
    \_2 ]; :local minutes [ :pick \$t 3 5 ]; :return (\$hours * 60 + \$minutes\
    ) ; }; :local date [ /system clock get date ]; :local time [ /system clock\
    \_get time ]; :local today [\$dateint d=\$date] ; :local curtime [\$timein\
    t t=\$time] ; :foreach i in [ /ip hotspot user find where profile=\"CODEIL\
    LIMITE\" ] do={ :local comment [ /ip hotspot user get \$i comment]; :local\
    \_name [ /ip hotspot user get \$i name]; :local gettime [:pic \$comment 12\
    \_20]; :if ([:pic \$comment 3] = \"/\" and [:pic \$comment 6] = \"/\") do=\
    {:local expd [\$dateint d=\$comment] ; :local expt [\$timeint t=\$gettime]\
    \_; :if ((\$expd < \$today and \$expt < \$curtime) or (\$expd < \$today an\
    d \$expt > \$curtime) or (\$expd = \$today and \$expt < \$curtime)) do={ [\
    \_/ip hotspot user remove \$i ]; [ /ip hotspot active remove [find where u\
    ser=\$name] ];}}}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-07-16 start-time=02:50:12
add comment="Monitor Profile CODEFLASH" interval=2m21s name=CODEFLASH \
    on-event=":local dateint do={:local montharray ( \"jan\",\"feb\",\"mar\",\
    \"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );\
    :local days [ :pick \$d 4 6 ];:local month [ :pick \$d 0 3 ];:local year [\
    \_:pick \$d 7 11 ];:local monthint ([ :find \$montharray \$month]);:local \
    month (\$monthint + 1);:if ( [len \$month] = 1) do={:local zero (\"0\");:r\
    eturn [:tonum (\"\$year\$zero\$month\$days\")];} else={:return [:tonum (\"\
    \$year\$month\$days\")];}}; :local timeint do={ :local hours [ :pick \$t 0\
    \_2 ]; :local minutes [ :pick \$t 3 5 ]; :return (\$hours * 60 + \$minutes\
    ) ; }; :local date [ /system clock get date ]; :local time [ /system clock\
    \_get time ]; :local today [\$dateint d=\$date] ; :local curtime [\$timein\
    t t=\$time] ; :foreach i in [ /ip hotspot user find where profile=\"CODEFL\
    ASH\" ] do={ :local comment [ /ip hotspot user get \$i comment]; :local na\
    me [ /ip hotspot user get \$i name]; :local gettime [:pic \$comment 12 20]\
    ; :if ([:pic \$comment 3] = \"/\" and [:pic \$comment 6] = \"/\") do={:loc\
    al expd [\$dateint d=\$comment] ; :local expt [\$timeint t=\$gettime] ; :i\
    f ((\$expd < \$today and \$expt < \$curtime) or (\$expd < \$today and \$ex\
    pt > \$curtime) or (\$expd = \$today and \$expt < \$curtime)) do={ [ /ip h\
    otspot user remove \$i ]; [ /ip hotspot active remove [find where user=\$n\
    ame] ];}}}" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2025-07-21 start-time=03:40:57
/system script
add dont-require-permissions=no name="Redirection Status Apres Login" owner=\
    admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local redirectUrl \"http://display.bj/status\"\
    \n:log info \"User \$user has logged in. Redirecting to \$redirectUrl\"\
    \n/tool fetch url=\$redirectUrl keep-result=no\
    \n"
add dont-require-permissions=yes name=script1 owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/\
    system script\r\
    \nadd name=\"VoucherCreation\" source={\r\
    \n    # D\E9finir les variables\r\
    \n    :local username \"utilisateur_test\";  # Remplacer par un nom d'util\
    isateur sp\E9cifique ou une m\E9thode pour obtenir le nom d'utilisateur\r\
    \n    :local profile \"1-HOUR VITESSE NORMALE\";  # Remplacer par le profi\
    l souhait\E9\r\
    \n\r\
    \n    # Cr\E9er un voucher avec User Manager\r\
    \n    /user-manager user create-voucher profile=\$profile user=\$username\
    \r\
    \n}\r\
    \n"
add dont-require-permissions=no name=VoucherCreation owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="\
    \r\
    \n    # D\E9finir les variables\r\
    \n    :local username \"utilisateur_test\";  # Remplacer par un nom d'util\
    isateur sp\E9cifique ou une m\E9thode pour obtenir le nom d'utilisateur\r\
    \n    :local profile \"1-HOUR VITESSE NORMALE\";  # Remplacer par le profi\
    l souhait\E9\r\
    \n\r\
    \n    # Cr\E9er un voucher avec User Manager\r\
    \n    /user-manager user create-voucher profile=\$profile user=\$username\
    \r\
    \n"
add comment="TEST 31 DECEMBRE" dont-require-permissions=yes name=\
    Fedapay_callback owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/\
    system script add name=fedapay_callback source=\"\
    \n:log info \\\"Webhook re\C3\A7u depuis FedaPay\\\";\
    \n\
    \n# Exemple : Cr\C3\A9er un utilisateur avec des param\C3\A8tres fixes\
    \n/ip hotspot user add name=\\\"user_\$([:rand 1000 9999])\\\" password=\\\
    \"pass_\$([:rand 1000 9999])\\\" profile=default;\
    \n:log info \\\"Utilisateur cr\C3\A9\C3\A9 avec succ\C3\A8s\\\";\
    \n\""
add dont-require-permissions=yes name="FedaPay long script" owner=admin \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    source="/system script add name=fedapay_callback source=\"\
    \n:local username \\\"user_\$([:rand 1000 9999])\\\";\
    \n:local password \\\"pass_\$([:rand 1000 9999])\\\";\
    \n\
    \n/ip hotspot user add name=\\\$username password=\\\$password profile=def\
    ault;\
    \n\
    \n:log info \\\"Utilisateur cr\C3\A9\C3\A9 : \\\$username avec mot de pass\
    e : \\\$password\\\";\
    \n\
    \n# Construire l'URL de redirection\
    \n:local redirectUrl \\\"http://129.222.206.192/login\?username=\\\$userna\
    me&password=\\\$password\\\";\
    \n:log info \\\"Redirection vers : \\\$redirectUrl\\\";\
    \n\
    \n/tool fetch url=\\\$redirectUrl mode=http;\
    \n\""
add comment=mikhmon dont-require-permissions=no name="2025-05-16-|-15:45:44-|-\
    DUN-|-200-|-10.10.10.95-|-FE:40:C6:82:5D:E4-|-2m-|-2MIN-|-up-631-05.16.25-\
    2MTEST" owner=202-16 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-05-16
add comment=mikhmon dont-require-permissions=no name="2025-05-16-|-15:48:36-|-\
    RVF-|-200-|-10.10.10.95-|-FE:40:C6:82:5D:E4-|-2m-|-2MIN-|-up-631-05.16.25-\
    2MTEST" owner=202-16 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-05-16
add comment=mikhmon dont-require-permissions=no name="2025-07-18-|-06:09:17-|-\
    139-|-100-|-10.10.10.65-|-6A:4A:BE:2E:A6:93-|-1d-|-CODENORMAL-|-" owner=\
    202-18 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-18
add comment=mikhmon dont-require-permissions=no name="2025-07-18-|-06:10:59-|-\
    608-|-100-|-10.10.10.65-|-6A:4A:BE:2E:A6:93-|-1d-|-CODENORMAL-|-" owner=\
    202-18 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-18
add comment=mikhmon dont-require-permissions=no name="2025-07-18-|-06:43:00-|-\
    1174-|-100-|-10.10.10.65-|-6A:4A:BE:2E:A6:93-|-1d-|-CODENORMAL-|-" owner=\
    202-18 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-18
add comment=mikhmon dont-require-permissions=no name="2025-07-18-|-08:24:16-|-\
    3168-|-100-|-10.10.10.58-|-EE:4A:BE:A1:E3:07-|-1d-|-CODENORMAL-|-" owner=\
    202-18 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-18
add comment=mikhmon dont-require-permissions=no name="2025-07-18-|-19:10:19-|-\
    3896-|-100-|-10.10.10.221-|-36:D0:2C:5E:F2:8A-|-1d-|-CODENORMAL-|-" \
    owner=202-18 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-18
add comment=mikhmon dont-require-permissions=no name="2025-07-19-|-05:21:38-|-\
    4437-|-100-|-10.10.10.250-|-6A:4A:BE:2E:A6:93-|-1d-|-CODENORMAL-|-" \
    owner=202-19 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-19
add comment=mikhmon dont-require-permissions=no name="2025-07-20-|-13:48:13-|-\
    7966-|-100-|-10.10.10.253-|-5E:4A:BE:7E:8B:E9-|-1d-|-CODENORMAL-|-" \
    owner=202-20 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-20
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-04:08:11-|-\
    3737-|-100-|-10.10.10.79-|-5E:4A:BE:7E:8B:E9-|-1d-|-CODENORMAL-|-" owner=\
    202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-04:58:45-|-\
    9683-|-100-|-10.10.10.79-|-5E:4A:BE:7E:8B:E9-|-1d-|-CODENORMAL-|-" owner=\
    202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-05:58:30-|-\
    4448-|-100-|-10.10.10.79-|-5E:4A:BE:7E:8B:E9-|-1d-|-CODENORMAL-|-" owner=\
    202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-08:16:17-|-\
    1783-|-200-|-10.10.10.79-|-5E:4A:BE:7E:8B:E9-|-1d-|-CODEPRENIUM-|-" \
    owner=202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-09:24:03-|-\
    VIP1665-|-300-|-10.10.10.79-|-5E:4A:BE:7E:8B:E9-|-1d-|-CODEVIP-|-" owner=\
    202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-09:29:07-|-\
    VIP7494-|-300-|-10.10.10.79-|-5E:4A:BE:7E:8B:E9-|-1d-|-CODEVIP-|-" owner=\
    202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-15:26:09-|-\
    NOR9834-|-100-|-10.10.10.79-|-5E:4A:BE:7E:8B:E9-|-1d-|-CODENORMAL-|-" \
    owner=202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-22:10:58-|-\
    NOR9465-|-100-|-10.10.10.52-|-2A:4A:BE:4A:57:4F-|-1d-|-CODENORMAL-|-" \
    owner=202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-21-|-22:33:25-|-\
    NOR3460-|-100-|-10.10.10.81-|-92:6A:58:B5:7D:16-|-1d-|-CODENORMAL-|-" \
    owner=202-21 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-21
add comment=mikhmon dont-require-permissions=no name="2025-07-23-|-00:54:40-|-\
    NOR1982-|-100-|-10.10.10.43-|-1E:4A:BE:81:FC:CC-|-1d 00:00:00-|-CODENORMAL\
    -|-" owner=202-23 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    2025-07-23
/tool bandwidth-server
set enabled=no
/tool e-mail
set from=display56565699@gmail.com port=587 server=smtp.gmail.com tls=\
    starttls user=display56565699@gmail.com
/tool romon
set enabled=yes
/tool sniffer
set filter-dst-mac-address=EE:F1:0E:14:3C:5A/FF:FF:FF:FF:FF:FF \
    filter-interface=HOTSPOT streaming-server=10.10.10.11
/tool traffic-monitor
add comment="Surveiller le port de mon VPN" interface=HOTSPOT name=\
    "Elias App Traffic" threshold=1000
/user-manager
set certificate=*0 enabled=yes require-message-auth=no use-profiles=yes
/user-manager advanced
set web-private-username=display
/user-manager profile-limitation
add limitation=" 1-HEURE VITESSE NORMALE" profile="1-HEURE VITESSE NORMALE"
add limitation=1-GIGAS profile=1-GIGA
add limitation="1-HEURE VITESSE RAPIDE" profile="1-HEURE VITESSE RAPIDE"
add limitation="1-MOIS VITESSE NORMALE" profile="1-MOIS VITESSE NORMALE"
add limitation="1-MOIS VITESSE RAPIDE" profile="1-MOIS VITESSE RAPIDE"
add limitation="1-SEMAINE VITESSE NORMALE" profile=\
    "1-SEMAINE VITESSE NORMALE"
add limitation="1-SEMAINE VITESSE RAPIDE" profile="1-SEMAINE VITESSE RAPIDE"
add limitation="2-JOUR VITESSE NORMALE" profile="2-JOURS VITESSE NORMALE"
add limitation="2-JOUR VITESSE RAPIDE" profile="2-JOURS VITESSE RAPIDE"
add limitation=5-GIGAS profile=5-GIGAS
add limitation="5-HEURES VITESSE NORMALE" profile="5-HEURES VITESSE NORMALE"
add limitation="5-HEURES VITESSE RAPIDE" profile="5-HEURES VITESSE RAPIDE"
add limitation=10-GIGAS profile=10-GIGAS
add limitation="10-HEURES VITESSE NORMALE" profile=\
    "10-HEURES VITESSE NORMALE"
add limitation="10-HEURES VITESSE RAPIDE" profile="10-HEURES VITESSE RAPIDE"
add limitation=15-GIGAS profile=15-GIGAS
add limitation=20-GIGAS profile=20-GIGAS
add from-time=23h limitation="SOIREE 23H \E0 7H" profile="SOIREE 23H A 7H" \
    till-time=7h
add limitation=FAMILLE profile=FAMILLE
/user-manager router
add address=127.0.0.1 name=display.bj
/user-manager user-profile
add profile="SOIREE 23H A 7H" user=soir
