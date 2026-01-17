#!/bin/bash
set -e

echo "--------------------------------------"
echo "🚀 Starting Chiya Town Build Script"
echo "--------------------------------------"

# 1. Install Flutter (Pinning to 3.24.0 to ensure build stability)
if [ ! -d "_flutter" ]; then
    echo "📦 Flutter not found. Installing 3.24.0..."
    git clone https://github.com/flutter/flutter.git _flutter
    cd _flutter
    git checkout 3.24.0
    cd ..
else
    echo "✅ Flutter folder exists."
    # Optional: Force checkout if you want to ensure version
    # cd _flutter && git checkout 3.24.0 && cd ..
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
# Using 3.24.0 allows us to use --web-renderer html safely
echo "MZ  Building Web App..."
flutter build web --release --web-renderer html --no-tree-shake-icons --dart-define=SUPABASE_URL="$SUPABASE_URL" --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"

echo "✅ Build Complete!"
