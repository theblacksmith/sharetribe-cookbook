#!/bin/bash -e

cd /var/www

while read -r env; do export $env; done < /etc/environment

bundle exec rake -r /var/www/shared/sync-stdout.rb ts:start
