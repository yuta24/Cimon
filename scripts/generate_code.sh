#!/bin/bash

# generate

mint run krzysztofzablocki/Sourcery sourcery --config TravisCIAPI/.sourcery.yml
mint run krzysztofzablocki/Sourcery sourcery --config CircleCIAPI/.sourcery.yml
mint run krzysztofzablocki/Sourcery sourcery --config BitriseAPI/.sourcery.yml
mint run krzysztofzablocki/Sourcery sourcery --config App/.sourcery.yml

echo ""
echo "********************************************************"
echo " Generated code using sourcery."
echo "********************************************************"
echo ""
