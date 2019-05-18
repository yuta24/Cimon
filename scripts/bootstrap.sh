#!/bin/bash

set -eu

PROJECT_NAME=Cimon

cd `dirname $0`/..

`dirname $0`/setup.sh

# bootstrap

echo "  + Generate xcodeproje by XcodeGen."
mint run yonaskolb/XcodeGen xcodegen
mint run Carthage/Carthage carthage bootstrap --platform iOS --cache-builds
bundle exec pod repo update
bundle exec pod install

echo ""
echo "********************************************************"
echo " This project setted up."
echo " Open ${PROJECT_NAME}.xcworkspace and Enjoy iOS App Develop!! "
echo "********************************************************"
echo ""
