#!/bin/bash

###
#
# Selenium Falcon's install and run processes create some pollution.
# This script brings it back to ground 0.
#
###

if [ -d node_modules ]; then
  echo "removing node_modules..."
  rm -rf node_modules
fi

if [ -d drivers ]; then
  echo "removing drivers..."
  rm -rf drivers
fi

if [ -d tests_output ]; then
  echo "removing tests_output folder..."
  rm -rf tests_output
fi
