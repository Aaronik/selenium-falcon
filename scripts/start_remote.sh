#!/bin/bash

###
#
# This script automates starting against browserstack.
#
###

# Run on macs
./node_modules/nightwatch/bin/nightwatch --config $HOME/.selenium_falcon/default.json --env mac-firefox-31,mac-chrome-36 "$@"
./node_modules/nightwatch/bin/nightwatch --config $HOME/.selenium_falcon/default.json --env mac-safari-7,mac-safari-6 "$@"

# Run on windowz
./node_modules/nightwatch/bin/nightwatch --config $HOME/.selenium_falcon/default.json --env win-ie-11,win-firefox-31 "$@"
./node_modules/nightwatch/bin/nightwatch --config $HOME/.selenium_falcon/default.json --env win-chrome-36 "$@"
