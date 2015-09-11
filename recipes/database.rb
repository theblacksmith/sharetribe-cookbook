#
# Cookbook Name:: sharetribe
# Recipe:: database
#

#raise “Attribute: mariadb.server_root_password is not defined” unless String === node[:mariadb][:server_root_password]

db = node[:sharetribe][:db]

if db.install_server
  node.set[db.vendor][:server_root_password] = db.root_password
  node.set[db.vendor][:user][:username] = db.user
  node.set[db.vendor][:user][:password] = db.password

  include_recipe "#{db.vendor}::server"
end

include_recipe "#{db.vendor}::client"

mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Mariadb
  action :install
end
