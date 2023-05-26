<?php
require_once( 'plugins/ClickLogin.php' );

$initServers = [];
if ( file_exists( 'servers/servers.php' ) ) {
	$initServers = include( 'servers/servers.php' );
}

return new ClickLogin( $initServers );