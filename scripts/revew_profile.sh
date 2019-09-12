#!/bin/bash

set -eu

bundle exec fastlane match development --force true --shallow_clone --readonly false
bundle exec fastlane match adhoc --force true --shallow_clone --readonly false
bundle exec fastlane match appstore --force true --shallow_clone --readonly false
