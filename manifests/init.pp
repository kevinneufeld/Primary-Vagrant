group { 'puppet': ensure => present }

Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644 }

class { 'apt': }

apt::ppa { 'ppa:ondrej/php5-5.6': }

package { 'vim':
	ensure => 'installed'
}

package { 'git':
	ensure => 'installed'
}

package { 'subversion':
	ensure => 'installed'
}

package { 'ntp':
	ensure => 'installed'
}

package { 'memcached':
  ensure => 'installed'
}
package { 'curl':
  ensure => 'installed',
}
package { 'unzip':
  ensure => 'installed',
}
package { 'freetds-common':
  ensure => 'installed',
}
package { 'freetds-bin':
  ensure => 'installed',
}
package { 'unixodbc':
  ensure => 'installed',
}
package { 'unixodbc-dev':
  ensure => 'installed',
}
package { 'php5-sybase':
  ensure => 'installed',
}
class { 'ohmyzsh': }

ohmyzsh::install { 'vagrant': }

class { 'apache': }

include apache::ssl

apache::dotconf { 'fqdn':
	content => template( '/var/vagrant/conf/fqdn.conf.erb' )
}

apache::module { 'rewrite': }
apache::module { 'cache': }
apache::module { 'cgid': }
apache::module { 'expires': }
apache::module { 'headers': }
apache::module { 'suexec': }
apache::module { 'unique_id': }

apache::vhost { 'pv':
	docroot => '/var/www/pv',
}

apache::vhost { 'phpmyadmin.pv':
	docroot                  => '/var/www/phpmyadmin.pv/phpmyadmin',
	directory                => '/var/www/phpmyadmin.pv/phpmyadmin',
	directory_allow_override => 'All',
	ssl                      => true,
	template                 => '/var/vagrant/conf/vhost.conf.erb',
}

apache::vhost { 'replacedb.pv':
	docroot                  => '/var/www/replacedb.pv',
	directory                => '/var/www/replacedb.pv',
	directory_allow_override => 'All',
	ssl                      => true,
	template                 => '/var/vagrant/conf/vhost.conf.erb',
}

# apache::vhost { 'core.wordpress.pv':
#   serveraliases            => 'wordpress.core.pv',
#   docroot                  => '/var/www/core.wordpress.pv/src',
#   directory                => '/var/www/core.wordpress.pv/src',
#   directory_allow_override => 'All',
#   ssl                      => true,
#   template                 => '/var/vagrant/conf/vhost.conf.erb',
# }

# apache::vhost { 'legacy.wordpress.pv':
#   serveraliases            => 'wordpress.legacy.pv',
#   docroot                  => '/var/www/legacy.wordpress.pv/htdocs',
#   directory                => '/var/www/legacy.wordpress.pv/htdocs',
#   directory_allow_override => 'All',
#   ssl                      => true,
#   template                 => '/var/vagrant/conf/vhost.conf.erb',
# }

apache::vhost { 'stable.wordpress.pv':
	serveraliases            => 'wordpress.stable.pv',
	docroot                  => '/var/www/stable.wordpress.pv/htdocs',
	directory                => '/var/www/stable.wordpress.pv/htdocs',
	directory_allow_override => 'All',
	ssl                      => true,
	template                 => '/var/vagrant/conf/vhost.conf.erb',
}

# apache::vhost { 'trunk.wordpress.pv':
#   serveraliases            => 'wordpress.trunk.pv',
#   docroot                  => '/var/www/trunk.wordpress.pv/htdocs',
#   directory                => '/var/www/trunk.wordpress.pv/htdocs',
#   directory_allow_override => 'All',
#   ssl                      => true,
#   template                 => '/var/vagrant/conf/vhost.conf.erb',
# }

apache::vhost { 'webgrind.pv':
	docroot                  => '/var/www/webgrind.pv',
	directory                => '/var/www/webgrind.pv',
	directory_allow_override => 'All',
	ssl                      => true,
	template                 => '/var/vagrant/conf/vhost.conf.erb',
}

class { 'php':
	service => 'apache'
}

class { 'php::devel':
	require => Class['php'],
}

class { 'phpunit':
	require => Class['php'],
}

php::module { 'mysql': }
php::module { 'sqlite': } -> php::mod { 'sqlite3': }
php::module { 'cli': }
php::module { 'curl': }
php::module { 'gd': }
php::module { 'imagick': }
php::module { 'mcrypt': }
php::module { 'memcache': }
php::pecl::module { 'xdebug': }

exec { 'enabling_mcrypt':
	command => 'php5enmod mcrypt && service apache2 reload',
	require => Package['php5-mcrypt'],
	creates => '/etc/php5/apache2/conf.d/20-mcrypt.ini',
}

exec { 'php_codesniffer':
	command => 'pear install PHP_CodeSniffer',
	require => Package['php5-mcrypt'],
	creates => '/usr/bin/phpcs',
}

exec { 'wp_code_standards':
	command => 'git clone -b master https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git /var/wpcs && phpcs --config-set installed_paths /var/wpcs',
	require => Package['php5-mcrypt'],
	creates => '/var/wpcs/README.md',
}

php::augeas {
	'php-xdebug.trace_enable_trigger':
		entry   => 'XDEBUG/xdebug.trace_enable_trigger',
		value   => '1',
		require => Class['php'];
	'xdebug.trace_output_dir':
		entry   => 'XDEBUG/xdebug.trace_output_dir',
		value   => '/var/xdebug',
		require => Class['php'];
	'php-xdebug.collect_includes':
		entry   => 'XDEBUG/xdebug.collect_includes',
		value   => '1',
		require => Class['php'];
	'php-xdebug.collect_params':
		entry   => 'XDEBUG/xdebug.collect_params',
		value   => '1',
		require => Class['php'];
	'php-xdebug.collect_vars':
		entry   => 'XDEBUG/xdebug.collect_vars',
		value   => '1',
		require => Class['php'];
	'php-xdebug.collect_return':
		entry   => 'XDEBUG/xdebug.collect_return',
		value   => '1',
		require => Class['php'];
	'php-xdebug.dump_globals':
		entry   => 'XDEBUG/xdebug.dump_globals',
		value   => '1',
		require => Class['php'];
	'php-xdebug.idekey':
		entry   => 'XDEBUG/xdebug.idekey',
		value   => 'VAGRANT_DEBUG',
		require => Class['php'];
	'php-xdebug.profiler_enable_trigger':
		entry   => 'XDEBUG/xdebug.profiler_enable_trigger',
		value   => '1',
		require => Class['php'];
	'php-xdebug.profiler_output_name':
		entry   => 'XDEBUG/xdebug.profiler_output_name',
		value   => 'cachegrind.out.%t-%s',
		require => Class['php'];
	'php-xdebug.profiler_output_dir':
		entry   => 'XDEBUG/xdebug.profiler_output_dir',
		value   => '/var/xdebug',
		require => Class['php'];
	'php-xdebug.remote_enable':
		entry   => 'XDEBUG/xdebug.remote_enable',
		value   => '1',
		require => Class['php'];
	'php-xdebug.remote_mode':
		entry   => 'XDEBUG/xdebug.remote_mode',
		value   => 'req',
		require => Class['php'];
	'php-xdebug.remote_host':
		entry   => 'XDEBUG/xdebug.remote_host',
		value   => '192.168.13.1',
		require => Class['php'];
	'php-xdebug.remote_log':
		entry   => 'XDEBUG/xdebug.remote_log',
		value   => '/var/xdebug/xdebug-remote.log',
		require => Class['php'];
	'php-xdebug.remote_port':
		entry   => 'XDEBUG/xdebug.remote_port',
		value   => '9000',
		require => Class['php'];
	'php-xdebug.var_display_max_children':
		entry   => 'XDEBUG/xdebug.var_display_max_children',
		value   => '-1',
		require => Class['php'];
	'php-xdebug.var_display_max_data':
		entry   => 'XDEBUG/xdebug.var_display_max_data',
		value   => '-1',
		require => Class['php'];
	'php-xdebug.var_display_max_depth':
		entry   => 'XDEBUG/xdebug.var_display_max_depth',
		value   => '-1',
		require => Class['php'];
	'php-xdebug.max_nesting_level':
		entry   => 'XDEBUG/xdebug.max_nesting_level',
		value   => '256',
		require => Class['php'];
	'php-memory_limit':
		entry   => 'PHP/memory_limit',
		value   => '256M',
		require => Class['php'];
	'php-post_max_size':
		entry   => 'PHP/post_max_size',
		value   => '100M',
		require => Class['php'];
	'php-upload_max_filesize':
		entry   => 'PHP/upload_max_filesize',
		value   => '100M',
		require => Class['php'];
}

class { 'wp-cli': }

class { 'composer':
	command_name => 'composer',
	target_dir   => '/usr/local/bin',
	auto_update  => true,
}

class { 'nodejs':
	version      => 'stable',
	make_install => false,
}

class { 'postfix':
	relayhost      => '127.0.0.1',
	relayhost_port => '1025',
}

class { 'mysql::server': }

mysql_database { 'stable.wordpress.pv':
	ensure  => 'present',
	charset => 'utf8',
	collate => 'utf8_general_ci',
	require => Class['mysql::server'],
}

# mysql_database { 'legacy.wordpress.pv':
#   ensure  => 'present',
#   charset => 'utf8',
#   collate => 'utf8_general_ci',
#   require => Class['mysql::server'],
# }

# mysql_database { 'trunk.wordpress.pv':
#   ensure  => 'present',
#   charset => 'utf8',
#   collate => 'utf8_general_ci',
#   require => Class['mysql::server'],
# }

# mysql_database { 'core.wordpress.pv':
#   ensure  => 'present',
#   charset => 'utf8',
#   collate => 'utf8_general_ci',
#   require => Class['mysql::server'],
# }

# mysql_database { 'tests.core.wordpress.pv':
#   ensure  => 'present',
#   charset => 'utf8',
#   collate => 'utf8_general_ci',
#   require => Class['mysql::server'],
# }

mysql_user { 'username@localhost':
	ensure        => 'present',
	require       => Class['mysql::server'],
	password_hash => mysql_password(password),
}

mysql_grant { 'username@localhost/*.*':
	ensure     => 'present',
	options    => ['GRANT'],
	privileges => ['ALL'],
	table      => '*.*',
	user       => 'username@localhost',
	require    => Class['mysql::server'],
}

#class { 'mailcatcher': }

file { '/var/www/phpmyadmin.pv/phpmyadmin/config.inc.php':
	ensure => 'link',
	target => '/var/www/phpmyadmin.pv/config.inc.php',
}

file { '.zshrc':
	path    => '/home/vagrant/.zshrc',
	ensure  => file,
	owner   => 'vagrant',
	group   => 'vagrant',
	source  => '/var/vagrant/conf/.zshrc',
}

file { 'sudoers':
	path    => '/etc/sudoers',
	ensure  => file,
	mode    => '440',
	source  => '/var/vagrant/conf/sudoers',
}

import 'sites/*.pp'
import 'mymodules/*.pp'
