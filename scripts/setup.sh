#!/bin/bash

set -eu

ln -sf ../../scripts/hooks/pre-push .git/hooks/pre-push

brew install libxml2 # For SwiftGen via Mint

# Mint
if [ ! $(which mint) ]; then
  echo "  + Installing mint..."
  brew install mint
else
  echo "  + Mint found."
fi

# chisel
if [ ! $(which chisel) ]; then
  echo "  + Installing chisel..."
  brew install chisel
  defaults write com.apple.dt.lldb DefaultPythonVersion 2
else
  echo "  + chisel found."
fi

bundle install --path vendor/bundle
