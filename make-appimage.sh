#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q mate-calc | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/a1fd8b31af06ecfc3a30cf5dcbbc63f570ed1ac8/Papirus/64x64/apps/accessories-calculator.svg
export DESKTOP=/usr/share/applications/mate-calc.desktop
export ALWAYS_SOFTWARE=1 #gtk3 app

# Deploy dependencies
quick-sharun /usr/bin/mate-calc*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
