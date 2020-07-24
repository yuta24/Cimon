#!/bin/bash

set -eu

PROJECT_DIR=$(cd $(dirname $0)/..; pwd)

PROJECT_NAME=Cimon

# bootstrap

echo "  + Generate xcodeproje by XcodeGen."
xcodegen
bundle exec pod install

echo ""
echo "********************************************************"
echo " This project setted up."
echo " Open ${PROJECT_NAME}.xcworkspace and Enjoy iOS App Develop!! "
echo "********************************************************"
echo ""
