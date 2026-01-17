#!/bin/bash
set -e

echo "--------------------------------------"
echo "🚀 Starting Chiya Town Build Script"
echo "--------------------------------------"

# Fix Git ownership issues on Vercel (runs as root with different user ownership)
git config --global --add safe.directory '*'

# 1. Install Flutter 3.22.0 (known stable version with --web-renderer support)
FLUTTER_VERSION="3.22.0"

if [ ! -d "_flutter" ]; then
    echo "📦 Flutter not found. Downloading ${FLUTTER_VERSION}..."
    curl -LO "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
    tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
    mv flutter _flutter
    rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
else
    echo "✅ Flutter already installed."
fi

# 2. Add to PATH
export PATH="$PATH:$(pwd)/_flutter/bin"

# 3. Disable analytics and suppress root warning
flutter config --no-analytics
export FLUTTER_SUPPRESS_ANALYTICS=true
export PUB_CACHE="$(pwd)/.pub-cache"

# 4. Print Version
echo "ℹ️  Flutter Version:"
flutter --version

# 5. Install Dependencies
echo "⬇️  Installing Dependencies..."
flutter pub get

# 6. Build Web App with HTML renderer (avoids CanvasKit issues)
echo "🔨 Building Web App..."
flutter build web --release --web-renderer html

echo "✅ Build Complete!"
echo "📁 Output: build/web"
