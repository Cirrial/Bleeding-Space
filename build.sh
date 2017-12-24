#!/usr/bin/env bash
set -x

P="bleedingspace"
LV="0.10.2" # love version
LZ="https://bitbucket.org/rude/love/downloads/love-${LV}-win32.zip"

### clean
if [ "$1" == "clean" ]; then
 rm -rf "target"
 exit;
fi

##### build #####
find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }
mkdir "target"

### .love
cp -r src target	
cd target/src

# compile .ink story into lua table so the runtime will not need lpeg dep.
lua lib/pink/pink/pink.lua parse game.ink > game.lua

# .love file
zip -9 -r - . > "../${P}.love"
cd -

### .exe
if [ ! -f "target/love-win.zip" ]; then wget "$LZ" -O "target/love-win.zip"; fi
unzip -o "target/love-win.zip" -d "target"
tmp="target/tmp/"
mkdir -p "$tmp/$P"
cat "target/love-${LV}-win32/love.exe" "target/${P}.love" > "$tmp/${P}/${P}.exe"
cp  target/love-"${LV}"-win32/*dll target/love-"${LV}"-win32/license* "$tmp/$P"
cd "$tmp"
zip -9 -r - "$P" > "${P}-win.zip"
cd -
cp "$tmp/${P}-win.zip" "target/"
rm -r "$tmp"