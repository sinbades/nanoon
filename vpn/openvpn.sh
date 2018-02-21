#Create user:
docker run -v $NANOON_CONFIGDIR/openvpn/:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full USER nopass

#Create user conf file:
docker run -v $NANOON_CONFIGDIR/openvpn/:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient USER > USER.ovpn

#Remove user:
docker run --rm -it -v  $NANOON_CONFIGDIR/openvpn/:/etc/openvpn kylemanna/openvpn ovpn_revokeclient USER remove

