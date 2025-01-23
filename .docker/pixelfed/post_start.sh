#!/usr/bin/env bash
set -xeo pipefail

cd /var/www/html

if ! [ -f /var/www/html/storage/.docker.init ]; then
	echo "Fresh installation, initializing database..."
	php artisan key:generate
	php artisan storage:link
	php artisan migrate:fresh --force
	php artisan import:cities
	php artisan instance:actor
	php artisan passport:keys
	php artisan horizon:install
	echo done > /var/www/html/storage/.docker.init
fi

php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "++++ Check for needed migrations... ++++"
# check for migrations
php artisan migrate:status | grep No && migrations=yes || migrations=no
if [ $migrations = "yes" ];
then
	php artisan migrate --force
fi
