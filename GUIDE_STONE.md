
# Guidestone

Guidestones enable indoor localization for phones and, later, also for wearables. 

The localization works in two ways:

1. By sending iBeacon or Eddystone messages, a phone with an app can determine where in the building it is.
2. By scanning for wearables, the Guidestones have a distance estimate to each wearable. Combining those estimates gives a location estimate of the wearable.


## Usage

#### Setup

Currently, each Guidestone first has to be setup individually. This ensures that noone else can configure your Guidestones. You can use the [Crownstone app](https://crownstone.rocks/app/) (iOS and Android) to perform the setup.


## Upcoming features
Some features are not finished yet, but will become available via firmware updates.
However, these features can already be used in test pilots.

#### Mesh
With the mesh, the Guidestones can communicate with eachother. This enables configuring all Guidestones from any other Guidestone.

#### Hub
With a hub, the Guidestones can be constantly controlled and monitored via the internet.

#### Scanning
This enables the localization of wearables, also requires a hub.


## Integration

Both the [protocol](https://github.com/crownstone/bluenet/blob/master/docs/PROTOCOL.md) used over the bluetooth as the [cloud API](REST_API.md), are documented.
Furthermore, there are libraries for [iOS](https://github.com/crownstone/bluenet-lib-ios) and [Android](https://github.com/crownstone/bluenet-lib-android).

## iBeacon

Unlike many battery powered beacons, the Guidestone advertises at 100ms (10 times per second) as per iBeacon specifications.
You can configure UUID, Major, Minor and TxPower (RSSI at 1m).


## Specifications

| Property               | Specification |
| ---------------------- | -------------- |
| Advertisement interval | 100ms or more (configurable) |
| Transmission power     | -40dB to +4dB (configurable) |
| Network                | Mesh: connects Crownstone-to-Crownstone |
| Beacon function        | iBeacon or Eddystone (configurable) |
| Battery                | Not required! |
| Communication          | Bluetooth Low Energy 4.0 |
| Chipset                | Nordic nRF52, 64kB RAM chip |
