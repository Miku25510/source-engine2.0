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

# ✅ ติดตั้ง packages พื้นฐาน
install_if_missing openjdk-17-jdk
install_if_missing zip
install_if_missing apksigner
install_if_missing imagemagick
install_if_missing lib32z1
install_if_missing lib32stdc++6
install_if_missing libc6-i386
install_if_missing libncurses5:i386
install_if_missing libstdc++6:i386
install_if_missing python3
install_if_missing python3-pip
install_if_missing git
install_if_missing curl
install_if_missing unzip

# ✅ เริ่ม build
echo "🛠 Building for Android 32-bit (ARMv7a)..."
bash scripts/build-android-armv7a.sh

echo "🛠 Building for Android 64-bit (AArch64)..."
chmod +x scripts/build-android-aarch64.sh
bash scripts/build-android-aarch64.sh

# ✅ คัดลอกไฟล์ที่ build เสร็จแล้วไปไว้ที่ ~/Downloads
echo "📁 Copying built libraries to ~/Downloads..."
mkdir -p ~/Downloads
cp -r srceng-mod-launcher/android/lib/armeabi-v7a ~/Downloads/
cp -r srceng-mod-launcher/android/lib/arm64-v8a ~/Downloads/

echo "✅ Build complete and files copied to Downloads."
