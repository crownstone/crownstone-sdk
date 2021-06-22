# Wearables

Crownstone support for wearables is very, very new! The release is planned for Q3 2021. We will make things much easier before we release and many steps that are described here will become easier or redundant.

## Scan

Crownstones can scan for Bluetooth LE messages from devices that broadcast those regularly. If a device does not broadcast at regular times, we cannot force it to do so.

We have tested the following devices:

| Brand    | Freq (Hz) | Recognized by |
|----------|----------:|---------------|
| ...      |         1 |   MAC address |

The device has to have something that it is recognized by. This can be a **manufacturer ID** for all devices of a particular brand. Or this can be something unique, for example a **MAC address**. In that case it is important that this information does **not** change over time. It should not "rotate" its address.

The Crownstones have to be configured in such way that they are only reacting to a particular manufacturer ID or a particular MAC address. For that a **filter** has to be configured. The filter has as task to only pass through the messages from devices we would like.

## Configuring filter

A filter can be configured using our python libraries. You can get those libraries by:

```
# install
```

You can use the library using the following script.

```
# configure filter
```

You can test if the proper filter has been uploaded to the Crownstone by:

```
# test
```

## Presence

To configure the Crownstone such that it uses the information going through the filter for **presence detection** you will have to configure it in the following manner:

```
# configure presence
```

You can test this most easily by having a rule that reacts to presence and which controls the power for a light based on that presence. If you have a Nordic Semi development board you can inspect the logs (with non-release firmware and logs enabled).

## Recommendation

We have tested the following hardware:

* ...
* ...

If you want to be able to do presence detection with some **other hardware**, please contact us. We can check if this is possible. Give us as much information as possible on the messages it is broadcasting. For example using the Nordic Semi [nRF Connect for Mobile](https://www.nordicsemi.com/Software-and-tools/Development-Tools/nRF-Connect-for-mobile) app.
