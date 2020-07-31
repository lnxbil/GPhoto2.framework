#!/bin/bash

set -xe

cd "$( dirname "${BASH_SOURCE[0]}" )"

NAME="GPhoto2FrameworkInfo"
ARC="$NAME.xcarchive"
APP="release"

rm -rf $ARC $APP

xcodebuild -scheme $NAME -configuration Release build
xcodebuild -scheme $NAME -configuration Release -archivePath $ARC archive
xcodebuild -archivePath $ARC -exportArchive -exportPath $APP -exportOptionsPlist exportOptions.plist

rm -rf $ARC
