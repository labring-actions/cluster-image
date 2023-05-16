<?php
require_once( 'plugins/ClickLogin.php' );

$initServers = [];
if ( file_exists( 'servers.php' ) ) {
	$initServers = include( 'servers.php' );
}

return new ClickLogin( $initServers );