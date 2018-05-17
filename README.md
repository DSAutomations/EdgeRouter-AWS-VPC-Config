# EdgeRouter-AWS-VPC-Config
Converts a generic AWS VPN config to a set of commands to execute on an Ubiquiti EdgeRouter

Please note that this script is for configuring **static** routes, and is based on the oficial Ubiquity guide: [EdgeRouter - IPsec Route-Based Site-to-Site VPN to AWS VPC (VTI over IKEv1/IPsec)](https://help.ubnt.com/hc/en-us/articles/115015979787-EdgeRouter-IPsec-Route-Based-Site-to-Site-VPN-to-AWS-VPC-VTI-over-IKEv1-IPsec-)

Download the *vpn-xxxxxxxx.txt* file after configuring your VPN connection in your AWS console. Pass the file path as the first argument to this script. The script will then prompt you for the CIDR block of your VPC. There is currently no input validation on this field so please make sure you enter it correctly!

The script will then return a set of commands which can be passed to your EdgeRouter in configuration mode. 
