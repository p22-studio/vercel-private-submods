#!/bin/sh

if [ "$GITHUB_ACCESS_TOKEN" == "" ]; then
  echo "Error: GITHUB_ACCESS_TOKEN is empty"
  exit 1
fi
# stop script execution on error
set -e

for s in $(git config --file .gitmodules --name-only --get-regexp "^submodule\..*\.url$")
do
  echo Updating $s

  URL_CURRENT=$(git config --file=.gitmodules --get $s)
  URL_WITH_TOKEN=$(sed "s/:\/\//:\/\/$GITHUB_ACCESS_TOKEN@/" <<< $URL_CURRENT)
  git config --file=.gitmodules $s $URL_WITH_TOKEN

  git submodule sync
  git submodule update --init
done