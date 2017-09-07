#!/bin/bash

###
#
# Just a quick script for ease of npm script writing.
#
###

set -e

scripts/ensure_chrome_driver.sh
scripts/ensure_selenium_server.sh
