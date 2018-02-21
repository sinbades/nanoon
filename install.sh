#!/bin/bash

export NANOON_CONFIGDIR=/home/nanoon/conf ##CHANGE THIS
export NANOON_FILESDIR=/home/nanoon/file ##CHANGE THAT
export LETS_ENCRYPT_EMAIL=nanoon@nanoon.com ##AND THIS ONE TOO

export NANOON_DOMAIN=nanoon.org

export NANOON_CHAT=chat.$NANOON_DOMAIN
export NANOON_BOOK=book.$NANOON_DOMAIN
export NANOON_CHECK=check.$NANOON_DOMAIN
export NANOON_CLOUD=cloud.$NANOON_DOMAIN
export NANOON_COMIC=comic.$NANOON_DOMAIN
export NANOON_DOWNLOAD=download.$NANOON_DOMAIN
export NANOON_FFSYNC=ffsync.$NANOON_DOMAIN
export NANOON_GIT=git.$NANOON_DOMAIN
export NANOON_MAIL=mail.$NANOON_DOMAIN
export NANOON_MASTODON=mastodon.$NANOON_DOMAIN
export NANOON_MOVIE=movie.$NANOON_DOMAIN
export NANOON_MUSIC=music.$NANOON_DOMAIN
export NANOON_MUXIMUX=muximux.$NANOON_DOMAIN
export NANOON_OFFICE=office.$NANOON_DOMAIN
export NANOON_PLAY=play.$NANOON_DOMAIN
export NANOON_SAVE=save.$NANOON_DOMAIN
export NANOON_SEARCH=search.$NANOON_DOMAIN
export NANOON_SHOW=show.$NANOON_DOMAIN
export NANOON_SOCIAL=social.$NANOON_DOMAIN
export NANOON_SYNC=sync.$NANOON_DOMAIN
export NANOON_TAIGA=taiga.$NANOON_DOMAIN
export NANOON_TORRENT=torrent.$NANOON_DOMAIN
export NANOON_DOWNLOAD=download.$NANOON_DOMAIN
export NANOON_WEBMAIL=webmail.$NANOON_DOMAIN
export NANOON_TV=tv.$NANOON_DOMAIN
export NANOON_MEDIA=media.$NANOON_DOMAIN

mkdir -p $NANOON_CONFIGDIR
mkdir -p $NANOON_FILESDIR
mkdir -p $NANOON_FILESDIR/Solr/mycores
mkdir -p $NANOON_CONFIGDIR/collabora/
chown 8983:8983 $NANOON_FILESDIR/Solr/
mkdir -p $NANOON_CONFIGDIR/nginx-nextcloud/
mkdir -p $NANOON_CONFIGDIR/nextcloud/
mkdir -p $NANOON_FILESDIR/Cloud/
mkdir -p $NANOON_CONFIGDIR/taiga/
mkdir -p $NANOON_FILESDIR/Cloud/custom_apps

cp baseConfig/nginx-nextcloud/nginx.conf $NANOON_CONFIGDIR/nginx-nextcloud/nginx.conf

chown -R www-data:www-data $NANOON_CONFIGDIR/nextcloud/
chown -R www-data:www-data $NANOON_FILESDIR/Cloud/

cp baseConfig/collabora/loolwsd.xml $NANOON_CONFIGDIR/collabora/loolwsd.xml
sed -i -e "s/collabora_hostname/$NANOON_OFFICE/g" $NANOON_CONFIGDIR/collabora/loolwsd.xml
sed -i -e "s/nextcloud_hostname/$NANOON_CLOUD/g" $NANOON_CONFIGDIR/collabora/loolwsd.xml

cp baseConfig/taiga/conf.json $NANOON_CONFIGDIR/taiga/conf.json
sed -i -e "s/taiga_hostname/$NANOON_TAIGA/g" $NANOON_CONFIGDIR/taiga/conf.json

openvpnConf=$NANOON_CONFIGDIR/openvpn/openvpn.conf
if [ ! -f "$openvpnConf" ]; then
 echo "Init vpn config"
#Conf generation:
docker run -v $NANOON_CONFIGDIR/openvpn/:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig  -c -u udp://$NANOON_DOMAIN -p "redirect-gateway def1 bypass-dhcp"
#Keys generation:
docker run -v $NANOON_CONFIGDIR/openvpn/:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
fi

traefikConf=$NANOON_CONFIGDIR/traefik/traefik.toml
if [ ! -f "$traefikConf" ]; then
 mkdir -p $NANOON_CONFIGDIR/traefik
 cp baseConfig/traefik/traefik.toml $NANOON_CONFIGDIR/traefik/traefik.toml
 sed -i -e "s/traefik_email/\"$LETS_ENCRYPT_EMAIL\"/g" $NANOON_CONFIGDIR/traefik/traefik.toml
 sed -i -e "s/traefik_hostname/\"$NANOON_DOMAIN\"/g" $NANOON_CONFIGDIR/traefik/traefik.toml
 mkdir -p $NANOON_CONFIGDIR/traefik/acme/
 touch $NANOON_CONFIGDIR/traefik/acme/acme.json
 chmod 600 $NANOON_CONFIGDIR/traefik/acme/acme.json
fi

cd traefik
docker-compose up -d
cd ..

cd monitor
docker-compose up -d
cd ..

cd download
docker-compose up -d
cd ..

cd privacy
docker-compose up -d
cd ..

cd media
docker-compose up -d
cd ..

cd vpn
docker-compose up -d
cd ..

cd dev
docker-compose up -d
cd ..

cd searx
docker-compose up -d
cd ..
