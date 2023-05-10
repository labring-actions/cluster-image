<?php
require_once('plugins/AdminerLoginServers.php');

$plugins = [
    // specify enabled plugins here
    new AdminerSimpleMenu(),
];

return new AdminerPlugin($plugins);