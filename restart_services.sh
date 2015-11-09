#!/usr/bin/env bash

echo =============================================================================
echo Preparing nginx...
echo =============================================================================

sudo cp Fenrir/config/fenrir_nginx_conf /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/fenrir_nginx_conf /etc/nginx/sites-enabled/

echo =============================================================================
echo Killing extraneous processes...
echo =============================================================================

sudo /etc/init.d/iptables stop
# sudo /usr/local/share/neo4j/bin/neo4j stop
# sudo /usr/local/share/elasticsearch/bin/service/elasticsearch stop
kill -9 $(cat /vagrant/Fenrir/tmp/pid/unicorn.pid )
sudo /usr/sbin/nginx -s stop


echo =============================================================================
echo Bundling and starting unicorn
echo =============================================================================

# sudo /usr/local/share/neo4j/bin/neo4j start
# sudo /usr/local/share/elasticsearch/bin/service/elasticsearch start
# cd /vagrant/apps/muninn/ && bundle && bundle exec unicorn -c /vagrant/apps/muninn/config/unicorn.rb -D
cd /vagrant/Fenrir/ && bundle && bundle exec unicorn -c /vagrant/Fenrir/config/unicorn.rb -D
#cd /vagrant/apps/muninn/ && bundle && puma -w 4 -p 3000 --pidfile /tmp/muninn.pid -d -C /vagrant/muninn.conf
#cd /vagrant/apps/huginn/ && bundle && puma -w 4 -p 3001 --pidfile /tmp/huginn.pid -d -C /vagrant/huginn.conf
sudo /usr/sbin/nginx

cd /vagrant/

