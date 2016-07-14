# puppet-ngrok

An opinionated Puppet Module to install and manage [Ngrok](https://ngrok.com/).

puppet-ngrok is available on the
[Puppet Forge](https://forge.puppetlabs.com/thekevjames/ngrok).

## Usage

Simply

```puppet
class { '::ngrok':
  home  => '/home/kevin',
  token => hiera('ngrok', '[unsecretify me!]'),
}
```

to make sure ngrok is installed.

## Configuration

In addition to the above value set for `ngrok`, you can also use
hiera to override the following defaults:

```yaml
ngrok::dependencies:
  - curl
  - unzip

ngrok::url: https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
```
