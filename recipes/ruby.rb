#
# Cookbook Name:: Sharetribe
# Recipe:: ruby
#

user = node[:sharetribe][:app][:user]
group = node[:sharetribe][:app][:group]

# Another option
bash 'Install ruby 2.1.2 from source' do
  not_if { File.exists?('/usr/local/bin/ruby') }
  cwd "/tmp"
  creates '/usr/local/lib/ruby/2.1.2'
  code <<-EOH
  wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz

  tar -xvzf ruby-2.1.2.tar.gz
  cd ruby-2.1.2/

  ./configure --prefix=/usr/local
  make
  make install

  chown -R #{user}:#{group} /usr/local/bin
  chown -R #{user}:#{group} /usr/local/lib/ruby
  EOH
  action :run
end

# Install bundler
bash 'Install bundler' do
  not_if 'which bundle'
  user user
  code "gem install bundler"
  action :run
end

bash 'Set machine level RAILS_ENV' do
  not_if 'grep RAILS_ENV /etc/environment'
  code "echo RAILS_ENV=#{node[:sharetribe][:env]} >> /etc/environment"
  action :run
end

# re-link /usr/bin/ruby to /usr/local/bin/ruby
link '/usr/bin/ruby' do
  action :delete
end

link '/usr/bin/ruby' do
  to '/usr/local/bin/ruby'
  action :create
end
