#!/bin/bash
set -e

# Clean old dist directory and root binaries
rm -rf dist
rm -f EaglePatchAC1.asi EaglePatchAC2.asi

echo "Creating release directory structure..."
mkdir -p dist/EaglePatchAC1/scripts
mkdir -p dist/EaglePatchAC2/scripts

echo "Building EaglePatchAC1.asi..."
clang -shared -O2 -target i686-pc-windows-msvc -fuse-ld=lld -nostdlib \
    -Wl,-entry:DllMainCRTStartup@12 -Wl,-safeseh:no \
    -isystem /usr/include/wine/msvcrt -isystem /usr/include/wine/windows \
    -Ipatcher \
    -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_USE_32BIT_TIME_T -DNOMINMAX -D_MBCS \
    -DDLL_NAME=\"EaglePatchAC1\" \
    -fms-extensions -fms-compatibility -fmsc-version=1900 \
    -o dist/EaglePatchAC1/scripts/EaglePatchAC1.asi \
    patcher/crt_sections.cpp \
    patcher/patcher.cpp \
    EaglePatch/shared/console.cpp \
    EaglePatch/shared/ini_reader.cpp \
    EaglePatch/src/ac1.cpp \
    /usr/lib/wine/i386-windows/libwinecrt0.a \
    /usr/lib/wine/i386-windows/libmsvcrt.a \
    /usr/lib/wine/i386-windows/libkernel32.a

echo "Packaging EaglePatchAC1..."
cp EaglePatch/EaglePatchAC1.ini dist/EaglePatchAC1/scripts/
cp "EaglePatch/Readme - EaglePatchAC1.txt" dist/EaglePatchAC1/

echo "Building EaglePatchAC2.asi..."
clang -shared -O2 -target i686-pc-windows-msvc -fuse-ld=lld -nostdlib \
    -Wl,-entry:DllMainCRTStartup@12 -Wl,-safeseh:no \
    -isystem /usr/include/wine/msvcrt -isystem /usr/include/wine/windows \
    -Ipatcher \
    -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_USE_32BIT_TIME_T -DNOMINMAX -D_MBCS \
    -DDLL_NAME=\"EaglePatchAC2\" \
    -fms-extensions -fms-compatibility -fmsc-version=1900 \
    -o dist/EaglePatchAC2/scripts/EaglePatchAC2.asi \
    patcher/crt_sections.cpp \
    patcher/patcher.cpp \
    EaglePatch/shared/console.cpp \
    EaglePatch/shared/ini_reader.cpp \
    EaglePatch/src/ac2.cpp \
    /usr/lib/wine/i386-windows/libwinecrt0.a \
    /usr/lib/wine/i386-windows/libmsvcrt.a \
    /usr/lib/wine/i386-windows/libkernel32.a

echo "Packaging EaglePatchAC2..."
cp EaglePatch/EaglePatchAC2.ini dist/EaglePatchAC2/scripts/
cp "EaglePatch/Readme - EaglePatchAC2.txt" dist/EaglePatchAC2/

# Clean up temporary linker export files
rm -f dist/EaglePatchAC1/scripts/EaglePatchAC1.lib dist/EaglePatchAC2/scripts/EaglePatchAC2.lib test.lib

echo "Build successful! Releases packaged in dist/ directory."
