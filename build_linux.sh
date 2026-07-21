#!/bin/bash
set -e

# Clean old dist directory and root binaries
rm -rf dist
rm -f "EaglePatch+AC1.asi" "EaglePatch+AC2.asi"

echo "Creating release directory structure..."
mkdir -p "dist/EaglePatch+AC1/scripts"
mkdir -p "dist/EaglePatch+AC2/scripts"

echo "Building EaglePatch+AC1.asi..."
clang -shared -O2 -target i686-pc-windows-msvc -fuse-ld=lld -nostdlib \
    -Wl,-entry:DllMainCRTStartup@12 -Wl,-safeseh:no \
    -isystem /usr/include/wine/msvcrt -isystem /usr/include/wine/windows \
    -Ipatcher \
    -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_USE_32BIT_TIME_T -DNOMINMAX -D_MBCS \
    -DDLL_NAME=\"EaglePatch+AC1\" \
    -fms-extensions -fms-compatibility -fmsc-version=1900 \
    -o "dist/EaglePatch+AC1/scripts/EaglePatch+AC1.asi" \
    patcher/crt_sections.cpp \
    patcher/patcher.cpp \
    EaglePatch/shared/console.cpp \
    EaglePatch/shared/ini_reader.cpp \
    EaglePatch/src/ac1.cpp \
    /usr/lib/wine/i386-windows/libwinecrt0.a \
    /usr/lib/wine/i386-windows/libmsvcrt.a \
    /usr/lib/wine/i386-windows/libkernel32.a

echo "Packaging EaglePatch+AC1..."
cp "EaglePatch/EaglePatch+AC1.ini" "dist/EaglePatch+AC1/scripts/"
cp "EaglePatch/Readme - EaglePatch+AC1.txt" "dist/EaglePatch+AC1/"

echo "Building EaglePatch+AC2.asi..."
clang -shared -O2 -target i686-pc-windows-msvc -fuse-ld=lld -nostdlib \
    -Wl,-entry:DllMainCRTStartup@12 -Wl,-safeseh:no \
    -isystem /usr/include/wine/msvcrt -isystem /usr/include/wine/windows \
    -Ipatcher \
    -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_USE_32BIT_TIME_T -DNOMINMAX -D_MBCS \
    -DDLL_NAME=\"EaglePatch+AC2\" \
    -fms-extensions -fms-compatibility -fmsc-version=1900 \
    -o "dist/EaglePatch+AC2/scripts/EaglePatch+AC2.asi" \
    patcher/crt_sections.cpp \
    patcher/patcher.cpp \
    EaglePatch/shared/console.cpp \
    EaglePatch/shared/ini_reader.cpp \
    EaglePatch/src/ac2.cpp \
    /usr/lib/wine/i386-windows/libwinecrt0.a \
    /usr/lib/wine/i386-windows/libmsvcrt.a \
    /usr/lib/wine/i386-windows/libkernel32.a

echo "Packaging EaglePatch+AC2..."
cp "EaglePatch/EaglePatch+AC2.ini" "dist/EaglePatch+AC2/scripts/"
cp "EaglePatch/Readme - EaglePatch+AC2.txt" "dist/EaglePatch+AC2/"

# Clean up temporary linker export files
rm -f "dist/EaglePatch+AC1/scripts/EaglePatch+AC1.lib" "dist/EaglePatch+AC2/scripts/EaglePatch+AC2.lib" test.lib

echo "Creating release zip archives..."
python3 -c "import shutil; shutil.make_archive('dist/EaglePatch+AC1', 'zip', 'dist/EaglePatch+AC1'); shutil.make_archive('dist/EaglePatch+AC2', 'zip', 'dist/EaglePatch+AC2')"

echo "Build successful! Release archives packaged in dist/EaglePatch+AC1.zip and dist/EaglePatch+AC2.zip"
