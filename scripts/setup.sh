#!/bin/bash

set -eu

cd `dirname $0`/..

# Mint
if test ! $(which mint)
then
  echo "  + Installing mint..."
  brew install mint
else
  echo "  + Mint found."
fi

bundle install --path vendor/bundle
