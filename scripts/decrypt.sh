#!/bin/sh

# Decrypt the file
gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_PASSPHRASE" \
--output GoogleService-Info.plist GoogleService-Info.plist.gpg
