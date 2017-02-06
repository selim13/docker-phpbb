# Supported tags and respective `Dockerfile` links

-	[`3.2-apache`, `3-apache`, `3.2`, `3`, `apache`, `latest` (*3.2-apache/Dockerfile*)](https://github.com/selim13/docker-phpbb/blob/master/3.2-apache/Dockerfile)
-	[`3.1-apache`, `3.1` (*3.1-apache/Dockerfile*)](https://github.com/selim13/docker-phpbb/blob/master/3.1-apache/Dockerfile)

# phpBB3

Very popular php forum engine.

# How to use this image

## Initial installation

If you don't have a prepared phpBB database, you can use a standard phpBB 
installer script, just run a temporary container with `PHPBB_INSTALL=true` 
environment variable:

```console
$ docker run -p 8000:80 --name phpbb-install -e PHPBB_INSTALL=true -d selim13/phpbb:3.1
```

Point your browser to the http://localhost:8000 to begin the 
installation process.

This image is bundled with SQLite3, MySQL and PostgresSQL database engines
support. Others can be added by creating custom Dockerfile. For MySQL and PostgresSQL
you can use standard container linking or use SQLite if you want a self
sufficient container.

For SQLite3 set `Database server hostname or DSN` field to `/phpbb/sqlite/sqlite.db`.
This file will be created on a docker volume and outside of the webserver's document root
for security. Leave user name, password and database name fields blank.

After the installation process is complete you can safely stop this container: 

```console
$ docker stop phpbb-install
```

## Starting

You can start a container as follows:


```console
$ docker run --name phpbb -d selim13/phpbb:3.1
```

By default, it uses SQLite3 as a database backend, so you will need to supply
it with a database file. It's default path is `/phpbb/sqlite/sqlite.db`.

You can import it from the temporary installation container above:

```console
$ docker run --volumes-from phpbb-install --name phpbb -d selim13/phpbb:3.1
```

Or just copy it inside container if you have one from previous phpBB
installations:

```console
$ docker cp /path/at/host/sqlite.db phpbb:/www/sqlite/sqlite.db
```

For other database engines you will need to pass credentials and driver type
using environment variables:

```console
$ docker run --name phpbb     \
    -e PHPBB_DB_DRIVER=mysqli \
    -e PHPBB_DB_HOST=dbmysql  \
    -e PHPBB_DB_PORT=3306     \
    -e PHPBB_DB_NAME=phpbb    \
    -e PHPBB_DB_USER=phpbb    \
    -e PHPBB_DB_PASSWD=pass -d selim13/phpbb:3.1
```

## Environment variables 

This image utilises environment variables for basic configuration. Most of
them are passed directly to phpBB's `config.php` or to the startup script.

### PHPBB_INSTALL
If set to `true`, container will start with an empty `config.php` file and
phpBB `/install/` directory intact. This will allow you to initilalize 
a forum database upon fresh installation.

### PHPBB_DB_DRIVER

Selects a database driver. phpBB3 ships with following drivers:
- `mssql` - MS SQL Server
- `mysql` - MySQL via outdated php extension
- `mysqli` - MySQL via newer php extension
- `oracle` - Oracle
- `postgres` - PostgreSQL
- `sqlite` - SQLite 2
- `sqlite3` - SQLite 3

This image is bundled with support of `sqlite3`, `mysqli` and `postgres` drivers.

Default value: sqlite3
 
### PHPBB_DB_HOST

Database hostname or ip address.

For the SQLite3 driver sets database file path. 

Default value: /phpbb/sqlite/sqlite.db
 
### PHPBB_DB_PORT

Database port.

### PHPBB_DB_NAME

Supplies database name for phpBB3.

### PHPBB_DB_USER

Supplies a user name for phpBB3 database.

### PHPBB_DB_PASSWD

Supplies a user password for phpBB3 database.

If you feel paranoid about providing your database password in an environment
variable, you can always ship it with a custom `config.php` file using volumes
or by extending this image.

### PHPBB_DB_TABLE_PREFIX

Table prefix for phpBB3 database.

Default value: phpbb_ 

### PHPBB_DB_AUTOMIGRATE

If set to `true`, instructs a container to run database migrations by
executing `bin/phpbbcli.php db:migrate` on every startup.

If migrations fail, container will refuse to start.

### PHPBB_DB_WAIT
If set to `true`, container will wait for database service to become available.
You will need to explicitly set `PHPBB_DB_HOST` and `PHPBB_DB_PORT` for this
to work.

Use in conjunction with `PHPBB_DB_AUTOMIGRATE` to prevent running migrations
before database is ready.

Won't work for SQLite database engine as it is always available. 

### PHPBB_DISPLAY_LOAD_TIME

If set to `true`, phpBB will display page loading time, queries count and peak memory
usage at the bottom of the page.

### PHPBB_DEBUG

If set to `true`, enables phpBB debug mode.

### PHPBB_DEBUG_CONTAINER
  
## Volumes

By default there are four volumes created for each container:
- /phpbb/sqlite
- /phpbb/www/files
- /phpbb/www/store
- /phpbb/www/images/avatars/upload

# Additional configuration

This image is based on a stock official Alpine image with apache2 and php5
packages from the Alpine Linux repository, so you can drop their custom 
configuration files to `/etc/apache2/conf.d` and `/etc/php5/conf.d`.

## Pass user's IP from proxy

If you are planning to start a container behind proxy 
(like [nginx-proxy](https://github.com/jwilder/nginx-proxy)), it will probably
be a good idea to get user's real IP instead of proxy one. For this, you can use
Apache RemoteIP module. Create a configuration file:

```apache
LoadModule remoteip_module modules/mod_remoteip.so

RemoteIPHeader X-Real-IP
RemoteIPInternalProxy nginx-proxy
```

Here `X-Real-IP` is a header name, where proxy passed user's real IP and
`nginx-proxy` is proxy host name.

Then push it to `/etc/apache2/conf.d/` directory, for example, by extending this
image:

```dockerfile
FROM selim13/phpbb:3.1

COPY remoteip.conf /etc/apache2/conf.d
```