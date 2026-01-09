#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -z "${SUPABASE_URL:-}" ]]; then
  echo "Missing SUPABASE_URL."
  echo "Please run: export SUPABASE_URL=..."
  exit 1
fi

if [[ -z "${SUPABASE_ANON_KEY:-}" ]]; then
  echo "Missing SUPABASE_ANON_KEY."
  echo "Please run: export SUPABASE_ANON_KEY=..."
  exit 1
fi

echo "Running: flutter clean"
flutter clean

echo "Running: flutter pub get"
flutter pub get

echo "Running: flutter run -d macos"
flutter run -d macos \
  "--dart-define=SUPABASE_URL=${SUPABASE_URL}" \
  "--dart-define=SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}"

