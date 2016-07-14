# Note: much of the documentation and code in this file is from Varying Vagrant Vagrants, the original base for this project

vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure("2") do |config|

	# Store the current version of Vagrant for use in conditionals when dealing
	# with possible backward compatible issues.
	vagrant_version = Vagrant::VERSION.sub(/^v/, '')

	# Default Ubuntu Box
	#
	# This box is provided directly by Canonical and is updated almost nightly. Currently it is
	# configured to use Ubuntu 14.04 x64. For a full list of boxes provided by Canonical visit
	# http://cloud-images.ubuntu.com/vagrant/
	config.vm.box = "ubuntu/trusty64"

	config.vm.hostname = "pv"

	# Default Box IP Address
	#
	# This is the IP address that your host will communicate to the guest through. In the
	# case of the default `192.168.56.101` that we've provided, Virtualbox will setup another
	# network adapter on your host machine with the IP `192.168.13.1` as a gateway.
	#
	# If you are already on a network using the 192.168.13.x subnet, this should be changed.
	# If you are running more than one VM through Virtualbox, different subnets should be used
	# for those as well. This includes other Vagrant boxes.
	config.vm.network :private_network, ip: "192.168.13.101"

	# Local Machine Hosts
	#
	# If the Vagrant plugin Ghost (https://github.com/10up/vagrant-ghost) is
	# installed, the following will automatically configure your local machine's hosts file to
	# be aware of the domains specified below. Watch the provisioning script as you may need to
	# enter a password for Vagrant to access your hosts file.
	#
	# By default, we'll include the domains set up by Primary Vagrant through the pv-hosts file
	# located in the www/ directory.
	#
	# Other domains can be automatically added by including a pv-hosts file containing
	# individual domains separated by whitespace in subdirectories of www/.
	if defined?(VagrantPlugins::Ghost)
		# Recursively fetch the paths to all pv-hosts files under the www/ directory.
		paths = Dir[File.join(vagrant_dir, 'www', '**', 'pv-hosts')]

		# Parse the found pv-hosts files for host names.
		hosts = paths.map do |path|

		# Read line from file and remove line breaks
		lines = File.readlines(path).map(&:chomp)

		# Filter out comments starting with "#"
		lines.grep(/\A[^#]/)

		end.flatten.uniq # Remove duplicate entries

		# Pass the found host names to the ghost plugin so it can perform magic.
		config.ghost.hosts = hosts
	end

	# Forward Agent
	#
	# Enable agent forwarding on vagrant ssh commands. This allows you to use identities
	# established on the host machine inside the guest. See the manual for ssh-add
	config.ssh.forward_agent = true

	# Configurations from 1.0.x can be placed in Vagrant 1.1.x specs like the following.
	config.vm.provider :virtualbox do |v|
		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		v.customize ["modifyvm", :id, "--memory", 2048]
		v.customize ["modifyvm", :id, "--name", "PriVagrant"]
		v.customize ["modifyvm", :id, "--cpus", 1]
		v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
		v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
	end

	# Drive mapping
	#
	# The following config.vm.share_folder settings will map directories in your Vagrant
	# virtual machine to directories on your local machine. Once these are mapped, any
	# changes made to the files in these directories will affect both the local and virtual
	# machine versions. Think of it as two different ways to access the same file. When the
	# virtual machine is destroyed with `vagrant destroy`, your files will remain in your local
	# environment.

	# /var/www/
	#
	# For each project you're working on map a folder to it. The first argument is the location
	# on the host computer. The second argument is the location on the guest matching. Finally the
	# 3rd arguement is a unique ID given to each folder mapped

	# config.vm.synced_folder "www/default/wordpress/legacy", "/var/www/legacy.wordpress.pv", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	# config.vm.synced_folder "www/default/wordpress/trunk", "/var/www/trunk.wordpress.pv", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
 	# config.vm.synced_folder "www/default/wordpress/core", "/var/www/core.wordpress.pv", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	# config.vm.synced_folder "www/default/wordpress/content", "/var/www/stable.wordpress.pv/htdocs/content", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	# config.vm.synced_folder "www/default/wordpress/content", "/var/www/trunk.wordpress.pv/htdocs/content", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	# config.vm.synced_folder "www/default/wordpress/content", "/var/www/legacy.wordpress.pv/htdocs/content", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]

	config.vm.synced_folder "www/default/pv", "/var/www/pv", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	config.vm.synced_folder "www/default/Search-Replace-DB", "/var/www/replacedb.pv", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	config.vm.synced_folder "www/default/phpmyadmin", "/var/www/phpmyadmin.pv", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	config.vm.synced_folder "www/default/webgrind", "/var/www/webgrind.pv", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]

	config.vm.synced_folder "www/default/wordpress/stable", "/var/www/stable.wordpress.pv", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	config.vm.synced_folder "ProjectLinks/raven-iframe-woocommerce", "/var/www/wordpress.rustycog.com/htdocs/content/plugins/raven-iframe-woocommerce", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	config.vm.synced_folder "ProjectLinks/raven-customer", "/var/www/ccinquiry.com", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	#
	# /Vagrant Data
	#
	# Specify a folder for various vagrant data. A MySQL data folder would be appropriate here (for example).
	config.vm.synced_folder "xdebug", "/var/xdebug", :mount_options => [ "dmode=777", "fmode=777" ]
 	config.vm.synced_folder "ssl", "/etc/apache2/ssl", :mount_options => [ "dmode=777", "fmode=777" ]
 	config.vm.synced_folder "conf", "/var/vagrant/conf", :mount_options => [ "dmode=777", "fmode=777" ]
 	config.vm.synced_folder "mysql", "/var/vagrant/mysql", :mount_options => [ "dmode=777", "fmode=777" ]
 	config.vm.synced_folder "bin", "/var/vagrant/bin", :mount_options => [ "dmode=777", "fmode=777" ]

	# Custom Mappings - POSSIBLY UNSTABLE
	#
	# Use this to insert your own (and possibly rewrite) Vagrant config lines. Helpful
	# for mapping additional drives. If a file 'mappings' exists in the www folder
	# it will be evaluated as ruby inline as it loads.
	if File.exists?(File.join(vagrant_dir,'www', 'mappings')) then
		eval(IO.read(File.join(vagrant_dir, 'www', 'mappings')), binding)
	end

	# Provisioning
	#
	# Process one or more provisioning scripts depending on the existence of custom files.
	#
	# Provisioning uses the Puppet configuration tool (http://puppetlabs.com/). This tool
	# relies on modules in the modules/ folder which are configures in manifests/default.pp.
	config.vm.provision "puppet", run: "always" do |puppet|
		puppet.manifests_path    = "manifests"
		puppet.manifest_file     = "init.pp"
		puppet.module_path       = "modules"
		puppet.facter            = { "fqdn" => "pv" }
		puppet.hiera_config_path = "hiera.yaml"
	end

	# Vagrant Triggers
	#
	# If the vagrant-triggers plugin is installed, we can run various scripts on Vagrant
	# state changes like `vagrant up`, `vagrant halt`, `vagrant suspend`, and `vagrant destroy`
	#
	# These scripts are run on the host machine, so we use `vagrant ssh` to tunnel back
	# into the VM and execute things. By default, each of these scripts calls db_backup
	# to create backups of all current databases. This can be overridden with custom
	# scripting. See the individual files in config/homebin/ for details.
	if defined? VagrantPlugins::Triggers
		config.trigger.before :halt, :stdout => true do
			run "vagrant ssh -c '/var/vagrant/bin/vagrant_halt'"
		end
		config.trigger.before :suspend, :stdout => true do
			run "vagrant ssh -c '/var/vagrant/bin/vagrant_suspend'"
		end
		config.trigger.before :destroy, :stdout => true do
			run "vagrant ssh -c '/var/vagrant/bin/vagrant_destroy'"
		end
	end

end
