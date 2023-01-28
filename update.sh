#!/bin/bash

set -e

VERSION="$1"

if [ ! -n "$VERSION" ]; then
    echo "Usage: $0 phpbb_minor_version"
    echo
    echo "Example: $0 3.3"
    exit 1
fi

VERSIONS_URL="http://version.phpbb.com/phpbb/versions.json"
LATEST_VERSION=$(curl --silent --location $VERSIONS_URL | jq --raw-output ".stable[\"$VERSION\"].current")
if [ "$LATEST_VERSION" == "null" ]; then
    echo "PHPBB version not found"
    exit 1
fi

SHA_URL="https://download.phpbb.com/pub/release/3.3/$LATEST_VERSION/phpBB-$LATEST_VERSION.tar.bz2.sha256"
SHA=$(curl --silent --location $SHA_URL | cut -d ' ' -f 1)
if [ "${#SHA}" != "64" ]; then
    echo "Failed to fetch SHA256 of an archive"
    exit 1
fi

sed -i "s/^ENV PHPBB_VERSION .*$/ENV PHPBB_VERSION $LATEST_VERSION/" Dockerfile
sed -i "s/^ENV PHPBB_SHA256 .*$/ENV PHPBB_SHA256 $SHA/" Dockerfile

echo "OK"