#!/bin/bash

set -eu

# cp -R scripts/_hooks/* .git/hooks/
ln -sf scripts/_hooks/pre-push .git/hooks/pre-push

brew install libxml2 # For SwiftGen via Mint

# Mint
if [ ! $(which mint) ];then
  echo "  + Installing mint..."
  brew install mint
else
  echo "  + Mint found."
fi

bundle install --path vendor/bundle
