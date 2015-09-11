#
# Cookbook Name:: Sharetribe
# Recipe:: default
#

include_recipe "sharetribe::users"

include_recipe "sharetribe::prereq"

include_recipe "sharetribe::ruby"

include_recipe "sharetribe::http-server"

include_recipe "sharetribe::database"

include_recipe "sharetribe::app"

include_recipe "sharetribe::start-app"
