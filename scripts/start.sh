#!/bin/bash

###
#
# Just a quick script for ease for the npm start script
#
###

./node_modules/nightwatch/bin/nightwatch --config ./nightwatch_local.json "$@"
