class ngrok($home, $token, $url) {

  #ensure_packages($dependencies, { ensure => installed })

  exec { 'retrieve_ngrok':
    command => "/usr/bin/curl -s ${url} > /tmp/ngrok.zip",
    creates => '/tmp/ngrok.zip',
    require => Package['curl'],
  } ~>
  exec { 'unzip_ngrok':
    command => '/usr/bin/unzip /tmp/ngrok.zip -d /opt',
    creates => '/opt/ngrok',
    require => [Exec['retrieve_ngrok'], Package['unzip']],
  } ~>
  file { '/opt/ngrok':
    owner => root,
    group => root,
    mode  => '0755',
  }

  file { '/usr/local/bin/ngrok':
    ensure => link,
    target => '/opt/ngrok',
  }

  file { "${home}/.config": 
    ensure => directory 
  } ->
  file { "${home}/.config/ngrok": 
    ensure => directory 
  } ->
  file { "${home}/.config/ngrok/config.yml":
    ensure  => present,
    content => template('ngrok/config.erb'),
    mode    => '0644',
  }
  #ngrok does not support XDG. ngrok should support XDG.
  file { "${home}/.ngrok2": ensure => directory } ->
  file { "${home}/.ngrok2/ngrok.yml":
    ensure => link,
    target => "${home}/.config/ngrok/config.yml",
  }

}
