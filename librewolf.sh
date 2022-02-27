#!/usr/bin/env bash
set -x
DIR=$HOME/Applications
APP=$DIR/librewolf.appimage
URL=https://gitlab.com/api/v4/projects/24386000/releases/
LATEST_VERSION=$(date +%s -d "$(curl -s "$URL" | jq -r '.[0].released_at')")
LOCAL_VERSION=$(stat -c "%Y" "$APP")

DOWNLOAD() {
        curl -s "$URL" | jq -r '.[0].assets.links[].direct_asset_url | select(test("x86_64.AppImage$"))' | xargs curl -o "$APP"
}

if [ ! -f "$APP" ]; then
        mkdir -p "$DIR"
        DOWNLOAD
        chmod +x "$APP"
        exit 0
fi

if [ "$LATEST_VERSION" -gt "$LOCAL_VERSION" ]; then
        DOWNLOAD
fi