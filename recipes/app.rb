#
# Cookbook Name:: Sharetribe
# Recipe:: app
#

apt_package 'git'

app = node[:sharetribe][:app]
giti = node[:sharetribe][:git]

# Create app folder
directory app[:path] do
  owner app[:user]
  group app[:group]
  mode '0755'
  action :create
end

# Checkout the code
git app[:path] do
  repository giti[:repo]
  revision giti[:branch]
  action :checkout
  user app[:user]
  group app[:group]
end

#
# DATABASE
#
node.default[:sharetribe][:db][:name] = "sharetribe_#{node[:sharetribe][:env]}"
db = node[:sharetribe][:db]

mysql_connection_info = {
  :host     => db.host,
  :username => 'root',
  :password => db.root_password
}

# Create database
if db.create_db
  mysql_database db.name do
    connection mysql_connection_info
    action :create
  end
end

# Create database user
if db.create_user
  mysql_database_user db[:user] do
    connection mysql_connection_info
    password db[:password]
    host (node[:sharetribe][:env] == 'development' ? '%' : '127.0.0.1')
    action :grant
  end
end

# Configure database connection
template "#{app.path}/config/database.yml" do
  source "database.erb"
  owner "#{app.user}"
  group "#{app.group}"
  mode '0644'
  variables({
    :env => node[:sharetribe][:env],
    :db => db
  })
end

# Bundle install
execute 'Bundle install' do
  command "su -l #{app.user} -c 'cd #{app.path}; bundle install'"
end

# Load db schema
if !File.exists? "#{app.path}/db/schema-loaded"
  execute 'Load database schema' do
    command "su -l #{app.user} -c 'cd #{app.path}; bundle exec rake db:schema:load'"
  end

  file "#{app.path}/db/schema-loaded" do
    action :touch
  end
else
  log "Schema already loaded. Delete #{app.path}/db/schema-loaded if you want to run it again"
end
