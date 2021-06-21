# Asset tracking

Crownstones can be configured in such way that they **scan** for Bluetooth Low Energy tags and that they use **Bluetooth Mesh** to communicate this information towards hubs. The bandwidth of Bluetooth mesh is limited so it is important to:

1. Use a limited number of Crownstones per hub; for now we recommend not more than 32 Crownstones;
2. Use a limited number of assets to be tracked in a particular physical area.

If the bandwidth is not sufficient, contact our technicians on how to improve on it.

## Preconfiguration

A preconfigured Crownstone kit for **asset tracking** has the following components:

* A set of Crownstones all configured with the proper security keys.
* A hub that is configured in such way that it can obtain the encrypted data from those Crownstones.
* A configured filter on each Crownstone that indicates what has to be tracked (e.g. a manufacturer identifier).
* A configured upstream on the hub that defines where the data is to be sent (e.g. AWS).
* Each Crownstone has a QR sticker on it that can be used to map it unto its MAC address.

It is important that when you get **multiple preconfigured kits** for asset tracking you do **not** mix and match the Crownstones and the hubs. The security keys are configured such that they will not communicate to another hub.

## Chaining

If you want to chain Crownstones we recommend the following configuration:

![Chain Crownstones](https://github.com/crownstone/crownstone-sdk/raw/master/images/crownstone-chain.png)

You see that the Crownstones are **not** daisy-chained. The output is left **disconnected**. This is on purpose! It means that the system does not depend on the state of the relay in the Crownstone.

## Support

We deliver additional support such as configuration within your backend or providing a custom uplink towards your backend on a case by case basis. We can also define a service level agreement for your application which defines monitoring services for our hardware or our services, include updates of the Crownstone hub software, etc. For your end customers we recommend to have your own support staff in place.
