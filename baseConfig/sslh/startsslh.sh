#!/bin/sh

sslh-select -f --user root --timeout 20 -n --listen sslh:443 --ssl traefik:443 --ssh host_sslh:22 --openvpn openvpn_tcp:1194

