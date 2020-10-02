# <a name="smartphone_libs"></a>Smartphone libraries
To make things easy, we provide native libraries for smartphones. The following libraries are available and can be found on github:

- [Android](https://github.com/crownstone/bluenet-lib-android)
- [iOS](https://github.com/crownstone/bluenet-lib-ios)

The libraries abstract the communication with the Crownstones. They simplify scanning/search for crownstones, wrap the messages into easy-to-use objects, and provide simple functions to access the functionalities provided on the Crownstones. 

The following features will be available (some are still in development):

## <a name="bluenet_lib_commands"></a>Commands

- Switch/dim
- Set time
- Factory reset
- Update over the air
- Enable/disable iBeacon
- Enable/disable encryption
- Enable/disable mesh
- Enable/disable continous scanning
- Enable/disable continous high frequency power sampling

## Notified data
This data streams in regularly via a callback.

- Switch state (0-100)
- Power usage (mW)
- Total energy usage (Wh)
- Chip temperature (°C)

## <a name="bluenet_lib_configs"></a>Get/set configurations:

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

## Mesh commands

Commands that can be issued to other Crownstones via the mesh. In case a command asks for a return value, the value will be notified via a callback.

- Switch
- Get state (switch state, power usage, energy usage, temperature)
- Get [config](#bluenet_lib_configs)
- Set [config](#bluenet_lib_configs)
- Enable/disable scanning or high frequency power sampling


## Indoor localization

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

## Smartphone app

![Image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small.png)
![Second image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small1.png)
![Third image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small2.png)
![Fourth image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small3.png)
![Fifth image of Example app](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/crownstone-app-small4.png)

The [Crownstone app](https://github.com/crownstone/CrownstoneApp) (Android and iOS) makes use of these libraries and connects to the REST API as well.
The Crownstone app can be used as starting point to develop your own stand-alone app.
It is written in React Native.

