#!/bin/bash
set -e

echo "--------------------------------------"
echo "🚀 Starting Chiya Town Build Script"
echo "--------------------------------------"

# 1. Install Flutter if not present
if [ ! -d "_flutter" ]; then
    echo "📦 Flutter not found. Cloning stable channel..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter
else
    echo "✅ Flutter already installed."
fi

# 2. Add to PATH
export PATH="$PATH:$(pwd)/_flutter/bin"

# 3. Print Version
echo "ℹ️  Flutter Version:"
flutter --version

# 4. Install Dependencies
echo "⬇️  Installing Dependencies..."
flutter pub get

# 5. Build Web App
# --web-renderer html: Fixes white screen on some Vercel deployments (CanvasKit issues)
echo "MZ  Building Web App..."
flutter build web --release --web-renderer html --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"

echo "✅ Build Complete!"
