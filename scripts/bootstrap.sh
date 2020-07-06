#!/bin/bash

set -eu

PROJECT_DIR=$(cd $(dirname $0)/..; pwd)

PROJECT_NAME=Cimon

# bootstrap

echo "  + Generate xcodeproje by XcodeGen."
xcodegen
carthage bootstrap --platform iOS --no-use-binaries --cache-builds --use-ssh
bundle exec pod install

echo ""
echo "********************************************************"
echo " This project setted up."
echo " Open ${PROJECT_NAME}.xcworkspace and Enjoy iOS App Develop!! "
echo "********************************************************"
echo ""
