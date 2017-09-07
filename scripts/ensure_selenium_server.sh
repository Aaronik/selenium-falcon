#!/bin/bash

###
#
# Selenium Falcon requires a specific java driver to run
# the selenium server, this script ensures its presence
#
# Note: The driver here will get outdated and need to update.
# At the time of writing I can't find an easy way to get the latest
# version number, so I'm just doing it by hand. :/
#
###

# Ensure user has cURL installed
if ! [ `which curl 2>&1` ]; then
  echo "For Pete's sake, go download cURL and try again."
  exit 1
fi

# Update these numbers to have the script update the packages
MAJOR_VERSION='3.0'
SUB_VERSION='3.0.1'

if [ ! -f drivers/selenium-server-standalone.jar ]; then

  echo "Fetching selenium server..."
  curl -O http://selenium-release.storage.googleapis.com/$MAJOR_VERSION/selenium-server-standalone-$SUB_VERSION.jar

  if [ $? -e 0 ]; then
    echo "Something went wrong fetching the selenium server, bailing :("
    exit 1
  fi

  if [ ! -d drivers ]; then
    mkdir drivers
  fi

  mv selenium-server-standalone-$SUB_VERSION.jar drivers/selenium-server-standalone.jar
fi
