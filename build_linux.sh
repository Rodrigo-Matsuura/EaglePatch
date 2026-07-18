#!/bin/bash
set -e

echo "Building EaglePatchAC1.asi..."
clang -shared -O2 -target i686-pc-windows-msvc -fuse-ld=lld -nostdlib \
    -Wl,-entry:DllMainCRTStartup@12 -Wl,-safeseh:no \
    -isystem /usr/include/wine/msvcrt -isystem /usr/include/wine/windows \
    -Ipatcher \
    -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_USE_32BIT_TIME_T -DNOMINMAX -D_MBCS \
    -DDLL_NAME=\"EaglePatchAC1\" \
    -fms-extensions -fms-compatibility -fmsc-version=1900 \
    -o EaglePatchAC1.asi \
    patcher/crt_sections.cpp \
    patcher/patcher.cpp \
    EaglePatch/shared/console.cpp \
    EaglePatch/shared/ini_reader.cpp \
    EaglePatch/src/ac1.cpp \
    /usr/lib/wine/i386-windows/libwinecrt0.a \
    /usr/lib/wine/i386-windows/libmsvcrt.a \
    /usr/lib/wine/i386-windows/libkernel32.a

echo "Building EaglePatchAC2.asi..."
clang -shared -O2 -target i686-pc-windows-msvc -fuse-ld=lld -nostdlib \
    -Wl,-entry:DllMainCRTStartup@12 -Wl,-safeseh:no \
    -isystem /usr/include/wine/msvcrt -isystem /usr/include/wine/windows \
    -Ipatcher \
    -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_USE_32BIT_TIME_T -DNOMINMAX -D_MBCS \
    -DDLL_NAME=\"EaglePatchAC2\" \
    -fms-extensions -fms-compatibility -fmsc-version=1900 \
    -o EaglePatchAC2.asi \
    patcher/crt_sections.cpp \
    patcher/patcher.cpp \
    EaglePatch/shared/console.cpp \
    EaglePatch/shared/ini_reader.cpp \
    EaglePatch/src/ac2.cpp \
    /usr/lib/wine/i386-windows/libwinecrt0.a \
    /usr/lib/wine/i386-windows/libmsvcrt.a \
    /usr/lib/wine/i386-windows/libkernel32.a

# Clean up temporary linker export files
rm -f EaglePatchAC1.lib EaglePatchAC2.lib test.lib

echo "Build successful! Created EaglePatchAC1.asi and EaglePatchAC2.asi."
