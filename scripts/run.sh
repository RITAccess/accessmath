#!/bin/sh
set -e

function clean_up {
	rm -rf ./xctool
}

trap clean_up 0 1 2 15

$xctoolpath -project AccessLecture.xcodeproj -scheme AccessLecture build test -test-sdk iphonesimulator


