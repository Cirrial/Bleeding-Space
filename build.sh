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
cp -r $TRAVIS_BUILD_DIR $TRAVIS_BUILD_DIR/target	
cd $TRAVIS_BUILD_DIR/target

###remove things we don't want in the .love
rm .gitignore
rm .travis.yml
rm README.md
rm LICENSE
rm build.sh

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