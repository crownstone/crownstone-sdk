# Crownstone SDK

The Crownstone SDK exists out of three parts (in an increasing order of integration):

* A [REST API](#rest_api) in the cloud
* Smartphone [libraries](#smartphone_libs)
* The [firmware](#bluenet) on the Crownstones, called Bluenet

## <a name="roadmap"></a>Roadmap
There are still many functionalities to be finished. This means that some APIs are not there yet, other APIs still need to be implemented, while others may change. Especially the firmware API is expected to undergo a lot of changes.

## <a name="rest_api"></a>REST API

The cloud is required to setup the Crownstones: keys and IDs will be generated, and locations can be set. After that, it can be used to add users, so they can also make use of your Crownstones. The cloud is also used to synchronize data between users, and serves as data storage. You can read how to use it in the [REST API documentation](REST_API.md).

## <a name="smartphone_libs"></a>Smartphone libraries

The smartphone libraries can be found at github:

- Android
    - [Bluetooth](https://github.com/dobots/bluenet-lib-android) (communication with Crownstones)
    - Localization (not there yet)
- iOS
    - Bluetooth (not there yet)
    - Localization (not there yet)

The Crownstone app makes use of these libraries for the Bluetooth Low Energy part and connect to the REST API as well. The Crownstone app can be used as starting point to develop your own stand-alone app. It is written with React Native, and can be found at [github](https://github.com/dobots/CrownstoneApp).

## <a name="bluenet"></a>Bluenet Firmware

The Bluenet Firmware can be downloaded from [github](https://github.com/dobots/bluenet/). There, you can also find the documentation of the bluetooth protocol (services, characteristics, and advertisements). To build the firmware, a GCC cross-compiler is required.



