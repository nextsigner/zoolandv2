#!/bin/bash
mkdir -p android/res/mipmap-mdpi android/res/mipmap-hdpi android/res/mipmap-xhdpi android/res/mipmap-xxhdpi && \
convert logo.png -resize 48x48 android/res/mipmap-mdpi/ic_launcher.png && \
convert logo.png -resize 72x72 android/res/mipmap-hdpi/ic_launcher.png && \
convert logo.png -resize 96x96 android/res/mipmap-xhdpi/ic_launcher.png && \
convert logo.png -resize 144x144 android/res/mipmap-xxhdpi/ic_launcher.png