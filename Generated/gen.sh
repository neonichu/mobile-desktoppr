#!/bin/sh

removeResponse () {
  sed -i '' -e 's/^{"response"://' -e 's/}$//' "$1"
}

rm -f *.h *.json *.m

curl -s -o user.json https://api.desktoppr.co/1/users/keithpitt &&
removeResponse user.json
../vendor/grenobj/grenobj.py user.json DesktopprUser

curl -s -o wallpaper.json https://api.desktoppr.co/1/users/keithpitt/wallpapers/random && 
removeResponse wallpaper.json
../vendor/grenobj/grenobj.py wallpaper.json DesktopprPicture
