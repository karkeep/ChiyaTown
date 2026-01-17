#!/bin/bash

# Add Flutter to PATH (since Vercel installs it in _flutter)
export PATH="$PATH:$(pwd)/_flutter/bin"

# Build the Web App
# --no-wasm-dry-run: Prevents failure due to mobile_scanner not supporting Wasm
# --dart-define: Vercel Environment Variables need to be explicitly passed to Dart
flutter build web --release --no-wasm-dry-run --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
