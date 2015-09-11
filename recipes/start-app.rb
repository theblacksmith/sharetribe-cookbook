#
# Cookbook Name:: Sharetribe
# Recipe:: start-app
#


# Setup a cron job to run rake task ts:index
#
# Cron resource doc:
# cron 'name' do
#   command                    String
#   day                        String
#   environment                Hash
#   home                       String
#   hour                       String
#   mailto                     String
#   minute                     String
#   month                      String
#   notifies                   # see description
#   path                       String
#   provider                   Chef::Provider::Cron
#   shell                      String
#   subscribes                 # see description
#   time                       Symbol
#   user                       String
#   weekday                    String, Symbol
#   action                     Symbol # defaults to :create if not specified
# end

app = node[:sharetribe][:app]

cron 'Sphinx index cron job' do
  action :create
  minute '*/30'
  user 'app'
  command "su -l #{app.user} -c 'cd #{app.path}; bundle exec rake ts:index'"
end

# Creating shared folder
directory "#{app.path}/shared" do
  owner app.user
  group app.group
  mode '0755'
  action :create
end

# STDOUT sync trick
cookbook_file 'stdout.sync trick' do
  source 'app/shared/sync-stdout.rb'
  path "#{app.path}/shared/sync-stdout.rb"
  owner app.user
  group app.group
  mode '0755'
  action :create
end

cookbook_file 'ts:start wrapper script' do
  source 'app/shared/run-tsphinx.sh'
  path "#{app.path}/shared/run-tsphinx.sh"
  owner app.user
  group app.group
  mode '0755'
  action :create
end

template 'Supervisor config for ts:start' do
  source "supervisor-program.erb"
  path "/etc/supervisor/conf.d/tsphinx.conf"
  mode '0644'
  variables({
    :name => 'tsphinx',
    :command => "#{app.path}/shared/run-tsphinx.sh",
    :app => app
  })
end

cookbook_file 'jobs:work wrapper script' do
  source 'app/shared/run-jobs.sh'
  path "#{app.path}/shared/run-jobs.sh"
  owner app.user
  group app.group
  mode '0755'
  action :create
end

template 'Supervisor config for jobs:work' do
  source "supervisor-program.erb"
  path "/etc/supervisor/conf.d/jobs.conf"
  mode '0644'
  variables({
    :name => 'jobs',
    :command => "#{app.path}/shared/run-jobs.sh",
    :app => app
  })
end

service "supervisor" do
  action :restart
end

service "nginx" do
  action :start
end
