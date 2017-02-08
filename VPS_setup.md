VPS Setup
=========

This application is hosted on a DigitalOcean *Ubuntu 16.04* droplet with the
following configuration.

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
  % sudo dpkg-reconfigure tzdata
```

Create a 2GB swap file:
```
  % dd if=/dev/zero of=/swapfile bs=500M count=4
  % chmod 600 /swapfile
  % mkswap /swapfile
  % swapon /swapfile
  % echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
```

Decrease kernel swap agression:
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

Edit **/etc/fail2ban/filter.d/sshd.conf** and append the following to the end
of the failregex stanza (below the spam_unix rule):
```
^%(__prefix_line)sfatal\: Unable to negotiate with <HOST>.*\[preauth\]$
```

Restart Fail2ban with the updated configurations:
```
  % sudo service fail2ban restart
```

View status of Fail2ban SSH jail:
```
  % sudo fail2ban-client status sshd
```

Install rng-tools to help speed up entropy generation:
```
  % sudo install rng-tools
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

Copy **~/.ssh/id_ed25519.pub** content from Laptop & Desktop to the deploy
user's **~/.ssh/authorized_keys** file.
  
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
Bash aliases to prevent accidental file misshaps:
```
  % echo "alias cp='/bin/cp -i'" | tee -a ~/.bashrc
  % echo "alias mv='/bin/mv -i'" | tee -a ~/.bashrc
  % echo "alias rm='/bin/rm -i'" | tee -a ~/.bashrc
```

Shutup Bash bell:
```
  % echo "set bell-style none" | tee -a ~/.inputrc
```

Install Linuxbrew and required development tooling:
```
  % sudo apt -y install build-essential curl git m4 ruby texinfo libbz2-dev \
       libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev \
       libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev liblzma-dev \
       python-software-properties nodejs imagemagick
  % ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  % echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' | tee -a ~/.bashrc
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

  % ruby-install ruby 2.3.3 -- --with-jemalloc
  % \rm -rf src
```

Confirm that the above built version of Ruby correctly linked against
*jemalloc*:
```
  % ruby -r rbconfig -e "puts RbConfig::CONFIG['LIBS']"
```

Add the following to ~/.bashrc to pickup the above built version of Ruby:
```
  if [ -f ~/.linuxbrew/share/chruby/chruby.sh ]; then
      . ~/.linuxbrew/share/chruby/chruby.sh
      chruby 2.3.3
  fi
```

Install the latest version of Rails:
```
  % gem install rails
```
Temporary fix for *rainbow* frozen String issue
(https://github.com/sickill/rainbow/issues/44):
```
  % gem update --system
```

Add in a useful bash alias:
```
  % echo "alias be='bundle exec'" | tee -a ~/.bashrc
```

PostgreSQL Configuration
------------------------

Install PostgreSQL:
```
  % sudo apt -y install postgresql-contrib postgresql-9.5 libpq-dev
```

Configure PostgresSQL to only accept local socket connections:
```
  % sudo vim /etc/postgresql/9.5/main/pg_hba.conf
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

Create the PostgreSQL user and database for the application:

```
  % sudo -u postgres createuser --superuser --pwprompt deploy
  % sudo -u postgres createdb --owner deploy platters_production
```

Redis Configuration
-------------------

Install Redis:

```
  % sudo apt -y install redis-server
```

Manual Deployment
-----------------

Clone the repository:
```
  % git clone https://github.com/bluz71/platters.git
```

Install Ruby libraries and dependencies:
```
  % cd platters
  % bundle
```

Set up *config/application.yml* with application secrets.

Migrate and seed the database:
```
  % rails db:migrate
  % rails db:seed
```

Precompile assets:
```
  % RAILS_ENV=production rails assets:precompile
```

nginx Configuration
-------------------

Install nginx:
```
  % sudo apt -y install nginx
```
