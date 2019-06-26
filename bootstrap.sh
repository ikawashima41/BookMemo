#!/bin/sh
# Script to build RxBookManager-iOS project

# install dependencies via Carthage
echo "Install dependencies via Carthage"
carthage bootstrap --no-use-binaries --cache-builds --platform ios

# set projectname
open RxBookManager-iOS.xcodeproj
