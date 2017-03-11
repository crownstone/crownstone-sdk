#!/bin/bash

ORANGE="\033[38;5;214m"
GREEN="\033[38;5;46m"
RED="\033[38;5;196m"

## Collect packages to install and URL to download from 

CROWNSTONE_SDK_TOOLS=https://github.com/crownstone/crownstone-sdk/releases/download/tools-0.0.1

# Original website:
# NORDIC_URL=https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v11.x.x/$NORDIC_SDK
NORDIC_SDK=nRF5_SDK_11.0.0_89a8197.zip
NORDIC_URL=$CROWNSTONE_SDK_TOOLS/$NORDIC_SDK

# See for overview https://www.segger.com/downloads/jlink
JLINK32=JLink_Linux_V610l_i386.deb
JLINK64=JLink_Linux_V610l_x86_64.deb
JLINK32_URL=https://www.segger.com/downloads/jlink/$JLINK32
JLINK64_URL=https://www.segger.com/downloads/jlink/$JLINK64

# Original website:
# GCC_URL=https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q2-update/+download/$GCC
# Now at https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads
GCC=gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2
GCC_URL=$CROWNSTONE_SDK_TOOLS/$GCC

# Print function:
#   @param string
#   @param colour (optional)
#   @param --no-newline (optional)
function print {
  args=""
  if [ "$3" == "--no-newline" ]; then
    args="-n"
  fi
  if [ -z $2 ]; then
    echo $args -e $1
  else
    COLOR_RESET="\033[39m"
    echo $args -e $2$1$COLOR_RESET
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

print "> Install script/build dependencies with apt-get such as unzip, git and cmake [Y/n]: " $ORANGE --no-newline

read response

if [ "$response" == "n" ] || [ "$response" == "N" ]; then
  print "Skip installing script dependencies" $RED
else
  sudo apt-get install unzip git cmake -y

  if [[ $? -ne 0 ]]; then
    print "Failed to install script dependencies" $RED
    exit 1
  fi
  print "> OK" $GREEN
fi

print "> Where do you want to install the software (e.g. ~/workspace): " $ORANGE --no-newline

read response

if [ "$response" == "" ]; then
	print "> Using current directory" $ORANGE
else
	# perform tilde expansion
	response=$(eval echo "$response")
	if [ -d "$response" ]; then
		cd $response
	else
		print "This is not a directory, exit." $RED
		exit 1
	fi
	print "> Using directory $response as workspace"
fi

print "> Creating directories ..." $ORANGE

mkdir -p bluenet-workspace
cd bluenet-workspace

mkdir -p config
mkdir -p nordic/v11/
mkdir -p tools/compiler

mkdir -p downloads

print "> OK" $GREEN

print "> Getting Nordic SDK" $ORANGE

cd downloads
wget $NORDIC_URL

if [[ $? -ne 0 ]]; then
  print "Failed to get Nordic SDK" $RED
  exit 1
fi

print ">> Extracting Nordic SDK" $ORANGE

unzip $NORDIC_SDK -d ../nordic/v11

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

cd downloads

if $arch64; then
  echo "wget --post-data \"accept_license_agreement=accepted\" $JLINK64_URL"
  wget --post-data "accept_license_agreement=accepted" $JLINK64_URL
else
  wget --post-data "accept_license_agreement=accepted" $JLINK32_URL
fi

if [[ $? -ne 0 ]]; then
  print "Failed to get JLink" $RED
  exit 1
fi

print "> OK" $GREEN

print ">> Install JLink [Y/n]: " $ORANGE --no-newline
read response

if [ "$response" == "n" ] || [ "$response" == "N" ]; then
  print "Skip installing JLink" $RED
else
  if $arch64; then
    sudo dpkg -i $JLINK64
  else
    sudo dpkg -i $JLINK32
  fi

  if [[ $? -ne 0 ]]; then
    print "Failed to install JLink" $RED
    exit 1
  fi
  print ">> OK" $GREEN
fi

cd ..

print "> Getting compiler" $ORANGE

cd downloads
wget $GCC_URL

if [[ $? -ne 0 ]]; then
  print "Failed to get compiler" $RED
  exit 1
fi

print "> OK" $GREEN

print ">> Installing compiler" $ORANGE

tar -xjvf $GCC -C ../tools/compiler/

if [[ $? -ne 0 ]]; then
  print "Failed to extract compiler" $RED
  exit 1
fi

print ">> OK" $GREEN

print ">> Install compiler dependencies (Y/n): " $ORANGE --no-newline
read response

if [ "$response" == "n" ] || [ "$response" == "N" ]; then
  print "Skip installing JLink" $RED
else
  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo apt-get install libstdc++6:i386 libncurses5:i386 -y

  if [[ $? -ne 0 ]]; then
    print "Failed to install compiler dependencies" $RED
    exit 1
  fi
  print ">> OK" $GREEN
fi

cd ..


print "> Getting bluenet" $ORANGE

git clone https://github.com/crownstone/bluenet

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

print ">> Setup bluenet" $ORANGE

cp $PWD/bluenet/conf/cmake/env.config.template $PWD/bluenet/env.config
echo "" >> $PWD/bluenet/env.config
echo "BLUENET_WORKSPACE_DIR=$PWD" >> $PWD/bluenet/env.config
echo "source $PWD/bluenet/scripts/env.sh" >> ~/.bashrc

#echo "export BLUENET_WORKSPACE_DIR=$PWD" >> ~/.bashrc
#echo "export BLUENET_DIR=$PWD/bluenet" >> ~/.bashrc
#echo "export BLUENET_CONFIG_DIR=$PWD/config" >> ~/.bashrc

cp $PWD/bluenet/conf/cmake/CMakeBuild.config.template $PWD/config/CMakeBuild.config

echo "" >> $PWD/config/CMakeBuild.config
echo "COMPILER_PATH=$PWD/tools/compiler/gcc-arm-none-eabi-5_4-2016q2" >> $PWD/config/CMakeBuild.config
echo "NRF51822_DIR=$PWD/nordic/v11" >> $PWD/config/CMakeBuild.config

print "Please fill in the missing variables in the CMakeBuild.config (should be opened automatically in a gedit window). The script will complete once the window is closed."

xdg-open $PWD/config/CMakeBuild.config

print ">> OK" $GREEN

print "> Clean up" $ORANGE

print ">> Remove downloaded files (Y/n): " $ORANGE --no-newline
read response

if [ "$response" == "n" ] || [ "$response" == "N" ]; then
  print "Skip deleting downloads" $GREEN
else
  rm -r downloads
fi

print "**************************************************************************" $GREEN
print "***************************** DONE ***************************************" $GREEN
print "**************************************************************************" $GREEN
print "To compile and upload the bluenet code first execute" $GREEN
print "  source ~/.bashrc" $GREEN
print "then go to $PWD/bluenet/scripts and run" $GREEN
print "  ./firmware.sh run"  $GREEN
