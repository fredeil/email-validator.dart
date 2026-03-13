#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )

cd "$DIR"

echo "Installing dependencies..."
dart pub get

echo "Checking formatting..."
dart format --output=none --set-exit-if-changed .

echo "Analyzing for warnings and type errors..."
dart analyze --fatal-infos

echo "Running tests..."
dart test

echo -e "\n\033[32m✓ OK\033[0m"
