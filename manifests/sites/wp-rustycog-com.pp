mysql_database { 'wordpress.rustycog.com':
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_general_ci',
  require => Class['mysql::server'],
}

apache::vhost { 'wordpress.rustycog.com':
  serveraliases            => 'wordpress.rustycog.com',
  docroot                  => '/var/www/stable.wordpress.pv/htdocs',
  directory                => '/var/www/stable.wordpress.pv/htdocs',
  directory_allow_override => 'All',
  ssl                      => false,
  template                 => '/var/vagrant/conf/vhost.conf.erb',
}