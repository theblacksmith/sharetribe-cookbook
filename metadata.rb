name             'sharetribe'
maintainer       'The Blacksmith (a.k.a. Saulo Vallory)'
maintainer_email 'me@saulovallory.com'
license          'MIT'
description      'Installs/Configures Sharetribe'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# System cookbooks
depends          'apt'
depends          'build-essential'

# Stack cookbooks
depends          'database'
depends          'mariadb'
depends          'nginx_passenger'
depends          'nodejs'
depends          'sphinx'
depends          'mysql2_chef_gem'

# App cookbooks
