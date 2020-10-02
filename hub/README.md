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

- [Updating your Crownstones](#updating)
- [Setting up your own hub](#own_hub)
- [How to manually setup the hub software](#manual_setup)
- [Hub API](#api)


<a name="updating"></a>
# Setting up and updating your Crownstones

In order for the energymeasurement to work, and in order for the Crownstone USB dongle to be able to communicate with the hub, you need to update all Crownstones (including the dongle) to firmware 5.3.0. At the moment this firmware is released only to our BETA users. To join the beta program, make a Crownstone account and send an email to `access[at]crownstone.rocks`. Please mention the email address used to login to our cloud so we can enable BETA access for your account. After your phone syncs with the cloud, the new firmware can be installed via the Crownstone consumer app. The syncing takes place every 10 minutes and on app boot.

Summarized:

- Install the Crownstone app.
- Create a Crownstone account.
- Send an email to `access[at]crownstone.rocks`
    - Request to join the beta program.
    - Provide the email you used to create the account.
- Add the Crownstone USB dongle, and other Crownstones to your sphere.
    - Make sure the Crownstone is powered.
    - In the sphere overview, click the `(+)` button at the bottom right.
    - Select `Crownstone`.
    - Follow the steps.
    - Repeat this for every Crownstone (and Crownstone USB dongle).
- Wait for your phone to sync with the cloud (should take less than 15 minutes).
- You should now be able to update your Crownstones to version 5.3.0.
    - A blue bar with `Update available` will be on top.
    - Click it, and verify the "What's new" mentions the Crownstone hub.
    - Update all Crownstones and USB dongles.

You can check the firmware version of a Crownstone in the consumer app by going to the room your Crownstone is in, tapping on the title of the Crownstone, tapping Edit in the top right corner and scroll to the bottom of the screen.

Summarized:

- Navigate to the Crownstone.
- Click `edit`.
- Scroll to the bottom to see the current firmware version.

<a name="own_hub"></a>
# Setup of your own hub

You can run our software on your own hub as long as it is compatible with the "snap" system from Ubuntu and you have bought a USB dongle 
from <https://shop.crownstone.rocks>. First you have to install the right software on the hub and give the right permissions.

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


<a name="manual_setup"></a>
# Manual setup of the hub software

The current setup with our dongle requires the following manual steps. We will assume you have create an account via the [Crownstone consumer app](https://crownstone.rocks/app/)
and are able to control a couple of Crownstones, either built-in or plugs. If you done this, this means that:
* you have an account on the Crownstone cloud, at <https://my.crownstone.rocks>,
* you have a so-called `sphere` (a collection of Crownstones including keys for encrypting data to/from those Crownstones). 

Later on, we will support the following steps from the smartphone app, but for now you will have to manually add the Crownstone USB dongle to your sphere.

- Plug in the Crownstone USB dongle to your device.
- Go to the Crownstone cloud at <https://my.crownstone.rocks> and get a token.
- Go subsequently to the explorer at <https://my.crownstone.rocks/explorer> and populate the token field in the top.
- Go to [Get /users/me](https://cloud.crownstone.rocks/explorer/#!/user/user_me) and click `Try it out`, the copy the `id`.
- Similarly, get the `id` of your sphere via [Get /users/{id}/spheres](https://cloud.crownstone.rocks/explorer/#!/user/user_spheres). Fill in your user id in the **id** field, and click `Try it out`.
- Create a new `token` (this is a different token then the one for logging in, one you generate yourself!). It should be 64 random bytes in hexstring format (so 128 hex characters). You can use [my.crownstone.rocks/generateHubToken](https://my.crownstone.rocks/generateHubToken) to generate one.
- Create a hub instance by [Post /Spheres/{id}/hub](https://cloud.crownstone.rocks/explorer/#!/Sphere/Sphere_createHub). Fill in your sphere id in the **id** fiels, the generated token in the **token** field, and a name in the **name** field. Click `Try it out`, and check that it was a success.
- Get the hub `id` from [Get /Spheres/{id}/hubs](https://my.crownstone.rocks/explorer/#!/Sphere/Sphere_prototype_get_hubs), and write it down, as you'll need it later.
- Get the `sphereAuthorizationToken` of the correct sphere from [Get /users/{id}/keysV2](https://my.crownstone.rocks/explorer/#!/user/user_getEncryptionKeysV2).
- Find the IP address of the hub. Say it is at `192.168.0.0`, then go to port 5050, and use https: https://192.168.0.0:5050.
- If according to your browser the certificates are not valid, click "Yes I know", or something similar to continue.
- Go to the explorer.
- Click `Authorize` on the top right, and fill in the `sphereAuthorizationToken`, then click `Close`.
- Tell the hub about its Crownstone cloud account. You can post to an endpoint on the hub via [HubController Post /hub](https://192.168.0.0:5050/explorer/#/HubController/HubController.createHub). Click `Try it out` and use the following format:
  ```
  {
    "name": "name from cloud",
    "token": "hexstring token from cloud",
    "cloudId": "id of hub in cloud",
    "sphereId": "id of sphere in cloud"
  }
  ```
- Press execute, and check that it was a success.
- You're done! The hub is now connected to the Crownstone cloud.

Note that these steps are only required in this early phase! Later on, the Crownstone app will take care of this. Moreover, the process will use the USB dongle itself and the Bluetooth connection to the dongle. The end point [HubController Post /hub](https://192.168.0.0:5050/explorer/#/HubController/HubController.createHub) will then be removed again.


<a name="api"></a>
# The Hub API

TThere is an API available on the hub with which data can be obtained directly from the hub. This has quite some info, so we create a separate document for this. See this [document](ENDPOINTS.md).

<a name="examples"></a>
# Hub usage examples

In the [examples](examples/) folder there are two examples. One to get data using a  script [.js file](./examples/example.js) and one where we get the data in a browser [.html file](./examples/example.html).
