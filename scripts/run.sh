#!/bin/sh
set -e

xctool -project AccessLecture.xcodeproj -scheme AccessLecture build test -test-sdk iphonesimulator
