#!/bin/bash
#Edit
for x in {101..110}
do
        mac=$(printf "%02d" $(($x % 10)))
        if [ $mac == "00" ]
        then
                mac=10
        fi
        for i in {0..50}
        do
                clientMacAddr=52:54:00:$mac:01:$(printf "%02d" $((0+$i)))
                mordorMacAddr=52:54:01:$mac:02:$(printf "%02d" $((0+$i)))
                isengardMacAddr=52:54:02:$mac:02:$(printf "%02d" $((0+$i)))
                shireMacAddr=52:54:00:$mac:03:$(printf "%02d" $((0+$i)))
                cat << EOF >> /etc/dhcp/dhcpd.conf
shared-network ${x}-${i} {

        subnet 10.$x.$i.0 netmask 255.255.255.0 {
                option routers 10.$x.$i.254;
                option subnet-mask 255.255.255.0;
                option domain-name "example.org";
                default-lease-time 21600;
                max-lease-time 43200;

                host client${x}-${i}.example.org {
                        option host-name "client${x}-${i}";
                        hardware ethernet $clientMacAddr;
                        fixed-address 10.$x.$i.2;
                }
                host shire${x}-${i}.example.org {
                        option host-name "shire${x}-${i}";
                        hardware ethernet $shireMacAddr;
                        fixed-address 10.$x.$i.3;
                }
        }
        subnet 10.$x.$((100+$i)).0 netmask 255.255.255.0 {
                option routers 10.$x.$((100+$i)).254;
                option subnet-mask 255.255.255.0;
                option domain-name "example.org";
                default-lease-time 21600;
                max-lease-time 43200;

                host mordor${x}-${i}.example.org {
                        option host-name "mordor${x}-${i}";
                        hardware ethernet $mordorMacAddr;
                        fixed-address 10.$x.$((100+$i)).1;
                }
        }
        subnet 10.$x.$((200+$i)).0 netmask 255.255.255.0 {
                option routers 10.$x.$((100+$i)).254;
                option subnet-mask 255.255.255.0;
                option domain-name "example.org";
                default-lease-time 21600;
                max-lease-time 43200;

                host isengard${x}-${i}.example.org {
                        option host-name "isengard${x}-${i}";
                        hardware ethernet $isengardMacAddr;
                        fixed-address 10.$x.$((200+$i)).1;
                }
        }
}
EOF
        done
done
