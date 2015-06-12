Primary Vagrant
=============

## Note

I've done some heavy updates to Primary Vagrant to utilize Ubuntu 14.04 as well as a few other goodies. If you don't want to or can't update for some reason you can find the old version in the [Precise](https://github.com/ChrisWiegman/Primary-Vagrant/tree/Precise) branch.

## About

Primary Vagrant is intended for WordPress plugin, theme, and core development, as well as general PHP development, and can be used as a replacement for local development stacks such as MAMP, XAMPP, and others.

Although [Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV) by 10up is great (and I still use it for NGINX work), I wanted a few major changes. First, I wanted Apache instead of NGINX and, second, I wanted to use Puppet instead of Bash. Using VVV and Puppet as a base, this repository attempts to address their shortcomings for my own work with a Vagrant configuration that is ready to go for WordPress plugin or theme development.

The repository contains a basic Vagrant configuration that will configure the following goodies:

* Ubuntu 14.04 LTS
* Apache
* PHP 5.5
* phpbrew (experimental but will eventually allow for multiple PHP versions)
* MySQL
* Xdebug
* PHPUnit
* Postfix
* wp-cli
* phpMyAdmin
* WordPress (Last, Stable, Core and Dev)
* wp-debug plugin
* [Search Replace DB](http://interconnectit.com/products/search-and-replace-for-wordpress-databases/)
* [webgrind](https://github.com/jokkedk/webgrind/)
* [oh-my-zsh](http://ohmyz.sh)
* [MailCatcher](http://mailcatcher.me)
* Test data from [WP Test](http://wptest.io)
* Composer
* node.js
* GIT
* Subversion

## Contributors

* [ChrisWiegman](https://github.com/ChrisWiegman)
* [kraftner](https://github.com/kraftner)
* [michaelbeil](https://github.com/michaelbeil)

## Want to help?

If you find any issues please don't hesitate to submit a pull request.

Current development of the project is focusing on instituting multiple PHP versions using (at least for now) [phpbrew](https://github.com/phpbrew/phpbrew). It needs a lot of work, so if you have a few minutes head on over to the [phpbrew puppet module](https://github.com/ChrisWiegman/puppet-phpbrew) and dig in.

## Getting Started

### Default domains

* pv - Default menu
* phpmyadmin.pv - phpMyAdmin
* replacedb.pv - Search Replace DB
* wordpress.core.pv - WordPress Development (for core dev)
* wordpress.legacy.pv - Last version of WordPress (currently 4.0.1)
* wordpress.stable.pv - Latest WordPress stable (currently 4.1.1)
* wordpress.trunk.pv - WordPress trunk
* webgrind.pv - webgrind
* mailcatcher.pv - MailCatcher

### Install the software

Install [Vagrant](http://vagrantup.com), [VirtualBox](http://virtualbox.org), and the [VirtualBox extensions](https://www.virtualbox.org/wiki/Downloads) for your environment.

Once Vagrant is installed you'll want two plugins to update your local hosts file and update the VirtualBox Guest additions in the Ubuntu install.

```vagrant plugin install vagrant-vbguest```

```vagrant plugin install vagrant-hostsupdater```

### Launch your VM

1. [Download](https://github.com/ChrisWiegman/Primary-Vagrant/archive/master.zip) or clone this repo onto your local machine:

    ```$ git clone --recursive git@github.com:ChrisWiegman/Primary-Vagrant.git PV```

1. In a command prompt, change into the new directory with `cd PV`

1. Start the Vagrant environment with `vagrant up`
	- Be patient as the magic happens. This could take a while on the first run as your local machine downloads the required files.
	- Watch as the script ends, as an administrator or `su` ***password may be required*** to properly modify the hosts file on your local machine.

### Preconfigured Sites

The following websites come pre-configured in the system:

* [Default menu](http://pv)
* WordPress (latest stable release) at [http://wordpress.stable.pv](http://wordpress.stable.pv)
* WordPress Trunk at [http://wordpress.trunk.pv](http://wordpress.trunk.pv)
* WordPress Core Development at [http://wordpress.core.pv](http://wordpress.core.pv)
* Search Replace DB [https://replacedb.pv](https://replacedb.pv)

*Note: WordPress Core dev is taken from git://develop.git.wordpress.org/. Only the src folder is mapped. You can manually set up a build site if desired.

### Configure your Apache VirtualHosts

Edit the file **Vagrantfile** and add paths to your own websites as well as a host entry to reach it.

Edit **manifests/vhosts.pp**. This is where you define virtualhosts and databases. Copy what is there and ask me if you have any questions.

Example:

```
apache::vhost { 'mysite.pv':
	docroot							=> 'path/to/your/site',
	directory						=> 'path/to/your/site',
	directory_allow_override		=> 'All',
	ssl								=> true,
	template						=> '/var/vagrant/conf/vhost.conf.erb',
}
```

*Note: I've provided a top-level wildcard SSL certificate. No further SSL certificate should be needed.

### Change PHP Versions

To change from PHP 5.5, I recommend using a PGP package from [https://launchpad.net/~ondrej/+archive/php5](https://launchpad.net/~ondrej/+archive/php5). You can do so by adding ```apt::ppa { 'ppa:ondrej/php5': }``` to *manifests/php.pp*. Make sure to choose the correct repository for the PHP version you want to use.

Note: this file can also be used to change any php.ini value following the example included in the file.

### Database Access

You can access the database via ssh tunnel into the machine using the *local.vagrant* hostname, the username *vagrant*, the password *vagrant* for ssh, and the username *root* without a password for MySQL.

In addition to the *root* MySQL account the account *username* with the password *password* has also been created and has been granted all privileges.

To create a new database use the following example to edit manifests/mysql.pp

```
mysql_database { 'database_name':
	ensure  => 'present',
	charset => 'utf8',
	collate => 'utf8_general_ci',
	require => Class['mysql::server'],
}
```

### Postfix Configuration

Postfix is configured and set to use your host computer as a mail relay. To receive messages you can use the built in [MailCatcher installation](http://mailcatcher.pv:1080) (this will prevent your real SMTP mail server and mailbox from getting too much abuse).

### WP Test Data
WP Test can be installed via the instructions at (https://github.com/manovotny/wptest). Test data is found in *[Primary Vagrant Folder]/sites/wordpress/wptest* on your host machine.

### node.js

The latest stable node.js version is installed, if you want to pre-install packages just add them to *manifests/nodejs.pp*.

Example:

```
package { 'ungit':
  provider => npm,
  require  => Class['nodejs']
}
```

### Keep your fork up to date with the PV `upstream/master` repo 

* Configure a remote that points to the upstream repository in Git: `git remote add upstream https://github.com/ChrisWiegman/Primary-Vagrant.git` 

See: https://help.github.com/articles/configuring-a-remote-for-a-fork 

The following commands should bring you up to speed: 
* `git checkout <localbranch>`
* `git stash` -- save local changes
* `git pull https://github.com/ChrisWiegman/Primary-Vagrant.git upstream/master`
* `git submodule update --recursive`
* `git stash pop` -- saved local changes are available to be committed 
* Use `git merge tool` if you have any conflicts 

See: https://www.atlassian.com/git/tutorials/syncing/git-pull 

Now, you will be free to PR against Primary Vagrant.

## Note

This server configuration is designed for development use only. Please don't put it on a production server as some of these settings would cause serious security issues.
