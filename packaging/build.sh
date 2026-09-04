#!/bin/bash
set -e

VERSION=${1:-"1.0.0"}
PACKAGE_NAME="somasave-client"
BUILD_DIR="build/deb"
DEB_ROOT="$BUILD_DIR/${PACKAGE_NAME}_${VERSION}"

echo "=== Building $PACKAGE_NAME .deb v${VERSION} ==="

rm -rf "$DEB_ROOT"
mkdir -p "$DEB_ROOT/DEBIAN"
mkdir -p "$DEB_ROOT/usr/bin"
mkdir -p "$DEB_ROOT/etc/somasave-client"

# Control files
cp packaging/debian/control      "$DEB_ROOT/DEBIAN/control"
cp packaging/debian/postinst     "$DEB_ROOT/DEBIAN/postinst"
cp packaging/debian/prerm        "$DEB_ROOT/DEBIAN/prerm"
cp packaging/debian/conffiles    "$DEB_ROOT/DEBIAN/conffiles"
cp packaging/debian/config       "$DEB_ROOT/DEBIAN/config"
cp packaging/debian/templates    "$DEB_ROOT/DEBIAN/templates"

sed -i "s/^Version:.*/Version: ${VERSION}/" "$DEB_ROOT/DEBIAN/control"

chmod 755 "$DEB_ROOT/DEBIAN/postinst"
chmod 755 "$DEB_ROOT/DEBIAN/prerm"
chmod 755 "$DEB_ROOT/DEBIAN/config"

# CLI tool
cp packaging/debian/files/usr/bin/somasave "$DEB_ROOT/usr/bin/somasave"
chmod 755 "$DEB_ROOT/usr/bin/somasave"

# Build
mkdir -p "$BUILD_DIR"
dpkg-deb --build --root-owner-group "$DEB_ROOT" "$BUILD_DIR/${PACKAGE_NAME}_${VERSION}.deb"

echo ""
echo "=== Built: $BUILD_DIR/${PACKAGE_NAME}_${VERSION}.deb ==="