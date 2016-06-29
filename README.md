# Crownstone SDK

The Crownstone SDK exists of three parts (in an increasing order of integration):

:cloud: A [REST API](#rest_api) in the cloud

:iphone: Smartphone [libraries](#smartphone_libs)

:crown: The [firmware](#bluenet) on the Crownstones, called Bluenet

## <a name="rest_api"></a>REST API

The cloud is required to setup the Crownstones: keys and IDs will be generated, and locations can be set.
After that, it can be used to add users, so they can also make use of your Crownstones.
The cloud is also used to synchronize data between users, and serves as data storage.
You can read how to use it in the [REST API documentation](REST_API.md).

![Image of Strongloop API Explorer](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/strongloop-api-explorer.png)

## <a name="smartphone_libs"></a>Smartphone libraries
To make things easy, we provide native libraries for smartphones.

### <a name="bluenet_lib"></a>Bluetooth

![Image of Bluetooth logo](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/bluetooth-smart-logo.png)

This library abstracts the communication with the Crownstones.
Features (some are still in development):

#### <a name="bluenet_lib_commands"></a>Commands

- Switch/dim
- Set time
- Factory reset
- Update over the air
- Enable/disable mesh
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
Configurations that can be set and read. The enable/disable states set by a [command](#bluenet_lib_commands), can be read as well.

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


The libraries can be found on github:

- [Android](https://github.com/crownstone/bluenet-lib-android)
- [iOS](https://github.com/crownstone-bluenet-lib-android)

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

The libraries can be found on github:

- Android (in development)
- iOS (in development)

### Example app

The [Crownstone app](https://github.com/crownstone/CrownstoneApp) (Android and iOS) makes use of these libraries and connects to the REST API as well.
The Crownstone app can be used as starting point to develop your own stand-alone app.
It is written in React Native.

## <a name="bluenet"></a>Bluenet Firmware

The [Bluenet](https://github.com/crownstone/bluenet/) firmware can be downloaded from github. There, you can also find the documentation of the bluetooth protocol (services, characteristics, and advertisements). To build the firmware, a GCC cross-compiler is required.

![Image of development kit](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/dev-board.png)

The development kit (see picture) is convenient if you want to work on the hardware, but not necessary. The bluenet firmware supports over-the-air updates. You can order the dev kit from [crownstone.rocks](http://crownstone.rocks/).

## <a name="roadmap"></a>Roadmap
There are still many functionalities in development. This means that some APIs are not there yet, other APIs still need to be implemented, while others may change. Especially the firmware API is expected to undergo a lot of changes.

### Todo

- Setup phase of Crownstones
- Factory reset
- Implement localization libraries for phone
- Deal with multiple users in same room
- Deal with user leaving a room/building so quickly, it cannot issue command to crownstone.
    - Requires a regular `keep alive` command from the phone.
    - Requires the Crownstones to keep up who or how many users are in the same room as the Crownstone.
- Encryption
- More configuration options
- Accurate power measurements
- Softfuse
- Synchronize state of Crownstones to phone
    - Via advertisements
    - Via mesh

