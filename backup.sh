#!/bin/bash

#export NANOON_CONFIGDIR=/home/nanoon/conf ##CHANGE THIS
#export NANOON_FILESDIR=/home/nanoon/file ##CHANGE THAT
#export NANOON_BACKUPDIR=/home/nanoon/backup ##AND THIS
#export UID=1000
#export GID=100

mkdir -p $NANOON_CONFIGDIR
mkdir -p $NANOON_FILESDIR
mkdir -p $NANOON_BACKUPDIR

mkdir -p $NANOON_BACKUPDIR/transmission
mkdir -p $NANOON_BACKUPDIR/emby
mkdir -p $NANOON_BACKUPDIR/gitea
mkdir -p $NANOON_BACKUPDIR/mastodon
mkdir -p $NANOON_BACKUPDIR/riot
mkdir -p $NANOON_BACKUPDIR/mailserver
mkdir -p $NANOON_BACKUPDIR/pixelfed
mkdir -p $NANOON_BACKUPDIR/cachethq
mkdir -p $NANOON_BACKUPDIR/traefik

cp $NANOON_CONFIGDIR/transmission/settings.json $NANOON_BACKUPDIR/transmission/settings.json

cp -r $NANOON_CONFIGDIR/emby/backup/* $NANOON_BACKUPDIR/emby

cp -r $NANOON_CONFIGDIR/diaspora $NANOON_BACKUPDIR/diaspora
cp -r $NANOON_FILESDIR/diaspora-images $NANOON_BACKUPDIR/diaspora

cp -r $NANOON_CONFIGDIR/jitsi $NANOON_BACKUPDIR/jitsi

cp -r $NANOON_CONFIGDIR/nextcloud $NANOON_BACKUPDIR/nextcloud
#cp -r $NANOON_FILESDIR/Cloud $NANOON_BACKUPDIR/nextcloud
cp -r $NANOON_CONFIGDIR/openvpn $NANOON_BACKUPDIR/openvpn

cp -r $NANOON_CONFIGDIR/peertube $NANOON_BACKUPDIR/peertube
cp -r $NANOON_FILESDIR/peertube $NANOON_BACKUPDIR/peertube-data
rm -r $NANOON_BACKUPDIR/peertube-data/logs

cp -r $NANOON_CONFIGDIR/syncthing $NANOON_BACKUPDIR/syncthing

cp -r $NANOON_CONFIGDIR/taiga $NANOON_BACKUPDIR/taiga
cp -r $NANOON_FILESDIR/Taiga-media $NANOON_BACKUPDIR/taiga

cp -r $NANOON_CONFIGDIR/traefik/traefik.toml $NANOON_BACKUPDIR/traefik

cp -r $NANOON_CONFIGDIR/tvheadend $NANOON_BACKUPDIR/tvheadend

cp -r $NANOON_CONFIGDIR/watchtower $NANOON_BACKUPDIR/watchtower

cp -r $NANOON_CONFIGDIR/wallabag $NANOON_BACKUPDIR/wallabag

cp -r $NANOON_CONFIGDIR/jackett $NANOON_BACKUPDIR/jackett

cp -r $NANOON_CONFIGDIR/pyload $NANOON_BACKUPDIR/pyload

cp -r $NANOON_CONFIGDIR/synapse $NANOON_BACKUPDIR/riot
cp -r $NANOON_FILESDIR/synapse-media $NANOON_BACKUPDIR/riot
cp -r $NANOON_CONFIGDIR/matrixid $NANOON_BACKUPDIR/riot

cp mastodon/.env.production $NANOON_BACKUPDIR/mastodon
cp -r $NANOON_FILESDIR/Mastodon/system $NANOON_BACKUPDIR/mastodon

cp -r $NANOON_FILESDIR/mailserver/rainloop $NANOON_BACKUPDIR/mailserver
cp -r $NANOON_FILESDIR/mailserver/mail $NANOON_BACKUPDIR/mailserver
rm -r $NANOON_BACKUPDIR/mailserver/mysql


docker exec db_nextcloud /usr/bin/mysqldump -u nextcloud --password=dbpass nextcloud > $NANOON_BACKUPDIR/nextcloud/nextcloud.sql
docker exec db_wallabag /usr/bin/mysqldump -u wallabag --password=wallapass wallabag > $NANOON_BACKUPDIR/wallabag/wallabag.sql
docker exec mailserver_db /usr/bin/mysqldump -u postfix --password=xxxxxxx postfix > $NANOON_BACKUPDIR/mailserver/mailserver.sql
docker exec pixelfed-db /usr/bin/mysqldump -u pixelfed --password=pixelfed pixelfed > $NANOON_BACKUPDIR/pixelfed/pixelfed.sql


docker exec -u postgres mastodon-db pg_dumpall -c > $NANOON_BACKUPDIR/mastodon/mastodon.sql
docker exec -u postgres peertube-postgres pg_dumpall -c > $NANOON_BACKUPDIR/peertube/peertube.sql
docker exec -u postgres diaspora-postgres pg_dumpall -c > $NANOON_BACKUPDIR/diaspora/diaspora.sql
docker exec -u postgres taiga-postgres pg_dumpall -c > $NANOON_BACKUPDIR/taiga/taiga.sql
docker exec -u postgres synapse-db pg_dumpall -U synapse -c > $NANOON_BACKUPDIR/riot/synapse.sql
docker exec -u postgres cachethq-postgres pg_dumpall -c > $NANOON_BACKUPDIR/cachethq/cachethq.sql


docker exec -it --user git gitea sh -c 'cd tmp && gitea dump -c /data/gitea/conf/app.ini'
docker exec -it --user git gitea sh -c 'mkdir /tmp/dumps && cd /tmp/dumps && gitea dump -c /data/gitea/conf/app.ini'
docker cp gitea:/tmp/dumps $NANOON_BACKUPDIR/gitea
docker exec -it --user git gitea sh -c 'rm -r /tmp/dumps'

chown -R $UID:$GID $NANOON_BACKUPDIR
chmod -R 644 $NANOON_BACKUPDIR
