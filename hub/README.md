# Crownstone hub

The Crownstone hub can be configured with the Crownstone app. If you have bought the hub from <https://shop.crownstone.rocks> you do not have to do anything else, 
it will be all operational. Under the hood there is an Ubuntu Core system that gets software updates via so-called snaps. The data is stored on the hub itself,
in a Mongo database. The hub has a USB dongle to directly tap into the Bluetooth Mesh used by Crownstones. Note that other devices that use Bluetooth Mesh 
are not necessarily compatible with our software (feel free to suggest integrations). The data on the hub is exchanged with the Crownstone servers. The hub also 
operates as a way in which it can disseminate commands to the Crownstones from the Crownstone cloud or your phone on your LAN (say, your Wi-Fi network at home). 
If you want to obtain the data that resides on the hub, there's an API for that (see below). This is a good alternative if:

* you do not want to rely on accessing the Crownstone cloud (which will throttle your data)
* you do not want to store the data on the Crownstone cloud.

Index

- [Updating your Crownstones](#setting-up-and-updating-your-Crownstones)
- [Setting up your own hub](#setup-of-your-own-hub)
- [How to manually setup the hub software](#manual-setup-of-the-hub-software)
- [Hub API](#the-hub-api)


# Setting up and updating your Crownstones

In order for the energy monitoring to work, and in order for the Crownstone USB dongle to be able to communicate with the hub, you need to update all Crownstones (including the dongle) to firmware 5.3.0. You can do this with the Crownstone smartphone consumer app. 

Summarized:

- Install the Crownstone app.
- Create a Crownstone account.
- Add the Crownstone to your sphere.
    - Make sure the Crownstone is powered.
    - In the sphere overview, click the `(+)` button at the bottom right.
    - Select `Crownstone`.
    - Follow the steps.
    - Repeat this for every Crownstone (and Crownstone USB dongle).
- Check if your Crownstones are at version 5.3.0 or higher.
    - If there is a blue bar with `Update available` on top, click it.

You can check the firmware version of a Crownstone in the consumer app by going to the room your Crownstone is in, tapping on the title of the Crownstone, tapping Edit in the top right corner and scroll to the bottom of the screen.

Summarized:

- Navigate to the Crownstone.
- Click `edit`.
- Scroll to the bottom to see the current firmware version.

# Setup of your own hub

You can run our software on your own hub as long as it is compatible with the "snap" system from Ubuntu and you have bought a USB dongle 
from <https://shop.crownstone.rocks>. First you have to install the right software on the hub and give the right permissions.

If your hub is a Raspberry PI you can for example follow [this tutorial](https://ubuntu.com/tutorials/how-to-install-ubuntu-core-on-raspberry-pi#1-overview) to have Ubuntu Core on your machine.

Set the correct time zone:

    sudo timedatectl set-timezone Europe/Amsterdam

Optionally, [change the update interval](https://snapcraft.io/docs/keeping-snaps-up-to-date):

    sudo snap set system refresh.timer=00:00~24:00/24

The crownstone-hub snap uses a mongo database. There's no default snap for mongo available, so we packaged one for you:

    sudo snap install crownstone-mongo

The installation of software is straightforward:

    sudo snap install crownstone-hub

Now, this snap has to get access to the USB dongle over serial (or "UART"). First set the "hotplug" option to true and restart the daemon:

    sudo snap set system experimental.hotplug=true
    sudo systemctl restart snapd

Stick the Crownstone USB dongle in an USB port and give the hub access to the Crownstone USB dongle. Note: this will give it access to only this USB dongle.

    sudo snap connect crownstone-hub:serial-port core:cp2102cp2109uartbrid

Optionally, give permission to some additional interfaces we don't use yet, but that might be used later:

    sudo snap connect crownstone-hub:serial-port              pi:bt-serial
    sudo snap install bluez
    sudo snap connect crownstone-hub:bluez                    bluez:service
    sudo snap connect crownstone-hub:bluetooth-control        :bluetooth-control
    sudo snap connect crownstone-hub:removable-media          :removable-media

Now you are ready to setup the hub software itself, which connects everything to the Crownstone cloud using your authentication data.


# Manual setup of the hub software
You can use the Crownstone consumer app to setup the hub. Go to the add a new Crownstone menu and select Crownstone Hub from the list. Follow the steps in the app.

# The Hub API

TThere is an API available on the hub with which data can be obtained directly from the hub. This has quite some info, so we create a separate document for this. See this [document](ENDPOINTS.md).

# Hub usage examples

In the [examples](examples/) folder there are two examples. One to get data using a script [.js file](./examples/example.js) and one where we get the data in a browser [.html file](./examples/example.html).
