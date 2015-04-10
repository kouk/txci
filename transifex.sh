#!/usr/bin/env bash
# pushes source and translation files to Transifex
# called after every successful build on Travis CI
# relies on $TXUSER and $TXPASSWD being set as env
# vars.

echo "Transifex-client version: `tx --version`"

# Write .transifexrc file
echo "[https://www.transifex.com]
hostname = https://www.transifex.com
username = $TXUSER
password = $TXPASSWD
token =" > ~/.transifexrc

# Get source language and file into env vars
export SOURCE_LANG=`cat .tx/config | grep source_lang | awk '{ print $3 }'`
export SOURCE_FILE=`cat .tx/config | grep source_file | awk '{ print $3 }'`

# Create copy of current source file
mv $SOURCE_FILE $SOURCE_FILE.source

# Pull canonical source file available on `devel` from Transifex.
tx pull -l $SOURCE_LANG

# Create diff source file
msgcomm $SOURCE_FILE $SOURCE_FILE.source --less-than=2 | msgattrib --no-fuzzy --no-obsolete > $SOURCE_FILE.diff
mv $SOURCE_FILE.diff $SOURCE_FILE
rm $SOURCE_FILE.source

# Pushing to Transifex
export TXCONFIG=`cat .tx/config | sed s/txci.core/txci.$TRAVIS_BRANCH/`
echo "$TXCONFIG" > .tx/config
tx --traceback push --source --no-interactive
