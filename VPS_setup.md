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

Create a 2GB swap file:
```
  % dd if=/dev/zero of=/swapfile bs=500M count=4
  % chmod 600 /swapfile
  % mkswap /swapfile
  % swapon /swapfile
  % echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
```

Descrease kernel swap agression:
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

Copy **~/.ssh/id_ed25519.pub** content from Laptop & Desktop to deploy users **~/.ssh/authorized_keys** file.
  
Bash aliases to prevent accidental file misshaps:
```
  % echo "alias cp='/bin/cp -i'" | tee -a ~/.bashrc
  % echo "alias mv='/bin/mv -i'" | tee -a ~/.bashrc
  % echo "alias rm='/bin/rm -i'" | tee -a ~/.bashrc
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

PostgreSQL Configuration
------------------------

Install PostgreSQL:
```
  % sudo apt -y install postgresql-contrib postgresql-9.5 libpq-dev
```

nginx Configuration
-------------------

Install nginx:
```
  % sudo apt -y install nginx
```
