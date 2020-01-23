#!/bin/bash

set -eu

if [ ! $(which xcodegen) ]; then
  echo "  + Installing XcodeGen..."
  brew install xcodegen
else
  echo "  + XcodeGen found."
fi

if [ ! $(which carthage) ]; then
  echo "  + Installing Carthage..."
  brew install carthage
else
  echo "  + Carthage found."
fi

if [ ! $(which swiftgen) ]; then
  echo "  + Installing SwiftGen..."
  brew install swiftgen
else
  echo "  + SwiftGen found."
fi

if [ ! $(which swiftlint) ]; then
  echo "  + Installing SwiftLint..."
  brew install swiftlint
else
  echo "  + SwiftLint found."
fi

if [ ! $(which periphery) ]; then
  echo "  + Installing Periphery..."
  brew tap peripheryapp/periphery
  brew cask install periphery
else
  echo "  + Periphery found."
fi

if [ ! $(which sourcery) ]; then
  echo "  + Installing Sourcery..."
  brew install sourcery
else
  echo "  + Sourcery found."
fi

bundle install --path vendor/bundle
