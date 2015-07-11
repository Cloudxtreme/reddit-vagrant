#!/bin/bash
apt_get=/usr/bin/apt-get
ln=/bin/ln
wget=/usr/bin/wget
service=/usr/sbin/service
reddit_run=/usr/local/bin/reddit-run
init_ctl=/sbin/initctl

export REDDIT_USER=vagrant
export REDDIT_GROUP=vagrant
export REDDIT_HOME="/host"

export REDDIT_PLUGINS=$1
export REDDIT_DOMAIN=$3

# Find installer
installer=$REDDIT_HOME/src/reddit/install-reddit.sh
if [ ! -f $installer ]; then
    installer=$HOME/install-reddit.sh
    wget -O $installer https://raw.githubusercontent.com/reddit/reddit/master/install-reddit.sh
fi

# Install reddit and all its dependencies.
. $installer

if [ $2 ]; then
  $init_ctl emit reddit-stop
  eval "cd $REDDIT_HOME/src/reddit; $reddit_run scripts/inject_test_data.py -c 'inject_test_data()'"
  $init_ctl emit reddit-start
fi
