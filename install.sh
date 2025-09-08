#!/bin/bash

# Grid Unpacker Installer
# Downloads and installs the latest version of Grid Unpacker

set -e

APP_NAME="Grid Unpacker"
REPO="jazonh/Grid-Unpacker-Releases"
LATEST_RELEASE_URL="https://api.github.com/repos/$REPO/releases/latest"
DOWNLOAD_DIR="/tmp/grid-unpacker-install"

echo "🚀 Installing Grid Unpacker..."

# Create download directory
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Get latest release info
echo "📡 Checking for latest version..."
RELEASE_INFO=$(curl -s "$LATEST_RELEASE_URL")
LATEST_VERSION=$(echo "$RELEASE_INFO" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | grep -o '"browser_download_url": "[^"]*\.zip"' | cut -d'"' -f4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "❌ Failed to get download URL"
    exit 1
fi

echo "📦 Downloading $APP_NAME $LATEST_VERSION..."

# Download the app
curl -L -o "$APP_NAME.zip" "$DOWNLOAD_URL"

# Extract the app
echo "📂 Extracting..."
unzip -q "$APP_NAME.zip"

# Move to Applications folder
echo "📱 Installing to Applications folder..."
if [ -d "$APP_NAME.app" ]; then
    # Remove existing version if it exists
    if [ -d "/Applications/$APP_NAME.app" ]; then
        echo "🗑️  Removing existing version..."
        rm -rf "/Applications/$APP_NAME.app"
    fi
    
    # Move new version
    mv "$APP_NAME.app" "/Applications/"
    
    echo "✅ $APP_NAME $LATEST_VERSION installed successfully!"
    echo ""
    echo "🎉 Installation complete!"
    echo "   You can find $APP_NAME in your Applications folder."
    echo "   On first launch, you may need to right-click and select \"Open\""
    echo "   to bypass macOS security restrictions."
    echo ""
    echo "🔄 The app will automatically check for updates."
    
else
    echo "❌ Failed to extract the application"
    exit 1
fi

# Cleanup
cd /
rm -rf "$DOWNLOAD_DIR"

echo "✨ Done!"
