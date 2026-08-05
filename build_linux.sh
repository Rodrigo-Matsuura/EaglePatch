#!/bin/bash
set -e

# Clean old dist directory and root binaries
rm -rf dist
rm -f "EaglePatchAC1.asi" "EaglePatchAC2.asi"

echo "Creating release directory structure..."
mkdir -p "dist/EaglePatch+AC1/scripts"
mkdir -p "dist/EaglePatch+AC2/scripts"

# Locate Wine include and library directories
WINE_INC_MSVCRT=""
WINE_INC_WIN=""
for dir in /usr/include/wine /usr/include/wine-development; do
    if [ -d "$dir/msvcrt" ]; then
        WINE_INC_MSVCRT="$dir/msvcrt"
        WINE_INC_WIN="$dir/windows"
        break
    fi
done

WINE_LIB_DIR=""
for dir in /usr/lib/wine/i386-windows /usr/lib/wine-development/i386-windows /usr/lib/i386-linux-gnu/wine /usr/lib/wine; do
    if [ -f "$dir/libwinecrt0.a" ]; then
        WINE_LIB_DIR="$dir"
        break
    fi
done

if [ -z "$WINE_LIB_DIR" ] || [ -z "$WINE_INC_MSVCRT" ]; then
    echo "Error: Wine 32-bit development libraries (libwinecrt0.a) or headers not found."
    echo "Please ensure wine-development or libwine-dev:i386 is installed."
    exit 1
fi

echo "Using Wine headers: $WINE_INC_MSVCRT"
echo "Using Wine libraries: $WINE_LIB_DIR"

echo "Building EaglePatchAC1.asi..."
clang -shared -O2 -target i686-pc-windows-msvc -fuse-ld=lld -nostdlib \
    -Wl,-entry:DllMainCRTStartup@12 -Wl,-safeseh:no \
    -isystem "$WINE_INC_MSVCRT" -isystem "$WINE_INC_WIN" \
    -Ipatcher \
    -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_USE_32BIT_TIME_T -DNOMINMAX -D_MBCS \
    -DDLL_NAME=\"EaglePatchAC1\" \
    -fms-extensions -fms-compatibility -fmsc-version=1900 \
    -o "dist/EaglePatch+AC1/scripts/EaglePatchAC1.asi" \
    patcher/crt_sections.cpp \
    patcher/patcher.cpp \
    EaglePatch/shared/console.cpp \
    EaglePatch/shared/ini_reader.cpp \
    EaglePatch/shared/utils.cpp \
    EaglePatch/src/ac1.cpp \
    "$WINE_LIB_DIR/libwinecrt0.a" \
    "$WINE_LIB_DIR/libmsvcrt.a" \
    "$WINE_LIB_DIR/libkernel32.a"

echo "Packaging EaglePatch+AC1..."
cp "EaglePatch/EaglePatchAC1.ini" "dist/EaglePatch+AC1/scripts/"
cp "EaglePatch/Readme - EaglePatch+AC1.txt" "dist/EaglePatch+AC1/"

echo "Building EaglePatchAC2.asi..."
clang -shared -O2 -target i686-pc-windows-msvc -fuse-ld=lld -nostdlib \
    -Wl,-entry:DllMainCRTStartup@12 -Wl,-safeseh:no \
    -isystem "$WINE_INC_MSVCRT" -isystem "$WINE_INC_WIN" \
    -Ipatcher \
    -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_USE_32BIT_TIME_T -DNOMINMAX -D_MBCS \
    -DDLL_NAME=\"EaglePatchAC2\" \
    -fms-extensions -fms-compatibility -fmsc-version=1900 \
    -o "dist/EaglePatch+AC2/scripts/EaglePatchAC2.asi" \
    patcher/crt_sections.cpp \
    patcher/patcher.cpp \
    EaglePatch/shared/console.cpp \
    EaglePatch/shared/ini_reader.cpp \
    EaglePatch/shared/utils.cpp \
    EaglePatch/src/ac2.cpp \
    "$WINE_LIB_DIR/libwinecrt0.a" \
    "$WINE_LIB_DIR/libmsvcrt.a" \
    "$WINE_LIB_DIR/libkernel32.a"

echo "Packaging EaglePatch+AC2..."
cp "EaglePatch/EaglePatchAC2.ini" "dist/EaglePatch+AC2/scripts/"
cp "EaglePatch/Readme - EaglePatch+AC2.txt" "dist/EaglePatch+AC2/"

# Clean up temporary linker export files
rm -f "dist/EaglePatch+AC1/scripts/EaglePatchAC1.lib" "dist/EaglePatch+AC2/scripts/EaglePatchAC2.lib" test.lib

echo "Creating release zip archives..."
python3 -c "import shutil; shutil.make_archive('dist/EaglePatch+AC1', 'zip', 'dist/EaglePatch+AC1'); shutil.make_archive('dist/EaglePatch+AC2', 'zip', 'dist/EaglePatch+AC2')"

echo "Build successful! Release archives packaged in dist/EaglePatch+AC1.zip and dist/EaglePatch+AC2.zip"
