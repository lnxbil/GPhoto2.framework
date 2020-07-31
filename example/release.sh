#!/bin/bash

set -xe

NAME="GPhoto2FrameworkInfo"
ARC="$NAME.xcarchive"
APP="$NAME.app"

rm -rf $ARC $APP

xcodebuild -scheme $NAME -configuration Release build
xcodebuild -scheme $NAME -configuration Release -archivePath $ARC archive
xcodebuild -archivePath $ARC -exportArchive -exportPath $APP -exportOptionsPlist exportOptions.plist

rm -rf $ARC
