#!/bin/bash
serverIp="xx.xx.xx.xx"
for i in $(seq 0 $2)
do
        if [ "$1" == "101" ]
        then
                port=$(( 33300+$i ))
        elif [ "$1" == "102" ]
        then
                port=$(( 33351+$i ))
        elif [ "$1" == "103" ]
        then
                port=$(( 33402+$i ))
        elif [ "$1" == "104" ]
        then
                port=$(( 33453+$i ))
        elif [ "$1" == "105" ]
        then
                port=$(( 33504+$i ))
        elif [ "$1" == "106" ]
        then
                port=$(( 33555+$i ))
        elif [ "$1" == "107" ]
        then
                port=$(( 33606+$i ))
        elif [ "$1" == "108" ]
        then
                port=$(( 33657+$i ))
        elif [ "$1" == "109" ]
        then
                port=$(( 33708+$i ))
        elif [ "$1" == "110" ]
        then
                port=$(( 33759+$i ))
        fi
        cat <<- EOF > /etc/openvpn/daemonConf/vpn_$1_$i.conf
        local $serverIp
        port $port
        proto udp
        dev tap_$1_$i
        ca /etc/openvpn/ca.crt
        cert /etc/openvpn/vpn.crt
        key /etc/openvpn/vpn.key
        dh /etc/openvpn/dh2048.pem
        mode server
        tls-server
        client-config-dir /etc/openvpn/ccd_${1}
        push "dhcp-option DNS xx.xx.xx.xx"
        push "dhcp-option DNS xx.xx.xx.xx"
        ping 10
        ping-restart 60
        ping-exit 3600
        tls-auth /etc/openvpn/ta.key 0 # This file is secret
        comp-lzo
        persist-key
        persist-tun
        status openvpn-status.log
        verb 4
        mute 5
        plugin /usr/lib64/openvpn/plugins/openvpn-plugin-auth-pam.so login
        client-cert-not-required
        script-security 3
        username-as-common-name
        client-to-client
        EOF

        cat <<- EOF > /etc/openvpn/sabitler/openvpn_$1_$i
        push-reset
        ifconfig-push 10.$1.$i.1 255.255.255.0
        push "route $serverIp 255.255.255.255 net_gateway"
        EOF
done

