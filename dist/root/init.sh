#!/bin/sh
set -e

# Test if we have a working connection to MySQL
echo 'SELECT "hello world";' | mysql -h"$DBHOST" -u"$DBUSER" --password="$DBPASS" | grep -q 'hello world'

echo 'SHOW DATABASES;' | mysql -h"$DBHOST" -u"$DBUSER" --password="$DBPASS" | grep -q "$DBNAME" || {
	echo "CREATE DATABASE \`$DBNAME\`;" | mysql -h"$DBHOST" -u"$DBUSER" --password="$DBPASS"
}

wp config create --dbhost="$DBHOST" --dbname="$DBNAME" --dbuser="$DBUSER" --dbpass="$DBPASS"
wp core install --url="$BASEURL" --title='WordPress with Dataporten authentication' --admin_user=admin --admin_email=noreply@uninett.no --skip-email

wp core update-db

wp plugin install --activate https://downloads.wordpress.org/plugin/dataporten-oauth.3.1.zip
sed -e 's/private function dataporten_clear_states_cron/function dataporten_clear_states_cron/' \
	-i wp-content/plugins/dataporten-oauth/dataporten_oauth.php

wp option update siteurl "$BASEURL"
wp option update home "$BASEURL"

wp option update dataporten_oauth_clientid "$DATAPORTEN_CLIENTID"
wp option update dataporten_oauth_clientsecret "$DATAPORTEN_CLIENTSECRET"
wp option update dataporten_oauth_clientscopes 'profile,userid'
wp option update dataporten_oauth_redirect_uri "$BASEURL"
wp option update dataporten_oauth_enabled 1
wp option update dataporten_only 1

lighttpd -f /etc/lighttpd/wordpress.conf -D
