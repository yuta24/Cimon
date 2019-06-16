#!/bin/bash

set -eu

cp -R scripts/_hooks/* .git/hooks/

# Mint
if test ! $(which mint)
then
  echo "  + Installing mint..."
  brew install mint
else
  echo "  + Mint found."
fi

bundle install --path vendor/bundle
