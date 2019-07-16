#!/bin/bash

set -eu

PROJECT_NAME=Cimon

# bootstrap

echo "  + Generate xcodeproje by XcodeGen."
mint run yonaskolb/XcodeGen xcodegen
mint run Carthage/Carthage carthage bootstrap --platform iOS --no-use-binaries --cache-builds
bundle exec pod install

echo ""
echo "********************************************************"
echo " This project setted up."
echo " Open ${PROJECT_NAME}.xcworkspace and Enjoy iOS App Develop!! "
echo "********************************************************"
echo ""
