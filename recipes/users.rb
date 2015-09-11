#
# Cookbook Name:: Sharetribe
# Recipe:: users
#
# Creates the app user and group then adds ssh keys for the user

app = node[:sharetribe][:app]

group app.group do
  action :create
end

user app.user do
  comment 'The user which runs the sharetribe app'
  gid app.group
  manage_home true
  home "/home/#{app.user}"
  shell '/bin/bash'
  action :create
end

if node[:sharetribe][:ssh_keys].length > 0
  ssh_keys = ""

  node[:sharetribe][:ssh_keys].each do |key|
    ssh_keys += "#{key}\n"
  end

  # Create .ssh dir for app user
  directory "/home/#{app.user}/.ssh" do
    owner app.user
    mode '0600'
    action :create
  end

  file "/home/#{app.user}/.ssh/authorized_keys" do
    sensitive true
    content ssh_keys
    owner user
    mode '0600'
  end
end
