#!/bin/bash

PROJECT_NAME=Cimon

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

BRANCH_=$(parse_git_branch)
BRANCH=${BRANCH_/\//-}
FILE="${PROJECT_NAME}-${BRANCH/\ /}.zip"
bundle exec ruby scripts/_cache/delete_on_google_drive.rb ${FILE}