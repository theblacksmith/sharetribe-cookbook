#
# Cookbook Name:: Sharetribe
# Recipe:: prereq
#

include_recipe "apt"

include_recipe "build-essential"

package 'Install packages' do
  package_name [
    'libmariadbclient18',
    'libmariadbclient-dev',
    'libmariadbd-dev',
    'git-core',
    'curl',
    'zlib1g-dev',
    'libssl-dev',
    'libreadline-dev',
    'libyaml-dev',
    'libxml2-dev',
    'libxslt1-dev',
    'libcurl4-openssl-dev',
    'libffi-dev',
    'imagemagick',
    'supervisor'
  ]

  action :install
end

include_recipe "nodejs"

include_recipe "sphinx"
