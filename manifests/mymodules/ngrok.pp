class { '::ngrok':
	home 		 => '/home/vagrant',
	token		 => 'Mx9pCS74AMLi4Foco35z_jGVJfABJL6a2QWNhZ37L',
	url			 => 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip',
}

# exec { 'screen':
# 	command 	=> 'screen -dmS NGROK ngrok http -hostname=wordpress.rustycog.com 80',
# 	provider 	=> 'shell',
# }
