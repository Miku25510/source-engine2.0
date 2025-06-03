#!/bin/bash
set -e  # หยุด script ถ้ามี error

# เข้า soruce-engine2.0
cd source-engine2.0

# ตรวจสอบโฟลเดอร์ก่อน clone
if [ -d "srceng-mod-launcher" ]; then
  echo "📁 Folder 'srceng-mod-launcher' already exists. Skipping git clone."
else
  echo "🔧 Cloning srceng-mod-launcher..."
  git clone https://github.com/ItzVladik/srceng-mod-launcher
fi

echo "📦 Checking and installing required packages..."

install_if_missing() {
  PACKAGE=$1
  if dpkg -s "$PACKAGE" &> /dev/null; then
    echo "✅ $PACKAGE is already installed."
  else
    echo "📥 Installing $PACKAGE..."
    sudo apt-get install -y "$PACKAGE"
  fi
}

# อัปเดตรายการแพ็กเกจก่อนเริ่ม
sudo apt-get update

# ตรวจสอบและติดตั้งเฉพาะที่ยังไม่มี
install_if_missing openjdk-17-jdk
install_if_missing zip
install_if_missing apksigner
install_if_missing imagemagick
install_if_missing lib32z1

echo "🛠 Building for Android 32-bit (ARMv7a)..."
bash scripts/build-android-armv7a.sh

echo "🛠 Building for Android 64-bit (AArch64)..."
chmod +x scripts/build-android-aarch64.sh
bash scripts/build-android-aarch64.sh

echo "✅ Build complete."
