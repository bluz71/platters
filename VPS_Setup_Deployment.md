VPS Setup and Application Deploymemt
====================================

This application is hosted on a DigitalOcean *Ubuntu 18.04* droplet with the
following configuration.

Note, please make sure DNS is properly configured. Details about setting up
a domain registered at Namecheap with DigitalOcean DNS can be found
[here](https://www.digitalocean.com/community/tutorials/how-to-point-to-digitalocean-nameservers-from-common-domain-registrars#registrar-namecheap).

Initial server setup
--------------------

As the **root** user update the base operating system:

```
  % apt -y update
  % apt -y upgrade
  % reboot
```

Enable automatic upgrades, edit **/etc/apt/apt.conf.d/10periodic** with the
following content:

```
  APT::Periodic::Update-Package-Lists "1";
  APT::Periodic::Download-Upgradeable-Packages "1";
  APT::Periodic::AutocleanInterval "7";
  APT::Periodic::Unattended-Upgrade "1";
```

Configure the correct timezone:

```
  % dpkg-reconfigure tzdata
```

Create a 2GB swap file:

```
  % dd if=/dev/zero of=/swapfile bs=500M count=4
  % chmod 600 /swapfile
  % mkswap /swapfile
  % swapon /swapfile
  % echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
```

Decrease kernel swap aggression:

```
  % sysctl vm.swappiness=10
  % sysctl vm.vfs_cache_pressure=50
  % echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
  % echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
```

Add the deployment user:

```
  % adduser deploy
  % gpasswd -a deploy sudo
```

Configure and enable the firewall:

```
  % ufw allow ssh
  % ufw allow http
  % ufw allow https
  % ufw enable
```

:bulb: To block a malicious IP range and display the current firewall status:

```
  % sudo ufw insert 1 deny from X.Y.0.0/16
  % sudo ufw status numbered
```

Since this guide was written Digital Ocean now provides Cloud Firewalling.
Please setup a Cloud Firewall, allowing *ssh/http/https*, using
[this guide](https://www.digitalocean.com/community/tutorials/an-introduction-to-digitalocean-cloud-firewalls).
Note, a Cloud Firewall runs outside the context of a droplet, hence it is more
efficient than a UFW firewall.

Install Fail2ban:

```
  % apt install fail2ban
```

Configure Fail2ban protection for SSH, copy the following content to
**/etc/fail2ban/jail.local**:

```
[DEFAULT]

bantime = 86400

[sshd]

maxretry = 1
```

Restart Fail2ban with the updated configurations:

```
  % service fail2ban restart
```

View status of Fail2ban SSH jail:

```
  % fail2ban-client status sshd
```

Install rng-tools to help speed up entropy generation:

```
  % apt install rng-tools
```

Setup passwordless sudo commands that will be required by the **deploy** user,
append the following content to */etc/sudoers*:

```
deploy  ALL=NOPASSWD: /bin/systemctl daemon-reload
deploy  ALL=NOPASSWD: /usr/sbin/service puma restart
deploy  ALL=NOPASSWD: /usr/sbin/service sidekiq restart
```

Note, to list all services:

```
% service --status-all
```

All configuration from here onwards will be undertaken via the **deploy** user
account.

Initial configuration for the deploy account
--------------------------------------------

As the **deploy** user setup SSH access:

```
  % ssh-keygen -t ed25519 -o -a 100
  % touch ~/.ssh/authorized_keys
  % chmod 600  ~/.ssh/authorized_keys
```

Copy **~/.ssh/id_ed25519.pub** content from developer user Laptop & Desktop to
the deploy user's **~/.ssh/authorized_keys** file.

Harden the SSH server.  As the **root** user edit **/etc/ssh/sshd_config**:

* comment out all HostKey entries
* change *PermitRootLogin* to **no**
* append the following entries to the end of the file:

```
  PasswordAuthentication no
  HostKey /etc/ssh/ssh_host_ed25519_key
  Ciphers chacha20-poly1305@openssh.com
  KexAlgorithms curve25519-sha256@libssh.org
  MACs hmac-sha2-256-etm@openssh.com
```

Create useful bash aliases. Append this content to the end of *~/.bashrc*:

```
alias cp='/bin/cp -i'
alias mv='/bin/mv -i'
alias rm='/bin/rm -i'
alias be='bundle exec'
alias railsc='RAILS_ENV=production rails c'
alias g='git'
alias h='history'
alias v='vim'
alias free='free -th'
```

Configure Ruby REPL. Create *~/.irbrc* with the following content:

```
require 'hirb'
Hirb.enable
```

Shutup Bash bell:

```
  % echo "set bell-style none" | tee -a ~/.inputrc
```

Install Yarn, Linuxbrew and required development tooling:

```
  % curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  % echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  % sudo apt update
  % sudo apt -y install build-essential curl git m4 ruby texinfo libbz2-dev \
       libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev \
       libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev liblzma-dev \
       nodejs imagemagick yarn
  % sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  % echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' | tee -a ~/.profile
```

Logout and log back in:

```
  % brew install the_silver_searcher
```

Ruby Configuration
------------------

Install Ruby:

```
  % brew install ruby-install
  % brew install chruby
  % echo 'gem: --no-rdoc --no-ri' | tee -a ~/.gemrc
  % sudo apt install libjemalloc-dev

  % ruby-install ruby 2.6.6 -- --with-jemalloc
  % \rm -rf src
```

Add the following to ~/.profile to pickup the above built version of Ruby:

```
  if [ -f /home/linuxbrew/.linuxbrew/share/chruby/chruby.sh ]; then
      . /home/linuxbrew/.linuxbrew/share/chruby/chruby.sh
      chruby 2.6.6
  fi
```

Note, we need to append the above into ~/.profile (as against ~/.bashrc) for
systemd services, such as *puma* and *sidekiq*, to work.

Logout and log back in and then install the latest version of Rails:

```
  % gem install rails
```

Note, to fix an issue with `mina deploy` it was necessary to install a specific
version of *bundler*:

```
  % gem install bundler -v 1.17.3
```

PostgreSQL Configuration
------------------------

Install PostgreSQL:

```
  % sudo apt -y install postgresql-contrib postgresql-10 libpq-dev
```

Configure PostgresSQL to only accept local socket connections:

```
  % sudo vim /etc/postgresql/10/main/pg_hba.conf
```

Comment out host rules near the end of the file as follows:

```
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
#host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
#host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            md5
#host    replication     postgres        ::1/128                 md5
```

Restart the service:

```
  % sudo service postgresql restart
```

Create the PostgreSQL user and database for the application (enter a specific
password that will be saved into the *application.yml* secrets file):

```
  % sudo -u postgres createuser --superuser --pwprompt deploy
  % sudo -u postgres createdb --owner deploy platters_production
```

*Backup and restore*, if needed use these commands to backup and restore the
PostgreSQL production database:

```
  % sudo -u postgres pg_dump platters_production > platters_db.bak
  % sudo -u postgres psql platters_production < platters_db.bak
```

Redis Configuration
-------------------

Install Redis:

```
  % sudo apt -y install redis-server
```

Note, to monitor Redis:

```
  % redis-cli --scan
  % redis-cli monitor | grep cache
```

Node Upgrade
------------

Ubuntu LTS ships with an outdated [NodeJS](https://nodejs.org) package.

Upgrade to a later version:

```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs
```

Note, replace `_12` with whatever version is required.

Initial nginx Configuration
----------------------------

Install nginx:

```
  % sudo apt -y install nginx
```

Note, to list nginx package details:

```
  % dpkg -l nginx
```

Hide nginx server version from the internet and add simple DDOS limits:

```
  % sudo vim /etc/nginx/nginx.conf
```

Uncomment the *server_tokens off* line.

Add the following into the *http* block before include **include** statements:

```
# Customization, poor man's DDOS protection.
limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:5m;
limit_req_zone  $binary_remote_addr zone=req_limit_per_ip:5m rate=5r/s;

# Geo-restriction, only allow access from Australia, NZ, USA and Canada.
# Country codes: https://dev.maxmind.com/geoip/legacy/codes/iso3166/
geoip_country /usr/share/GeoIP/GeoIP.dat;
map $geoip_country_code $allowed_country {
    default no;
    AU yes;
    NZ yes;
    US yes;
    CA yes;
}
```

Note, to list all open TCP ports:

```
  % netstat --listening --tcp
```

Let's Encrypt SSL for nginx
---------------------------

Install certbot:

```
sudo add-apt-repository ppa:certbot/certbot
sudo apt install certbot
```

Create Let's Encrypt certificates:

```
  % sudo certbot certonly --webroot --webroot-path /var/www/html --email <<email-address>> -d platters.cc --text --agree-tos
```

Note, Let's Encrypt certificates last 90 days.

Create a custom Diffie-Hellman group to protect against the Logjam attack:

```
  % mkdir ~/certs/
  % cd ~/certs/
  % openssl dhparam -out dhparams.pem 2048
```

Create a cronjob that tries to renew the certificates at 2:30AM on the 7th of
each month, and then restarts nginx:

```
  % sudo crontab -e
```

Add this content, save and then exit:

```
30 2 7 * * /usr/bin/certbot renew >> /var/log/certbot-renew.log
35 2 7 * * /bin/systemctl reload nginx
```

Mina deployment
---------------

Mina will be used to deploy the Platters application to the VPS.

Carry out the initial Mina setup:

```
  % mina setup
```

Log onto the deployment server and setup the required shared directory and
symlink:

```
  % mkdir -p platters_deploy/shared/tmp/sockets
  % mkdir -p platters_deploy/shared/config
  % mkdir -p platters_deploy/shared/node_modules
  % ln -s platters_deploy/current platters
```

Also setup *platters_deploy/shared/config/application.yml* with the
application secrets.

*Temporary*, to bootstap the upcoming Puma and Sidekiq services it is required
that the `on :launch do` block of *config/deploy.rb* in the *platters* Git
repository be commented out, committed and pushed to Github.

Now deploy the initial application:

```
  % mina deploy
```

*Important*, please reverse the `on :launch do` commenting out noted above, and
don't forget to push to Github.

Puma and Sidekiq services
-------------------------

Setup, enable and start the Puma service:

```
  % sudo ln -s /home/deploy/platters/config/puma.service /lib/systemd/system/
  % sudo systemctl enable puma.service
  % sudo service puma start
```

Setup, enable and start the Sidekiq service:

```
  % sudo ln -s /home/deploy/platters/config/sidekiq.service /lib/systemd/system/
  % sudo systemctl enable sidekiq.service
  % sudo service sidekiq start
```

Enable *systemd* memory reporting by enabling `DefaultMemoryAccounting=yes`
option:

```
   sudo vim /etc/systemd/system.conf
   sudo reboot
```

Verify the status of both services:

```
  % sudo systemctl status puma
  % sudo systemctl status sidekiq
```

Final nginx Configuration
-------------------------

Site-enable the application specific nginx configuration:

```
  % sudo rm /etc/nginx/sites-enabled/default
  % sudo ln -s /home/deploy/platters/config/nginx.conf /etc/nginx/sites-enabled/platters
  % sudo service nginx restart
```

Please carry out a [SSL Server test](https://www.ssllabs.com/ssltest/) to
confirm the status of the TLS configuation.

Optional, load up seed data
---------------------------

To load up seed data:

```
  % cd platters
  % RAILS_ENV=production rails db:seed
```
