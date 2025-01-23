# Pixelfed

## Initial Setup

You should only perform these steps once.

```
mkdir db_data storage
git clone -b dev https://github.com/pixelfed/pixelfed.git ./source/
sudo cp -r -u ./source/storage/ ./storage/
sudo chown -R www-data:www-data ./storage/
sudo chmod -R 644 ./storage
sudo find ./storage -type d -exec chmod 755 {} \;
```
## Run the server!
```
docker compose up -d
```

## Updates

Simply; we pull the latest source, then build it.

```
cd source
git pull
cd ..
docker compose up -d --build
```

## Administration
Create an admin user

`docker compose exec --user www-data pixelfed php artisan user:create`

Or, set an existing user as admin

`docker compose exec --user www-data pixelfed php artisan user:admin [username]`

Every time you edit your .env file, you must run this command to have the changes take effect:

`docker compose exec --user www-data pixelfed php artisan config:cache`