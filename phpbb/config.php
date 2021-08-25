<?php

$dbms = 'phpbb\\db\\driver\\' . getenv('PHPBB_DB_DRIVER');
$dbhost = getenv('PHPBB_DB_HOST');
$dbport = getenv('PHPBB_DB_PORT');
$dbname = getenv('PHPBB_DB_NAME');
$dbuser = getenv('PHPBB_DB_USER');
$dbpasswd = getenv('PHPBB_DB_PASSWD');
$table_prefix = getenv('PHPBB_DB_TABLE_PREFIX');
$phpbb_adm_relative_path = 'adm/';
$acm_type = 'phpbb\\cache\\driver\\file';

@define('PHPBB_INSTALLED', true);

if (getenv('PHPBB_DISPLAY_LOAD_TIME') === 'true') {
	@define('PHPBB_DISPLAY_LOAD_TIME', true);
}

if (getenv('PHPBB_DEBUG') === 'true') {
	@define('DEBUG', true);
}

if (getenv('PHPBB_DEBUG_CONTAINER') === 'true') {
	@define('DEBUG_CONTAINER', true);
}