#!/bin/sh
set -e

git clone https://github.com/facebook/xctool.git "xctool";
cd xctool;
git checkout 3677d7afad379366b571a3f634749c0fdad78368;
cd ../;
sh ./xctool/build.sh;
export xctoolpath='./xctool/build/3677d7a/Products/Release/xctool';
