#!/bin/bash

# simple example jenkins hook

set -e

git clean -fd
npm run-script clean

npm install

npm run-script remote-default
