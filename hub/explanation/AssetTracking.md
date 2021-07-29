# Asset Tracking (in-network localization)

This document is meant to explain the steps required to setup asset tracking using the Crownstone hub. 

We assume you've followed the [getting started](./GettingStarted.md) before reading this document.

## Concepts

The Crownstones in your house communicates with eachother via the mesh network. The Crownstones constantly scan for BLE devices.
Your asset, or device you'd like to track has to advertise BLE packets in order to be elligable for tracking.

### Asset & InputData
In the hub API, we use the concept of an Asset as a single, or set of devices. By telling the hub which identifiable parts of the device's advertisment
should be used to pass it through a scanning filter, one asset can be a single device or a large group of devices. Let's call this identifiable part
of the advertisement the `InputData`

- single device
    - define `InputData` that uniquely identifies one device
        - mac addres
        - full ibeacon uuid + major + minor
        - etc.
- group of devices
    - define `InputData` that identifies multiple devices
        - iBeacon UUID
        - manufacturer ID
        - specific service uuid
        - etc.
    
### OutputDescription

The output description of an asset will define what the Crownstone network should do with a device if it fulfills the `InputData` criteria.

Currently, we have 2 options:
- Tell the hub a Crownstone has seen a device
- Pass the advertisement to the in-network localization before it gets reported to the hub.

The first option will report the MAC address of the Asset, the id of the Crownstone that has seen it and the signal strength.

The second option will condense the representation of the Asset to a ShortAssetId and will localize it. This option is still work in progress. 

### ShortAssetId (WIP)

If you have defined `InputData` which can be many Asset, you want to get a report back in such a way that it can identify one particular Asset.

For example, you use an iBeacon UUID as the `InputData`, but want to know which major & minor belong to the beacon that was detected.

To solve this in a generic way, we have introduces the `ShortAssetId`. This is a 3 byte hash of a part of the advertisement. Since we do not know 
which part of your Asset's advertisement can uniquely identify your Asset, you can again provide an InputData to the OutputDescription so you can specify this.

The shortAssetId is a [CRC32 hash](https://en.wikipedia.org/wiki/Cyclic_redundancy_check#CRC-32_algorithm) of the byte array that you have identified in the `InputData`.
From these 4 bytes, the most significant byte is dropped.

If you want to work with these ShortAssetIds, we assume you have a complete list of all your individual assets. This allows you to precalculate all the shortAssetId representations of
these individual assets and quickly match them as they come in.


### Filters

Filters are datastructures on the Crownstones that tell it how to identify Assets and what to do with them. The hub generates these filter representations
for you based on the Assets you have defined.

### Comitting

Because we don't want to flood the mesh network with incomplete filters based on your assets, you have to explicitly call the `commit` endpoint beofre any
changes, removals etc. are propagated to the mesh network.

### Mesh propagation

Once you commit, the hub will connect to a Crownstone nearby and update it's filters. That Crownstone will then connect to another and update the filters there.
This goes on and on until all Crownstones have the new, shared, filters.



## Using the endpoints

Now you know enough to start setting up the Asset tracking functionality.
You can see all the endpoints regarding assets [here](../api/controllers/AssetController.md).

## How can I use this data?

We provide the localization as events, which you can have the hub send to a REST endpoint you control.

To do this, [we use the webhook controller. More information here.](../api/controllers/WebhookController.md)

### Example

[Here is a small example in nodejs.](./examples/AssetTracking)
