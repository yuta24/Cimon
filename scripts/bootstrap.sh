#!/bin/bash

set -eu

PROJECT_NAME=Cimon

# bootstrap

echo "  + Generate xcodeproje by XcodeGen."
mint run --silent mxcl/swift-sh swift-sh `dirname $0`/../project.swift
mint run --silent Carthage/Carthage carthage bootstrap --platform iOS --cache-builds
bundle exec pod install

echo ""
echo "********************************************************"
echo " This project setted up."
echo " Open ${PROJECT_NAME}.xcworkspace and Enjoy iOS App Develop!! "
echo "********************************************************"
echo ""