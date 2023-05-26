<?php

// https://www.php.net/manual/en/function.array-is-list.php#127044
if ( ! function_exists( 'array_is_list' ) ) {
	function array_is_list( array $array ): bool {
		$i = -1;
		foreach ( $array as $k => $v ) {
			++$i;
			if ( $k !== $i ) {
				return false;
			}
		}
		return true;
	}
}

/**
 * Display a list of predefined database servers to login with just one click.
 *
 * @link https://www.adminer.org/plugins/#use
 */
class ClickLogin {
	/** @var array */
	private $servers;

	/** @var array */
	private $loginParams;

	/**
	 * Sets lists of supported database servers.
	 *
	 * Database server can be prefixed with driver name and can contain port and database name.
	 * For example:
	 * - mysql://localhost:3306 (server host and port)
	 * - pgsql://user:password@localhost#database_name (authentication, server and database name)
	 *
	 * Possible driver schema names are: `pgsql`, `mysql`, `mongo`.
	 *
	 * @param array $servers array(database-server) or array(label => database-server)
	 */
	public function __construct( array $servers ) {
		$this->servers = [];
		$this->loginParams = [];

		$this->parseServers( $servers, $this->servers, $this->loginParams );
	}

	/**
	 * Checks whether current server is in a list of supported servers.
	 *
	 * @param string $username
	 * @param string $password
	 *
	 * @return bool
	 */
	public function login( $username, $password ) {
		// check if server is allowed
		return isset( $this->servers[ SERVER ] );
	}

	/**
	 * @param array $servers
	 */
	private function parseServers( array $servers, array &$out, array &$loginParams ) {
		$is_list = array_is_list( $servers );

		foreach ( $servers as $key => $server ) {
			$params = [];
			$this->parseServer( $server, $params );

			$name = $key;
			if ( $is_list || $key == '' ) {
				$name = $params['server'];
			}

			$params['name'] = $name;

			$out[ $params['server'] ] = '(' . $params['driverName'] . ') ' . $name;
			$loginParams[ $params['server'] ] = $params;
		}
	}

	/**
	 * @param string $server
	 * @param array $params
	 */
	private function parseServer( $server, array &$params ) {
		$matches = [];
		preg_match( '~^(([^:]+)://)?(([^:@]+)(:([^@]+)?)?@)?([^#]+)(#(.*))?$~', $server, $matches );

		$driver = $matches[2];
		$username = $matches[4];
		$password = $matches[6];
		$server = $matches[7];
		$database = isset( $matches[9] ) ? $matches[9] : "";

		// Fix for mysql:
		if ( $driver == 'mysql' ) {
			$driver = 'server';
		}

		$params = [ 
			'driver' => $driver,
			'username' => $username,
			'password' => $password,
			'server' => $server,
			'database' => $database,

			'driverName' => $this->formatDriver( $driver ),
			'name' => '',
		];
	}

	/**
	 * @param string $driver
	 * @return string
	 */
	private function formatDriver( $driver ) {
		static $drivers = [ 
		'server' => 'MySQL',
		'mysql' => 'MySQL',
		'pgsql' => 'PostgreSQL',
		'mongo' => 'MongoDB',
		];

		return isset( $drivers[ $driver ] ) ? $drivers[ $driver ] : $driver;
	}

	/**
	 * @return bool
	 */
	function loginForm() {
		global $drivers;

		?>
		</form>
		<table>
			<tr>
				<th>
					<?php echo lang( 'Type' ) ?>
				</th>
				<th>
					<?php echo lang( 'Name' ) ?>
				</th>
				<th>
					<?php echo lang( 'Username' ) ?>
				</th>
				<th>
					<?php echo lang( 'Database' ) ?>
				</th>
			</tr>

			<?php
			foreach ( $this->loginParams as $key => $server ) :
				?>
				<tr>
					<td style="vertical-align:middle">
						<?php echo $server['driverName'] ?>
					</td>
					<td style="vertical-align:middle">
						<?php echo $server['name'] ?>
					</td>
					<td style="vertical-align:middle">
						<?php echo $server['username'] ?>
					</td>
					<td style="vertical-align:middle">
						<?php echo $server['database'] ?>
					</td>
					<td>
						<form action="" method="post">
							<input type="hidden" name="auth[driver]" value="<?php echo h( $server['driver'] ); ?>">
							<input type="hidden" name="auth[server]" value="<?php echo h( $server['server'] ); ?>">
							<input type="hidden" name="auth[username]" value="<?php echo h( $server['username'] ); ?>">
							<input type="hidden" name="auth[password]" value="<?php echo h( $server['password'] ); ?>">
							<input type='hidden' name="auth[db]" value="<?php echo h( $server['database'] ); ?>" />
							<input type='hidden' name="auth[permanent]" value="1" />
							<input type="submit" value="<?php echo lang( 'Login' ); ?>">
						</form>
					</td>
				</tr>
				<?php
			endforeach;
			?>
		</table>
		<form action="" method="post">
			<?php
			return true;
	}
}