#!/bin/bash

# This script will copy files from the repository to where they need to be and restart the http_api_server.service.

# Works on Debian 11. May need tweaking for other distros...

# Directory to install EventBot
INSTALL_DIR="/opt/HTTP_API_Server"

# Check we're actually on the host server
if [ "$HOSTNAME" != harvest-sigma ]; then
	echo "You can only run this script on the host server."
	exit
fi

# Check the version we're installing is RELEASE
VERSION=$(./http_api_server -version)
if [ "$VERSION" != Release ]; then
	echo "Trying to install $VERSION build. Run './build.sh release' to build the installable version."
	exit
fi

# Need to be root to create users, services etc.
if [ $(id -u) -ne 0 ]; then
	echo "Script must be run as root."
	exit
fi

# Create the http_api_server group, if it doesn't already exist.
if ! id -g "http_api_server" > /dev/null 2&>1; then
	addgroup --system http_api_server
fi

# Create the http_api_server user, if it doesn't already exist.
if ! id -u "http_api_server" > /dev/null 2&>1; then
	# Create the user
	adduser --system --ingroup http_api_server --home=$INSTALL_DIR --no-create-home --disabled-login http_api_server
fi

# Create the installation directory, if it doesn't already exist.
mkdir -p $INSTALL_DIR
chown http_api_server:http_api_server $INSTALL_DIR

# Will fail on first run of this script, but that doesn't really matter.
systemctl stop http_api_server

# Copy the EventBot executable to the installation directory and change permissions and ownership.
cp http_api_server $INSTALL_DIR
chown http_api_server:http_api_server $INSTALL_DIR/http_api_server
chmod 500 $INSTALL_DIR/http_api_server

# Log file. Only needs to be done once.
# TODO: Set up log rotation?
touch $INSTALL_DIR/http_api_server.log
chown http_api_server:http_api_server $INSTALL_DIR/http_api_server.log
chmod 600 $INSTALL_DIR/http_api_server.log

# Config file
# Has to be manually created. See http_api_server.ini.templace for variables.
chown http_api_server:http_api_server $INSTALL_DIR/http_api_server.ini
chmod 400 $INSTALL_DIR/http_api_server.ini

# Copy static assets, if they're newer, and create the www-root directory.
cp --update --recursive gfx $INSTALL_DIR
mkdir -p $INSTALL_DIR/www-root

#cp http_api_server.service /etc/systemd/system
#chown root:root /etc/systemd/system/http_api_server.service
#systemctl daemon-reload
#systemctl enable http_api_server
#systemctl start http_api_server
