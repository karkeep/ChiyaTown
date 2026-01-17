#!/bin/bash
set -e

echo "--------------------------------------"
echo "🚀 Starting Chiya Town Build Script"
echo "--------------------------------------"

# Fix Git ownership issues on Vercel
git config --global --add safe.directory '*'

# 1. Install Flutter 3.22.0 (stable version with --web-renderer support)
FLUTTER_VERSION="3.22.0"

# Force fresh Flutter installation every time to avoid cache issues
if [ -d "_flutter" ]; then
    echo "🗑️  Removing cached Flutter..."
    rm -rf _flutter
fi

echo "📦 Downloading Flutter ${FLUTTER_VERSION}..."
curl -LO "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
mv flutter _flutter
rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

# 2. Add to PATH
export PATH="$PATH:$(pwd)/_flutter/bin"

# 3. Disable analytics
flutter config --no-analytics
export FLUTTER_SUPPRESS_ANALYTICS=true
export PUB_CACHE="$(pwd)/.pub-cache"

# 4. Print Version
echo "ℹ️  Flutter Version:"
flutter --version

# 5. Clean previous build
echo "🧹 Cleaning previous build..."
flutter clean

# 6. Install Dependencies
echo "⬇️  Installing Dependencies..."
flutter pub get

# 7. Build Web App with HTML renderer
echo "🔨 Building Web App..."
flutter build web --release --web-renderer html

echo "✅ Build Complete!"
echo "📁 Output: build/web"
ls -la build/web/
