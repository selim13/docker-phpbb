<?php

$dbms = 'phpbb\\db\\driver\\' . $_ENV['PHPBB_DB_DRIVER'];
$dbhost = $_ENV['PHPBB_DB_HOST'];
$dbport = $_ENV['PHPBB_DB_PORT'];
$dbname = $_ENV['PHPBB_DB_NAME'];
$dbuser = $_ENV['PHPBB_DB_USER'];
$dbpasswd = $_ENV['PHPBB_DB_PASSWD'];
$table_prefix = $_ENV['PHPBB_DB_TABLE_PREFIX'];
$phpbb_adm_relative_path = 'adm/';
$acm_type = 'phpbb\\cache\\driver\\file';

@define('PHPBB_INSTALLED', true);

if ($_ENV['PHPBB_DISPLAY_LOAD_TIME'] === 'true') {
	@define('PHPBB_DISPLAY_LOAD_TIME', true);
}

if ($_ENV['PHPBB_DEBUG'] === 'true') {
	@define('DEBUG', true);
}

if ($_ENV['PHPBB_DEBUG_CONTAINER'] === 'true') {
	@define('DEBUG_CONTAINER', true);
}