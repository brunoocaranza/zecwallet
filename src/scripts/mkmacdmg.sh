#!/bin/bash

if [ -z $QT_PATH ]; then 
    echo "QT_PATH is not set. Please set it to the base directory of Qt"; 
    exit 1; 
fi

if [ -z $APP_VERSION ]; then
    echo "APP_VERSION is not set. Please set it to the current release version of the app";
    exit 1;
fi

#Clean
make distclean 2>&1 >/dev/null

# Build
$QT_PATH/bin/qmake zec-qt-wallet.pro CONFIG+=release
make -j4 >/dev/null

#Qt deploy
mkdir artifacts
rm -f artifcats/zec-qt-wallet.dmg
rm -f artifacts/rw*
cp ../zcash/src/zcashd zec-qt-wallet.app/Contents/MacOS/
$QT_PATH/bin/macdeployqt zec-qt-wallet.app 

create-dmg --volname "zec-qt-wallet-v0.3.0" --volicon "res/logo.icns" --window-pos 200 120 --icon "zec-qt-wallet.app" 200 190 --app-drop-link 600 185 --hide-extension "zec-qt-wallet.app"  --window-size 800 400 artifacts/zec-qt-wallet.dmg zec-qt-wallet.app

mv artifacts/zec-qt-wallet.dmg artifacts/MacOS-zec-qt-wallet-v$APP_VERSION.dmg

