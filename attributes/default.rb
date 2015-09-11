default[:sharetribe] = {
  :env => 'development',
  :app => {
    :name => 'sharetribe',
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
    :vendor => 'mariadb',
    :name => 'sharetribe_development',
    :user => 'sharetribe',
    :password => 'secret',
    :root_password => 'secret',
    :host => 'localhost',
    :socket => nil
  },
  :ssh_keys => [],
  :nginx => {
    :cert => nil,
    :cert_key => nil,
    :log_format => '',
    :log_dir => nil,
    :redirect_to_https => false,
    :min_instances => nil,
    :max_body_size => nil,
    :redirect_to_https => false,
    :http => true
  },
  :passenger => {
    :ruby => nil, # passenger defaults to /usr/bin/ruby
  }
}

default[:sphinx][:install_method] = "package"

default[:nginx_passenger][:nginx_workers] = 2

default[:mariadb][:install][:version] = '5.5'
default[:mariadb][:install][:prefer_os_package] = true
default[:mariadb][:use_default_repository] = true
default[:mariadb][:forbid_remote_root] = true
default[:mariadb][:server_root_password] = 'secret'
default[:mariadb][:user][:username] = 'sharetribe'
default[:mariadb][:user][:password] = 'secret'

default[:mysql][:install][:version] = '5.5'
default[:mysql][:install][:prefer_os_package] = true
default[:mysql][:use_default_repository] = true
default[:mysql][:forbid_remote_root] = true
default[:mysql][:server_root_password] = 'secret'
default[:mysql][:user][:username] = 'sharetribe'
default[:mysql][:user][:password] = 'secret'
