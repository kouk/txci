#!/usr/bin/env bash
# pushes source and translation files to Transifex
# called after every successful build on Travis CI
# relies on $TXUSER and $TXPASSWD being set as env
# vars.

# Write .transifexrc file
echo "[https://www.transifex.com]
hostname = https://www.transifex.com
username = $TXUSER
password = $TXPASSWD
token =" > ~/.transifexrc

# Extract messages
# make messages

# Pushing to Transifex under a resource named after the branch name
export TXCONFIG=`cat .tx/config | sed s/txci.core/txci.$TRAVIS_BRANCH/`
echo "$TXCONFIG" > .tx/config
tx --traceback push --source --no-interactive
