Sharetribe Cookbook
===================

Recipes to install [Sharetribe](https://github.com/sharetribe/sharetribe) Marketplace.

Requirements
------------

#### Cookboks

- apt
- build-essential
- database
- mariadb
- mysql2_chef_gem
- nginx_passenger
- nodejs
- sphinx

Attributes
----------

### For the Sharetribe cookbok

These are all the attributes we have along with their default values. Their names are pretty self-explanatory, so just read through.

~~~
default[:sharetribe] = {
  :env => 'development', # used to set RAILS_ENV
  :app => {
    :path => '/var/www',
    :domain => 'localhost',
    :user => 'app',
    :group => 'www-data'
  },
  :git => {
    :repo => 'https://github.com/sharetribe/sharetribe.git',
    :branch => 'master'
  },
  :db => {
    :install_server => true,
    :create_db => true,
    :create_user => true,
    :name => 'sharetribe_' + node.env,
    :user => 'sharetribe',
    :password => 'secret',
    :root_password => 'secret',
    :host => 'localhost',
    :socket => nil
  },
  # keys to add to .ssh/authorized_keys for ubuntu and app users
  :ssh_keys => []
}
~~~

### For dependencies

These are attributes configured for included recipes.

#### [sphinx](https://supermarket.chef.io/cookbooks/sphinx)

`default[:sphinx][:install_method] = "package"`

#### [nginx_passenger](https://supermarket.chef.io/cookbooks/nginx_passenger)

`default[:nginx_passenger][:nginx_workers] = 2`

#### [mariadb](https://supermarket.chef.io/cookbooks/mariadb)


~~~
default[:mariadb][:install][:version] = '5.5'
default[:mariadb][:install][:prefer_os_package] = true
default[:mariadb][:use_default_repository] = true
default[:mariadb][:forbid_remote_root] = true
default[:mariadb][:server_root_password] = node[:sharetribe][:db][:root_password]
default[:mariadb][:user][:username] = node[:sharetribe][:db][:user]
default[:mariadb][:user][:password] = node[:sharetribe][:db][:password]
~~~

Usage
-----

You really, I mean **REALLY** should set at least `node.sharetribe.db.password` and `node.sharetribe.db.root_password` both of
which default 'secret';

Other than that, just add it to your `Cheffile`, or `Berksfile`, or `metadata.rb` or whatever...

cookbook 'sharetribe', git: 'git://github.com/theblacksmith/sharetribe-cookbook.git'

If you want a ready to use installation, checkout my [Vagrant Sharetribe Box](https://github.com/theblacksmith/vagrant-sharetribe-box)

### Recipes

#### default

Runs all the recipes bellow.

#### users

Creates the user group defined at `node.sharetribe.app.user` and `node.sharetribe.app.group`. Sets up the user home directory and adds any ssh keys to it's `.ssh/authorized_keys` file.

#### prereq

Installs packages and software required to install and run Sharetribe.

#### ruby

Compiles and install at system level **replacing** the current `ruby` the exact version sharetribe uses which is, as of time of writing, `2.1.2`

#### http-server

Installs nginx and passenger and configures a nginx server for the app.

#### database

If `node.sharetribe.db.install_server` is `true`, installs the database server specified in `node.sharetribe.db.vendor`.

If `node.sharetribe.db.create_db` is `true`, creates a new database with the name specified in `node.sharetribe.db.name`

#### app

We are getting close!

1. Creates the app dir
2. Checkout the code (see `node.sharetribe.git`)
3. If `node.sharetribe.db.create_user == true` creates a new database user
4. Configures `database.yml`
5. Runs `bundle install`
6. Runs `bundle exec rake db:schema:load`

#### start-app

Fun time!

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `feature-x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

License: MIT <br>
Authors: [The Blacksmith](http://github.com/theblacksmith) (a.k.a. [Saulo Vallory](http://saulovallory.com))
