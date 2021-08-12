# Wearables

Crownstone support for wearables is very, very new! The release is planned for Q3 2021. We will make things much easier before we release and many steps that are described here will become easier or redundant.

## Scan

Crownstones can scan for Bluetooth LE messages from devices that broadcast those regularly. If a device does not broadcast at regular times, we cannot force it to do so.

We have tested the following devices:

| Brand    | Model     | Freq (Hz) | Recognized by |
|----------|-----------|----------:|---------------|
| Minew    | D15N      |       1-2 |   MAC address |

The device has to have something that it is recognized by. This can be a **manufacturer ID** for all devices of a particular brand. Or this can be something unique, for example a **MAC address**. In that case it is important that this information does **not** change over time. It should not "rotate" its address.

The Crownstones have to be configured in such way that they are only reacting to a particular manufacturer ID or a particular MAC address. For that a **filter** has to be configured. The filter has as task to only pass through the messages from devices we would like.

## Firmware

This was tested with firmware 5.5.0.
There is a known bug in firmware 5.5.0 that let's you only set up to 2 specific entries per filter.

## Configuring filter

Work in progress: an example for using the hub rest api will be added here.

You can also use the python library to set an asset filter. An example can be found [here](https://github.com/crownstone/crownstone-lib-python-uart/blob/master/examples/asset_filter_example.py).

## Presence

Note that by setting profile ID to 0, the assets will also "count for" **presence detection** as someone being in the sphere.


You can test this most easily by having a rule that reacts to presence and which controls the power for a light based on that presence. If you have a Nordic Semi development board you can inspect the logs (with non-release firmware and logs enabled).

## Recommendation

Currently, each time an asset advertisement is seen by a crownstone, the crownstone will send a message over the mesh, which leads to congestion in the mesh. So for now, we recommend using assets that only advertise once a second, not using many assets, and not having many crownstones in a sphere. 

We have tested the following hardware:

* Minew D15N ([manufacturer site](https://www.minew.com/products/d15n-ufo-beacon.html))

If you want to be able to do presence detection with some **other hardware**, please contact us. We can check if this is possible. Give us as much information as possible on the messages it is broadcasting. For example using the Nordic Semi [nRF Connect for Mobile](https://www.nordicsemi.com/Software-and-tools/Development-Tools/nRF-Connect-for-mobile) app.
