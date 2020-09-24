# Crownstone hub

The Crownstone hub can be configured with the Crownstone app. If you have bought the hub from <https://shop.crownstone.rocks> you do not have to do anything else, 
it will be all operational. Under the hood there is an Ubuntu Core system that gets software updates via so-called snaps. The data is stored on the hub itself,
in a Mongo database. The hub does have a USB dongle to directly tap into the Bluetooth Mesh used by Crownstones. Note that other devices that use Bluetooth Mesh 
are not necessarily compatible with our software (feel free to suggest integrations). The data on the hub is exchanged with the Crownstone servers. The hub also 
operates as a way in which it can disseminate commands to the Crownstones from the Crownstone cloud or you phone on your LAN (say, your Wi-Fi network at home). 
If you want to obtain the data that resides on the hub, there's an API for that (see below). This is a good alternative if:
* you do not want to rely on accessing the Crownstone cloud (which will throttle your data)
* you do not want to store the data on the Crownstone cloud.

# Your own hub

You can run our software on your own hub as long as it is compatible with the "snap" system from Ubuntu and you have bought a USB dongle 
from <https://shop.crownstone.rocks>. First you have to install the right software on the hub and give the right permissions.

## Setup of the hub

The installation of software is straightforward:

    sudo snap install crownstone-hub

Now, this snap has to get access to the USB dongle over serial (or "UART"). First set the "hotplug" option to true and restart the daemon:

    sudo snap set system experimental.hotplug=true
    sudo systemctl restart snapd

Stick the Crownstone USB dongle in an USB port and check if its interface can be found:

    if [ $( snap interface serial-port | grep 'snapd:cp2102cp2109uartbrid' | wc -l ) -lt 1 ]; then
        snap interface serial-port
        echo "Crownstone USB stick was not found!"
        exit 1
    fi

Give the hub access to the Crownstone USB dongle:

    sudo snap connect crownstone-hub:serial-port core:cp2102cp2109uartbrid

Give some additional permissions to the hub:

    sudo snap connect crownstone-hub:removable-media          :removable-media
    sudo snap connect crownstone-hub:serial-port              pi:bt-serial

Now you are ready to configure the USB dongle itself, which connects everything to the Crownstone cloud using your authentication data.

## Setup with the USB dongle

The current setup with our dongle requires the following manual steps. We will assume you have create an account via the [Crownstone consumer app](https://crownstone.rocks/app/)
and are able to control a couple of Crownstones, either built-in or plugs. If you done this, this means that:
* you have an account on the Crownstone cloud, at <https://my.crownstone.rocks>,
* you have a so-called `sphere` (a collection of Crownstones including keys for encrypting data to/from those Crownstones). 

Later on, we will support the following steps from the smartphone app, but for now you will have to manually add the Crownstone USB dongle to your sphere.

1. Plug in the Crownstone USB dongle to your device.
2. Go to the Crownstone cloud at <https://my.crownstone.rocks> and get a token.
3. Go subsequently to the explorer at <https://my.crownstone.rocks/explorer> and populate the token field in the top.
4. Get your `userId` via [Get /users/me](https://cloud.crownstone.rocks/explorer/#!/user/user_me).
5. Find the `sphereId` of your sphere via [Get /users/{id}/spheres](https://cloud.crownstone.rocks/explorer/#!/user/user_spheres).
6. Create a new `token` (this is a different token then the one for logging in, one you invent yourself!). It should be 64 random bytes in hexstring format (so 128 characters).
7. Create a hub instance by [Post /Spheres/{id}/hub](https://cloud.crownstone.rocks/explorer/#!/Sphere/Sphere_createHub). The `id` is the `sphereId`, the `token` is the one you just generated, and the `name` is how you want to call your hub.
8. Get the hub cloud `id` from [Get /Spheres/{id}/hubs](https://my.crownstone.rocks/explorer/#!/Sphere/Sphere_prototype_get_hubs), and write it down, as you'll need it later.
9. Get the `sphereAuthorizationToken` of the correct sphere from [Get /users/{id}/keysV2](https://my.crownstone.rocks/explorer/#!/user/user_getEncryptionKeysV2).
10. Find the IP address of the hub. Say it is at <https://192.168.0.66>, then go to port 5050: <https://192.168.0.66:5050>.
11. If according to your browser the certificates are not valid, click "Yes I know", or something similar to continue.
12. Click `Authorize` on the top right, and fill in the `sphereAuthorizationToken`.
13. Tell the hub about its Crownstone cloud account. You can post to an endpoint on the hub. Given the above IP address, this is <https://192.168.0.66:5050/explorer/#/HubController/HubController.createHub>. Use the following format:
  ```
  {
    "name": "name from cloud",
    "token": "hexstring token from cloud",
    "cloudId": "id of hub in cloud",
    "sphereId": "id of sphere in cloud"
  }
  ```
14. You're done! The hub is now connected to the Crownstone cloud.

Note that these steps are only required in this early phase! Later on, the Crownstone app will take care of this. Moreover, the process will use the USB dongle itself and the Bluetooth connection to the dongle. The end point <https://192.168.0.66:5050/explorer/#/HubController/HubController.createHub> will then be removed again.

# The hub API

There is an API available on the hub with which data can be obtained directly from the hub. As soon as this is available this document will be update with a pointer to where you can learn more.
