#!/bin/bash

# iOS Build Script for Flutter InAppWebView App
# This script helps build the iOS app with proper configurations

echo "🚀 Starting iOS build for Flutter InAppWebView app..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Clean iOS build
echo "🧹 Cleaning iOS build..."
cd ios
rm -rf Pods
rm -rf .symlinks
rm -rf Podfile.lock
cd ..

# Install iOS pods
echo "📱 Installing iOS pods..."
cd ios
pod install --repo-update
cd ..

# Build for iOS
echo "🔨 Building for iOS..."
flutter build ios --debug

echo "✅ iOS build completed!"
echo ""
echo "📱 To run on device:"
echo "   flutter run -d ios"
echo ""
echo "📱 To run on simulator:"
echo "   flutter run -d ios --simulator"
echo ""
echo "📦 To create IPA:"
echo "   flutter build ipa"
echo ""
echo "🔧 If you encounter issues:"
echo "   1. Delete ios/Pods and ios/Podfile.lock"
echo "   2. Run: cd ios && pod install"
echo "   3. Run: flutter clean && flutter pub get" 