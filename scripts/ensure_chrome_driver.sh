#!/bin/bash

###
#
# Selenium Falcon requires a specific java driver to run
# selenium's integration with chrome. This ensures its installed.
#
###

# Ensure user has cURL installed
if ! [ `which curl 2>&1` ]; then
  echo "For Pete's sake, go download cURL and try again."
  exit 1
fi

if [ ! -f drivers/chromedriver ]; then
  if [ "$(uname)" == "Darwin" ]; then
    OS_NAME=mac32
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    OS_NAME=linux64
  fi

  printf "Fetching chrome driver latest release number... "
  CHROMEDRIVER_VERSION=$(curl -s http://chromedriver.storage.googleapis.com/LATEST_RELEASE)
  echo $CHROMEDRIVER_VERSION

  if [ ! $CHROMEDRIVER_VERSION ]; then
    echo "Something went wrong fetching the latest version number from google, please try again in a minute"
    exit 1
  fi

  echo "Fetching chrome driver..."
  curl -O http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_${OS_NAME}.zip

  # if the filetype of chromedriver is XML, that's a google error. It should be an executable.
  file chromedriver_${OS_NAME}.zip | grep -v 'XML' 2>/dev/null 1>/dev/null
  if [ $? -ne 0 ]; then
    echo """
      Selenium-Falcon:

      Fatal Error: Something went wrong fetching the chrome driver. We tried to fetch:
        version: $CHROMEDRIVER_VERSION
        os:      $OS_NAME
        url:     http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_${OS_NAME}.zip

      You may be able to inspect http://chromedriver.storage.googleapis.com and find the latest one for your
      OS and install it manually. Call it \`chromedriver\` and put it in ./drivers/, then ensure the selenium server
      is installed by running ./scripts/ensure_selenium_server.sh. npm start and you should be good to go, providing
      the latest version of the chrome driver available for your system is compatible with the version of chrome on
      your system.
    """

    exit 1
  fi

  unzip chromedriver_${OS_NAME}.zip
  rm chromedriver_${OS_NAME}.zip

  if [ ! -d drivers ]; then
    mkdir drivers
  fi

  mv chromedriver drivers/
fi
