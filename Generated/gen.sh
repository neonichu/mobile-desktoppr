#!/bin/sh

curl -s -o user.json https://api.desktoppr.co/1/users/keithpitt &&
../vendor/grenobj/grenobj.py user.json DesktopprUser

curl -s -o wallpapers.json https://api.desktoppr.co/1/users/keithpitt/wallpapers && 
../vendor/grenobj/grenobj.py wallpapers.json DesktopprPicture
