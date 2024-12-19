#!/bin/bash

./tools/rename_xcode_project.sh AppName $1
./tools/rename_xcode_project.sh APP_DISPLAY_NAME $1
./tools/rename_xcode_project.sh APP_BUNDLE_IDENTIFIER $2
#./rename_xcode_project.sh APP_DEVELOPMENT_TEAM $3
