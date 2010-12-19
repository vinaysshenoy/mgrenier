<?php

/**
 * MYSQL Configurations
 */
define('MYSQL_USER', 'root');
define('MYSQL_PASS', '');
define('MYSQL_ADDR', '127.0.0.1');
define('MYSQL_POST', 3306);
define('MYSQL_DB', 'adobe_cirrus');

/*

-- MySQL SQL

CREATE TABLE IF NOT EXISTS `networks` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `token` char(64) NOT NULL,
  `email` varchar(320) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `nodes` (
  `id` char(64) NOT NULL,
  `networkid` int(6) NOT NULL,
  `label` char(16) NOT NULL,
  `updated` datetime NOT NULL,
  `ip` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `label` (`label`),
  KEY `networkid` (`networkid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

*/



/**
 * Do not edit code below unless you know what you are doing !!
 */
 
 
 
 
 
 
 
 
header('Content-type: text/xml; charset=UTF-8');

// Connect to MySQL Server
$mysql = @mysql_pconnect(MYSQL_ADDR.':'.MYSQL_POST, MYSQL_USER, MYSQL_PASS);
if (!$mysql) {
	echo '<result><error code="MYSQL_COULD_NOT_CONNECT" /></result>';
	die();
}

// Select DB
$db = @mysql_select_db(MYSQL_DB, $mysql);
if (!$db) {
	echo '<result><error code="MYSQL_COULD_NOT_SELECT_DB" /></result>';
	@mysql_close($mysql);
	die();
}

@mysql_query(sprintf("DELETE FROM `nodes` WHERE DATE_ADD(FROM_UNIXTIME(updated), INTERVAL 10 MINUTE) < NOW()"), $mysql);

$networkid = NULL;
if (strlen(@$_POST['netid']) != 64) {
	echo '<result><error code="NETWORKID_NOT_VALID" /></result>';
	@mysql_close($mysql);
	die();
}
$result = @mysql_query(sprintf("SELECT id FROM `networks` WHERE token = '%s' LIMIT 1", mysql_real_escape_string($_POST['netid'])), $mysql);
if (!$result || mysql_num_rows($result) == 0) {
	echo '<result><error code="NETWORKID_NOT_VALID" /></result>';
	@mysql_free_result($result);
	@mysql_close($mysql);
	die();
}
$row = mysql_fetch_assoc($result);
$networkid = $row['id'];

unset($row); @mysql_free_result($result); unset($result);


// Start response
echo "<result>";

switch (@$_POST['method']) {
	
	case 'subscribe':
	
		if (trim(@$_POST['email']) == "" || !filter_var(@$_POST['email'], FILTER_VALIDATE_EMAIL)) {
			echo '<error code="EMAIL_NOT_VALID" />';
			break;
		}
		$hash = hash('sha256', uniqid());
		$result = @mysql_query(sprintf("INSERT INTO `networks` (token, email) VALUES ('%s', '%s')", $hash, mysql_real_escape_string($_POST['email'])), $mysql);
	
		if (!$result) {
			echo '<error code="EMAIL_TAKEN" />';
		} else {
			echo '<success token="'.$hash.'" />';
		}
		
		@mysql_free_result($result);
	
		break;
	
	case 'host':
	
		if (strlen(@$_POST['id']) != 64) {
			echo '<error code="IDENTIFICATION_NOT_VALID" />';
			break;
		}
		if (trim(@$_POST['label']) == "") {
			echo '<error code="LABEL_CAN_NOT_BE_EMPTY" />';
			break;
		}
		
		$result = @mysql_query(sprintf("INSERT INTO `nodes` (id, networkid, label, private, updated, ip) VALUES ('%s', %d, '%s', %d, UNIX_TIMESTAMP(), %d)", mysql_real_escape_string($_POST['id']), $networkid, mysql_real_escape_string(strip_tags($_POST['label'])), mysql_real_escape_string(intval(@$_POST['private'])), ip2long($_SERVER['REMOTE_ADDR'])), $mysql);
		
		if (!$result) {
			echo '<error code="LABEL_TAKEN" error="'.mysql_error($mysql).'" />';
		} else {
			echo '<success />';
		}
		
		@mysql_free_result($result);
		
		break;
	
	case 'keepalive':
	
		if (trim(@$_POST['id']) == "") {
			echo '<error code="IDENTIFICATION_NOT_VALID" />';
			break;
		}
		
		$result = @mysql_query(sprintf("UPDATE `nodes` SET updated = UNIX_TIMESTAMP() WHERE id = '%s' AND networkid = %d LIMIT 1", $_POST['id'], $networkid), $mysql);
		if (!$result) {
			echo '<error code="IDENTIFICATION_NOT_VALID" />';
		} else {
			echo '<success />';
		}
		
		@mysql_free_result($result);
	
		break;
	
	case 'list':
		
		$result = @mysql_query(sprintf("SELECT id, label, updated, ip FROM `nodes` WHERE networkid = %d AND private = 0 ORDER BY label ASC", $networkid), $mysql);
		if (!$result) {
			echo '<error code="UNKNOWN_ERROR" />';
			break;
		}
		
		while ($row = mysql_fetch_assoc($result)) {
			echo '<node>';
			echo '<id>'.addcslashes($row['id'], '<>').'</id>';
			echo '<label>'.addcslashes($row['label'], '<>').'</label>';
			echo '<updated>'.addcslashes($row['updated'], '<>').'</updated>';
			echo '</node>';
		}
		
		@mysql_free_result($result);
		
		break;
	
	case 'lookup':
	
		if (trim(@$_POST['label']) == "") {
			echo '<error code="LABEL_CAN_NOT_BE_EMPTY" />';
			break;
		}
		
		$result = @mysql_query(sprintf("SELECT id, label, updated, ip FROM `nodes` WHERE label = '%s' AND networkid = %d LIMIT 1", $_POST['label'], $networkid), $mysql);
		if ($result) {
			
			while ($row = mysql_fetch_assoc($result)) {
				echo '<node>';
				echo '<id>'.addcslashes($row['id'], '<>').'</id>';
				echo '<label>'.addcslashes($row['label'], '<>').'</label>';
				echo '<updated>'.addcslashes($row['updated'], '<>').'</updated>';
				echo '</node>';
			}
		}
		
		@mysql_free_result($result);
	
		break;
	
	default:
		echo '<error code="UNKNOWN_METHOD" />';
}

// End response
echo "</result>";

// Disconnect from DB
@mysql_close($mysql);