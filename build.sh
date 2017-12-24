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
rm -rf "target"
mkdir "target"

### .love
rsync -Rr ./ ./target/ # fuk cp it doesn't work
cd target

### remove things we don't want in the .love
rmdir target
rm -rf ".git"
rm .gitignore
rm .travis.yml
rm README.md
rm LICENSE
rm build.sh

### remove certain files, they don't need to be in the thing
find . \( -name "*.ase" -or -name "*.love" \) -type f -delete

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