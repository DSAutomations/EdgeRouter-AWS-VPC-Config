#!/bin/bash

read -p "Enter the CIDR block for your VPC (0.0.0.0/0 notation): " cidrblock

psk0=$(awk -v n=1 '/- Pre-Shared Key/ { if (++count == n) {print $NF}}' $1)
psk1=$(awk -v n=2 '/- Pre-Shared Key/ { if (++count == n) {print $NF}}' $1)

vgw0=$(awk -v n=1 '/- Virtual Private Gateway/ { if (++count == n) {print $NF}}' $1)
vgw1=$(awk -v n=3 '/- Virtual Private Gateway/ { if (++count == n) {print $NF}}' $1)

eth0=$(awk -v n=1 '/- Customer Gateway/ { if (++count == n) {print $NF}}' $1)
vti0=$(awk -v n=2 '/- Customer Gateway/ { if (++count == n) {print $NF}}' $1)
vti1=$(awk -v n=4 '/- Customer Gateway/ { if (++count == n) {print $NF}}' $1)

echo "set vpn ipsec ike-group FOO0 key-exchange ikev1"
echo "set vpn ipsec ike-group FOO0 lifetime 28800"
echo "set vpn ipsec ike-group FOO0 proposal 1 dh-group 2"
echo "set vpn ipsec ike-group FOO0 proposal 1 encryption aes128"
echo "set vpn ipsec ike-group FOO0 proposal 1 hash sha1"
echo "set vpn ipsec ike-group FOO0 dead-peer-detection action restart"
echo "set vpn ipsec ike-group FOO0 dead-peer-detection interval 15"
echo "set vpn ipsec ike-group FOO0 dead-peer-detection timeout 30"
echo "set vpn ipsec esp-group FOO0 lifetime 3600"
echo "set vpn ipsec esp-group FOO0 pfs enable"
echo "set vpn ipsec esp-group FOO0 proposal 1 encryption aes128"
echo "set vpn ipsec esp-group FOO0 proposal 1 hash sha1"
echo "set vpn ipsec site-to-site peer $vgw0 authentication mode pre-shared-secret"
echo "set vpn ipsec site-to-site peer $vgw0 authentication pre-shared-secret $psk0"
echo "set vpn ipsec site-to-site peer $vgw0 connection-type initiate"
echo "set vpn ipsec site-to-site peer $vgw0 description IPsecAWS"
echo "set vpn ipsec site-to-site peer $vgw0 local-address $eth0"
echo "set vpn ipsec site-to-site peer $vgw0 ike-group FOO0"
echo "set vpn ipsec site-to-site peer $vgw0 vti bind vti0"
echo "set vpn ipsec site-to-site peer $vgw0 vti esp-group FOO0"
echo "set vpn ipsec site-to-site peer $vgw1 authentication mode pre-shared-secret"
echo "set vpn ipsec site-to-site peer $vgw1 authentication pre-shared-secret $psk1"
echo "set vpn ipsec site-to-site peer $vgw1 connection-type initiate"
echo "set vpn ipsec site-to-site peer $vgw1 description IPsecAWS"
echo "set vpn ipsec site-to-site peer $vgw1 local-address $eth0"
echo "set vpn ipsec site-to-site peer $vgw1 ike-group FOO0"
echo "set vpn ipsec site-to-site peer $vgw1 vti bind vti1"
echo "set vpn ipsec site-to-site peer $vgw1 vti esp-group FOO0"
echo "set interfaces vti vti0 address $vti0"
echo "set interfaces vti vti1 address $vti1"
echo "set firewall options mss-clamp interface-type vti"
echo "set firewall options mss-clamp mss 1379"
echo "set protocols static interface-route $cidrblock next-hop-interface vti0"
echo "set protocols static interface-route $cidrblock next-hop-interface vti1"
echo "commit"
