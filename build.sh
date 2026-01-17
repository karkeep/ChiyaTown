#!/bin/bash
set -e

echo "--------------------------------------"
echo "🚀 Starting Chiya Town Build Script"
echo "--------------------------------------"

# 1. Install/Update Flutter to 3.24.0
if [ ! -d "_flutter" ]; then
    echo "📦 Flutter not found. Installing 3.24.0..."
    git clone https://github.com/flutter/flutter.git _flutter
else
    echo "✅ Flutter folder exists. Switching to 3.24.0..."
fi

# Force the correct version
cd _flutter
git fetch --tags
git checkout 3.24.0
cd ..

# 2. Add to PATH
export PATH="$PATH:$(pwd)/_flutter/bin"

# 3. Print Version
echo "ℹ️  Flutter Version:"
flutter --version

# 4. Install Dependencies
echo "⬇️  Installing Dependencies..."
flutter pub get

# 5. Build Web App
# Using 3.24.0 allows us to use --web-renderer html safely
echo "MZ  Building Web App..."
flutter build web --release --web-renderer html --no-tree-shake-icons --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"

echo "✅ Build Complete!"
