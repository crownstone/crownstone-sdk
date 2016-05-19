# Crownstone SDK

The Crownstone SDK exists of three parts (in an increasing order of integration):

* A [REST API](#rest_api) in the cloud
* Smartphone [libraries](#smartphone_libs)
* The [firmware](#bluenet) on the Crownstones, called Bluenet

## <a name="rest_api"></a>REST API

The cloud is required to setup the Crownstones: keys and IDs will be generated, and locations can be set.
After that, it can be used to add users, so they can also make use of your Crownstones.
The cloud is also used to synchronize data between users, and serves as data storage.
You can read how to use it in the [REST API documentation](REST_API.md).

## <a name="smartphone_libs"></a>Smartphone libraries

The smartphone libraries can be found at github.

- Android
    - [Bluetooth](https://github.com/dobots/bluenet-lib-android) (communication with Crownstones)
    - Localization (in development)
- iOS
    - Bluetooth (in development)
    - Localization (in development)

The [Crownstone app](https://github.com/dobots/CrownstoneApp) makes use of these libraries and connects to the REST API as well.
The Crownstone app can be used as starting point to develop your own stand-alone app.
It is written with React Native, and can be found on github.

## <a name="bluenet"></a>Bluenet Firmware

The [Bluenet](https://github.com/dobots/bluenet/) firmware can be downloaded from github. There, you can also find the documentation of the bluetooth protocol (services, characteristics, and advertisements). To build the firmware, a GCC cross-compiler is required.

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

