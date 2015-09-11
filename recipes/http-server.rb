#
# Cookbook Name:: Sharetribe
# Recipe:: http-server
#

# Don't create a default site
node.set[:nginx_passenger][:catch_default] = false

include_recipe "nginx_passenger::default"

app = node[:sharetribe][:app]

service "nginx" do
  action    :nothing
  supports  :start => true, :restart => true, :reload => true
end

template "/etc/nginx/sites-available/default" do
  source "nginx-site.erb"
  owner "#{app.user}"
  group "#{app.group}"
  mode '0644'
  variables({
    :app => node[:sharetribe][:app],
    :nginx => node[:sharetribe][:nginx],
    :passenger => node[:sharetribe][:passenger],
  })
  notifies :reload, "service[nginx]"
end
