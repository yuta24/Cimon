#!/bin/bash

# generate

sourcery --config TravisCIAPI/.sourcery.yml
sourcery --config CircleCIAPI/.sourcery.yml
sourcery --config Cimon/.sourcery.yml

echo ""
echo "********************************************************"
echo " Generated code using sourcery."
echo "********************************************************"
echo ""
