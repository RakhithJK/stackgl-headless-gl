#!/bin/bash

set -eo pipefail

npm config delete prefix
if [[ ${TRAVIS_OS_NAME} == "linux" ]]; then
    source ~/.nvm/nvm.sh
else
    source ~/.bashrc
fi

COMMIT_MESSAGE=$(git show -s --format=%B $TRAVIS_COMMIT | tr -d '\n')
PACKAGE_JSON_VERSION=$(node -e "console.log(require('./package.json').version)")

if [[ ${COMMIT_MESSAGE} == ${PACKAGE_JSON_VERSION} ]]; then
  echo "running prebuild"
  node ./node_modules/prebuild/bin.js -t 8.0.0 -t 9.0.0 -t 10.0.0 -t 11.0.0 -t 12.0.0 --strip -u ${GITHUB_TOKEN}
  
  if [[ ${TRAVIS_OS_NAME} == "linux" ]]; then
    node ./node_modules/prebuild/bin.js --libc=musl -t 8.0.0 -t 9.0.0 -t 10.0.0 -t 11.0.0 -t 12.0.0 --strip -u ${GITHUB_TOKEN}
  fi
fi
