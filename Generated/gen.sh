#!/bin/sh

compare() {
  echo "# $1"
  sed -i '' -e "s/BBU$1/$1/g" "BBU$1.h" &&
  diff -I '^// \|^$' "../Mobile Desktoppr/$1.h" "BBU$1.h"
}

removeResponse () {
  sed -i '' -e 's/^{"response"://' -e 's/}$//' "$1"
}

rm -f *.h *.json *.m

curl -s -o user.json https://api.desktoppr.co/1/users/keithpitt &&
removeResponse user.json &&
../vendor/grenobj/grenobj.py user.json DesktopprUser &&
compare DesktopprUser

curl -s -o wallpaper.json https://api.desktoppr.co/1/users/keithpitt/wallpapers/random && 
removeResponse wallpaper.json &&
../vendor/grenobj/grenobj.py wallpaper.json DesktopprPicture &&
compare DesktopprPicture
