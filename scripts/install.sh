#!/bin/bash

ORANGE="\033[38;5;214m"
GREEN="\033[38;5;46m"
RED="\033[38;5;196m"

# print function, first parameter is the string, second parameter the colour.
# colour is optional
function print {
    if [ -z $2 ]; then
        echo -e $1
    else
        COLOR_RESET="\033[39m"
        echo -e $2$1$COLOR_RESET
    fi
}

print "> Checking architecture" $ORANGE

if [[ $(uname -m) == "x86_64" ]]; then
  print "64-bit" $GREEN
  arch64=true
elif [[ $(uname -m) == "i686" ]]; then
  print "32-bit" $GREEN
  arch64=false
else
  print "unknown arch" $RED
  exit 1
fi

print "> Installing script dependencies" $ORANGE

sudo apt-get install unzip git cmake -y

if [[ $? -ne 0 ]]; then
  print "Failed to install script dependencies" $RED
  exit 1
fi

print "> OK" $GREEN

print "> Creating directories ..." $ORANGE

mkdir -p bluenet-workspace
cd bluenet-workspace

mkdir -p config
mkdir -p nordic/v11/
mkdir -p tools/compiler

mkdir -p tmp

print "> OK" $GREEN

print "> Getting Nordic SDK" $ORANGE

cd tmp
wget https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v11.x.x/nRF5_SDK_11.0.0_89a8197.zip

if [[ $? -ne 0 ]]; then
  print "Failed to get Nordic SDK" $RED
  exit 1
fi

print ">> Extracting Nordic SDK" $ORANGE

unzip nRF5_SDK_11.0.0_89a8197.zip -d ../nordic/v11

if [[ $? -ne 0 ]]; then
  print "Failed to extract Noridc SDK" $RED
  exit 1
fi

print ">> OK" $GREEN

print ">> Applying Nordic Fix" $ORANGE

cd ../nordic/v11/
perl -p -i -e 's/#define GCC_CAST_CPP \(uint8_t\)/#define GCC_CAST_CPP \(uint16_t\)/g' `grep -ril "#define GCC_CAST_CPP (uint8_t)" *`

if [[ $? -ne 0 ]]; then
  print "Failed to apply Nordic Fix" $RED
  exit 1
fi

cd ../..

print ">> OK" $GREEN

print "> Getting JLink" $ORANGE

cd tmp
#curl -d accept_license_agreement=accepted https://www.segger.com/downloads/jlink/jlink_5.12.8_x86_64.deb -o jlink_5.12.8_x86_64.deb

if $arch64; then
  wget --post-data "accept_license_agreement=accepted" https://www.segger.com/downloads/jlink/jlink_5.12.8_x86_64.deb
else
  wget --post-data "accept_license_agreement=accepted" https://www.segger.com/downloads/jlink/jlink_5.12.8_i386.deb
fi

if [[ $? -ne 0 ]]; then
  print "Failed to get JLink" $RED
  exit 1
fi

print "> OK" $GREEN

print ">> Installing JLink" $ORANGE

if $arch64; then
  sudo dpkg -i jlink_5.12.8_x86_64.deb
else
  sudo dpkg -i jlink_5.12.8_i386.deb
fi

if [[ $? -ne 0 ]]; then
  print "Failed to install JLink" $RED
  exit 1
fi

cd ..

print ">> OK" $GREEN

print "> Getting compiler" $ORANGE

cd tmp
wget https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q2-update/+download/gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2

if [[ $? -ne 0 ]]; then
  print "Failed to get compiler" $RED
  exit 1
fi

print "> OK" $GREEN

print ">> Installing compiler" $ORANGE

tar -xjvf gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2 -C ../tools/compiler/

if [[ $? -ne 0 ]]; then
  print "Failed to extract compiler" $RED
  exit 1
fi

print ">> OK" $GREEN

print ">> Installing compiler dependencies" $ORANGE

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libstdc++6:i386 libncurses5:i386 -y

if [[ $? -ne 0 ]]; then
  print "Failed to install compiler dependencies" $RED
  exit 1
fi

cd ..

print ">> OK" $GREEN

print "> Getting bluenet" $ORANGE

git clone https://github.com/crownstone/bluenet --branch sdk_11

if [[ $? -ne 0 ]]; then
  print "Failed to clone into bluenet" $RED
  exit 1
fi

print "> OK" $GREEN

print ">> Getting bluenet bootloader" $ORANGE

git clone https://github.com/crownstone/bluenet-bootloader

if [[ $? -ne 0 ]]; then
  print "Failed to clone into bluenet" $RED
  exit 1
fi

print ">> OK" $GREEN

print ">> Installing bluenet" $ORANGE

echo "export BLUENET_WORKSPACE_DIR=$PWD" >> ~/.bashrc
#echo "export BLUENET_DIR=$PWD/bluenet" >> ~/.bashrc
#echo "export BLUENET_CONFIG_DIR=$PWD/config" >> ~/.bashrc

cp $PWD/bluenet/CMakeBuild.config.template $PWD/config/CMakeBuild.config

echo "" >> $PWD/config/CMakeBuild.config
echo "COMPILER_PATH=$PWD/tools/compiler/gcc-arm-none-eabi-5_4-2016q2" >> $PWD/config/CMakeBuild.config
echo "NRF51822_DIR=$PWD/nordic/v11" >> $PWD/config/CMakeBuild.config

print "Please fill in the missing variables in the CMakeBuild.config (should be opened automatically in a gedit window). The script will complete once the window is closed."

gedit $PWD/config/CMakeBuild.config

print ">> OK" $GREEN

print "> Clean up" $ORANGE

rm -r tmp

print "**************************************************************************" $GREEN
print "***************************** DONE ***************************************" $GREEN
print "**************************************************************************" $GREEN
print "To compile and upload the bluenet code first execute" $GREEN
print "  source ~/.bashrc" $GREEN
print "then go to $PWD/bluenet/scripts and run" $GREEN
print "  ./firmware.sh run"  $GREEN
