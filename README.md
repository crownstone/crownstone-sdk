# Crownstone SDK

The Crownstone SDK exists of three parts (in an increasing order of integration):

:cloud: A [REST API](#rest_api) in the cloud

:iphone: Smartphone [libraries](#smartphone_libs)

:crown: The [firmware](#bluenet) on the Crownstones, called Bluenet

### <a name="bluenet_lib"></a>Bluetooth

![Image of Bluetooth logo](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/bluetooth-logo.png)

## <a name="rest_api"></a>REST API

The cloud is required to setup the Crownstones: keys and IDs will be generated, and locations can be set.
After that, it can be used to add users, so they can also make use of your Crownstones.
The cloud is also used to synchronize data between users, and serves as data storage.
You can read how to use it in the [REST API documentation](REST_API.md).

![Image of Strongloop API Explorer](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/strongloop-api-explorer.png)

## <a name="smartphone_libs"></a>Smartphone libraries
To make things easy, we provide native libraries for smartphones. The following libraries are available and can be found on github:

- [Android](https://github.com/crownstone/bluenet-lib-android)
- [iOS](https://github.com/crownstone/bluenet-lib-ios)

The libraries abstract the communication with the Crownstones. They simplify scanning/search for crownstones, wrap the messages into easy-to-use objects, and provide simple functions to access the functionalities provided on the Crownstones. 

The following features will be available (some are still in development):

#### <a name="bluenet_lib_commands"></a>Commands

- Switch/dim
- Set time
- Factory reset
- Update over the air
- Enable/disable iBeacon
- Enable/disable encryption
- Enable/disable mesh
- Enable/disable continous scanning
- Enable/disable continous high frequency power sampling

#### Notified data
This data streams in regularly via a callback.

- Switch state (0-100)
- Power usage (mW)
- Total energy usage (Wh)
- Chip temperature (°C)

#### <a name="bluenet_lib_configs"></a>Get/set configurations:
Configurations that can be set and read. 

Note: The enable/disable states can only be set using the corresponding [command](#bluenet_lib_commands) but they can be read through the config.

- Encryption keys
- ID
- iBeacon UUID, major, minor, RSSI at 1m
- TX power
- Advertisement interval
- Schedule (switch on/off at certain times)
- Toggle switch after Crownstone reboot.
- Continous scanning interval, duration and filter

#### Mesh commands
Commands that can be issued to other Crownstones via the mesh. In case a command asks for a return value, the value will be notified via a callback.

- Switch
- Get state (switch state, power usage, energy usage, temperature)
- Get [config](#bluenet_lib_configs)
- Set [config](#bluenet_lib_configs)
- Enable/disable scanning or high frequency power sampling


### Indoor localization

![Image of Indoor Localization](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/indoor-localization.png)

This library abstracts and implements the localization, it uses the [bluetooth library](#bluenet_lib) and [REST API](#rest_api). The localization is based on rooms, though it is more a certain area. This means you can define multiple rooms in a single real world room.

Features (in development):

- Create room
- Remove room
- Start/stop learning room
- Set room fingerprint
- Get room fingerprint
- Adapt a fingerprint from the cloud to your phone model
- Get current location (room)
- Get nearby rooms
- Get distance to room
- Get predicted next room
- Get location (room) of other users

### Example app

![Image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small.png)
![Second image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small1.png)
![Third image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small2.png)
![Fourth image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small3.png)
![Fifth image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small4.png)

The [Crownstone app](https://github.com/crownstone/CrownstoneApp) (Android and iOS) makes use of these libraries and connects to the REST API as well.
The Crownstone app can be used as starting point to develop your own stand-alone app.
It is written in React Native.

## <a name="bluenet"></a>Bluenet Firmware

The [Bluenet](https://github.com/crownstone/bluenet/) firmware can be downloaded from github. For the documentation, see the following links

- [Bluetooth Protocol](https://github.com/crownstone/bluenet/blob/master/docs/PROTOCOL.md)
Protocol description of the services, characteristics, advertisements, and mesh.
- [Installation Manual](https://github.com/crownstone/bluenet/blob/master/docs/INSTALL.md) 
A step by step description to install the build system required to build and run the bluenet firmware.
- [License](https://github.com/crownstone/bluenet/blob/master/LICENSE.txt)
License Agreement

## <a name="bootloader"></a>Bootloader

We are using a modified version of the bootloader from the Nordic SDK which can be found [here](https://github.com/crownstone/bluenet-bootloader). 

The bootloader handles starting the firmware, as well as device firmware upload (DFU) over the air. It provides DFU for firmware, softdevice and bootloader. In addition, the bootloader also provides some checks to handle unwanted resets, which means it will automatically go into DFU mode when too many subsequent resets are detected.

Note: The bootloader is optional if the Crownstones are programmed over USB. It is only needed to be able to DFU over the air.

## <a name="bluenet_installation"></a>Installation
To simplify installation of the Bluenet build system on linux, an `install.sh` script is provided in this repository which downloads and installs everything required to build the Bluenet firmware. 

Note: By using the script you implicitly accept the terms of the license agreement of the JLink/Segger. For the license agreement, see [here](https://www.segger.com/downloads/jlink/jlink_5.12.8_x86_64.deb).

To use it, simply copy the script to the root location where you want to download the the files, e.g.

    cd ~/Project/Crownstone/
    
Then run the script with

    ./install.sh
    
It will download all necessary dependencies, clone into the Bluenet repository, and set up the config/build system to start programing straight away.

If you prefer to install it manually, you can find a step by step installation manual [here](https://github.com/crownstone/bluenet/blob/master/INSTALL.md).


## Crownstone Hardware

![Image of development kit](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/dev-board.png)

The development kit (see picture) is convenient if you want to work on the hardware, but not necessary. The bluenet firmware supports over-the-air updates. You can order the dev kit from [crownstone.rocks](http://crownstone.rocks/).

## <a name="roadmap"></a>Roadmap
There are still many functionalities in development. This means that some APIs are not there yet, other APIs still need to be implemented, while others may change. 

### Alpha release
The alpha release won't include all features listed above, but mainly acts as a first version with stable API.
It will **not** include:
- Crownstones:
    - Dimming
    - Scanning filter
    - Enable/disable continous high frequency power sampling
    - Getting config over the mesh
- Indoor localization lib:
    - Predicted next room
    - Get nearby rooms
    - Get distance to room

### Beta release
The following list are planned features or updates for the beta release:
- Crownstones:
    - Enable/disable continous high frequency power sampling

### First release candidate
The following list are planned features or updates for the first release candidate:
- Crownstones:
    - Dimming
    - Improved power measurements
    - Improved scanning: filters, report result via notifications
    - Handling multiple user conflicts when they're not connected to the internet
    - Softfuse
- Indoor localization lib:
    - Improve localization
    - Get predicted next room

### Later releases
We still have many features that we want to implement, like:
- Crownstones:
    - Enable Eddystone support
    - Device recognition: use the high frequency power sampling to automatically recognize what device is plugged in the Crownstone

- Indoor localization lib:
    - Automatic discovery of crownstone location: just walking around with your smartphone is enough to calibrate the indoor localization

- Integration with 3rd parties:
    - IFTTT
    - Zapier
    - Philips Hue
    - Homey
    - etc.
