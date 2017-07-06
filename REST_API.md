# Crownstone REST API

The crownstone rest api is running on heroku and is available at https://cloud.crownstone.rocks. The base url for the 
rest api is `https://cloud.crownstone.rocks/api`. The endpoints are then appended to the base url. E.g. 
`POST /users/login` becomes `POST https://cloud.crownstone.rocks/api/users/login`. Note, navigating to that URL won't work. It's a POST request. If you want to use the POST login command, make sure you do not use an access token in this request.

To explore the API login through: https://cloud.crownstone.rocks/ and copy the accessToken to the explorer. The explorer gives an overview of the available endpoints and can be found at https://cloud.crownstone.rocks/explorer/. The endpoints 
describe the parameters as well as the responses. An example of the Stone endpoint (see below) can be seen here:

![Image of Strongloop API Explorer of the Stone endpoint](https://raw.githubusercontent.com/crownstone/crownstone-sdk/master/images/strongloop-api-explorer-stone.png)

The Parameter Type defines how the parameters have to be provided in the api call:

- body

    The parameter (usually in the case of an model object) as to be provided as application/json in the request body.

- path

    The parameter (usually in the case of id´s) have to be provided inside the path, e.g. `/Device/{id}/currentLocation` for device with id "1" becomes `/Device/1/currentLocation`

- query

    The parameter (usually simple types) have to be provided at the end of the path, e.g. `/Stones/findLocation` for stone with address ¨abcd¨ becomes `/Stones/findLocation?address=abcd`

Note: every api call except `/users/login` and `/users/resendVerification` has to provide the user's access token in the api path as access_token=abcdef.

Note: if there is more than one parameter with type query, they can be combined with &, e.g. `/Stones/findLocation?address=abcd&access_token=abcdef`

## OAUTH2

You can use OAUTH2 to access our cloud services. If you would like to use this, you can send us an email to obtain an account. If you have your clientId, clientSecret and accessable scopes, you can use the URIs below:

Auth URL: https://cloud.crownstone.rocks/oauth/authorize
Access Token URL: https://cloud.crownstone.rocks/oauth/token

We will provide more information on the OAUTH2 scopes, as well as streamlining the registration process in the near future.

## Models

The following models are implemented in the cloud:

- User

    Every user interacting with the cloud, is represented as an instance of User. Even if a user is only passively being tracked, he needs to be represented.

- Sphere

    Svery stone is assigned to a sphere. only users which are part of the given sphere can access the stone of that sphere

- Location

    Locations are used for localization. for that purpose, stones are linked to locations. locations are assigned to spheres.

- Stone

    Stones represent crownstones or guidstones, and is a ble device with a fixed location. stones are assigned to spheres. Note, we are henceforth only mentioning stones, which stands for Crownstones or Guidstones respectively.

- Device

    Devices are mobile devices, e.g. a smartphone, or a fitbit. These devices are assigned to a user.

- Appliance

	Appliances are used to identify the type and behaviour of a device plugged into a stone. Appliances can be shared among different stones.

### User

An object of the User model is a user interacting with the Stones. This can be actively, i.e. switching Stones, or passively, i.e. being tracked by the Stones. A user has the following mandatory properties to identify:

- First Name
- Last Name
- Email (has to be unique among all users)
- Password
- Profile Picture

For a user to interact with Stones he has to be part of a Sphere. A user can either create a new Sphere, and will be then owner of that Sphere, or he can join an existing Sphere. Depending on the role inside the Sphere, the user has different access restrictions on the Sphere, Stone, Location and Appliance Models. (see Sphere for the different roles).

A user can also own devices, which are used by the Stones to track the user.

The following main endpoints are available:

- Current Location. Get/Set/Check

    There are two possible routes to determine the location of the user:

    - The Stones will update the current location of the user based on the devices owned by that user.
    - The Device (Smartphone) will update the current location of the user based on the scans

- Devices. Get/Add/Delete

    The devices owned by the user

- Files. Get/Add/Delete

    Add files, in particular pictures, of the user

- ProfilePic. Get/Add/Delete

	A special file which is used as the profile picture of the user

- Spheres. Get/Create/Exit

    Retrieve the spheres that the user is part of, create a new one or exit an existing one.

- Me. Get

	Get's the user object of the currently logged in user (based on the access token)

- ResendVerification. Post

	Resends the verification email in case it expired or got lost

- Login/Logout. Post

	Endpoints to log in a user with email and password or to log out and invalidate the access token

- Keys. Get

	Returns the user's encryption keys for every sphere he is a member (or owner) of, based on his role in the sphere

Note: Any endpoint with `{id}` in the name, e.g. `GET /users/{id}`, can only be called by the user with this id. Users can't access objects of other users.

### Sphere

A sphere is a container of a set of Locations, Stones and Appliances. Every instance of these models has to belong to a sphere so that users can interact with them. Only the users which are members of the sphere owning the Stones can interact with them, be that switching, or just reading the states. A sphere is identified with a UUID and contains the encryption keys neccessary to encrypt/decrypt the messages to/from the Stones. More precisely, a sphere has the following properties:

- Name

	A unique name identifying the sphere.

- UUID

	The proximity UUID which will be used in advertisements of the stones. See [here](https://github.com/crownstone/bluenet/blob/master/docs/PROTOCOL.md#ibeacon-advertisement-packet) for the advertisement protocol

- Mesh Access Address

	The access address on which the mesh will be operating on. Used to filter out messages on the mesh

- Encryption keys

	The three different encryption keys neccessary to encrypt / decrypt the messages to/from the Stones

A sphere has exactly one owner, which is the user who created the sphere. Except from the owner, a sphere can have any number of other users assigned to it with different roles. The roles in a sphere can be:

- Admin
- Member
- Guest

The role of a user inside a sphere determines the access rights to different api endpoints. E.g. a Guest can switch Stones, but not add or delete Stones. While a Member can add new stones, but not delete them.

A sphere has only one mandatory parameter, which is the name. The UUID, the Mesh Access Address and the Encryption Keys will be automatically generated when the sphere is created.

The following main endpoints are available:

- Get/Create/Update/Delete

	Interact with spheres of a user. E.g. create a new sphere, update an existing sphere, delete a sphere

- Files. Get/Add/Delete

    Add files, e.g. pictures of locations/rooms

- Users. Get/Add/Remove

    Get all users registerd with the sphere. Add/Remove existing users to/from the sphere

- Admins. Get/Add/Remove

    Same as users but only return admins, or add user as admin

- Members. Get/Add/Remove

    Same as admins but for members

- Guests. Get/Add/Remove

    Same as members but for guests

- Owner. Get/Update

    Returns the owner of the sphere or change ownership of the sphere. Note: only the owner can change ownership.

- Owned Locations. Get/Add/Create/Remove

    Interact with the locations that the sphere owns.

- Owned Stones. Get/Add/Create/Remove

    Interact with the stones that the sphere owns.

- Owned Appliances. Get/Add/Create/Remove

    Interact with the appliances that the sphere owns.

- Profile Picture. Get

    Get the profile picture of a user in the sphere

- Role. Get/Update

	Get or change the role of a user in the sphere. Note: Get role is available to all users of a group, while update role is only available to admins.

Note: Any endpoint with `{id}` in the name, e.g. `GET /Spheres/{id}`, can only be executed by a user which is part of the sphere with the given id.

Note: Creating new locations through the endpoint `POST /Spheres/{id}/ownedLocations` will automatically assign it to the Sphere with the given id. Alternatively, a user can also create new Locations through the `POST /Locations` endpoint and supply the sphere id as part of the JSON.

Note: Similar to the locations, stones and appliances can be created through the sphere.

### Location

A location can be any space containing Stones. This can be, depending on the required granularity, a part of a room (zone), a room, a floor, a building, etc. A location has two mandatory parameters, the name and the sphereId. Since every location has to belong to a sphere, the sphereId links the location to the sphere owning the location.

A location has the following properties:

- Name

	A name identifying the stone in a human readable manner. Should be (but doesn't have to be) unique.

- Meta Level

	A value representing the level of granularity of the location. Because a stone can belong to multiple locations, e.g. to a room, the floor and the building, we want to be able to distinguish between the different levels of granularity. The Meta Level 0 is used for the highest granularity, e.g. a Room, next lower, e.g. Floor will be assigned to 1, Meta Level 2 for Building, etc. The values are not fixed but can be used as desired. The default value is 0.

The location has one mandatory field wich is the name. The name should be, but doesn't have to be, unique among all locations in a given sphere, in order to be easily recognizable.

The following main endpoints are available:

- Get/Add/Update/Delete

	Interact with Locations, e.g. get all locations to which the user has access through one of his spheres, add a new location to one of the spheres, update a location or delete a location.

- Owner. Get

    The sphere which owns the location.

- Present People. Get/Check

    The users which have this location set as their current location. Or put differently, the users which are currently present at this location.

- Stones. Get/Create/Add/Update/Remove

    The stones linked to this location. E.g. all stones which are located inside this room. This relation will be used to determine the current location of a device/user

- Image. Get/Add/Delete

	Images stored for this location

Note:  Any endpoint with `{id}` in the name, e.g. `GET /Locations/{id}`, can only be executed by a user which is part of the sphere which owns the location with the given id.
Note: Requesting the list of locations with `GET /Locations` will return all locations owned by any sphere of which the user is part of.

### Stone

A Stone can be either a Crownstone or a Guidstone. A stone has the following properties:

- Name

	A name identifying the stone in a human readable manner. Should be (but doesn't have to be) unique.

- Address

	The BLE MAC address of the stone.

- Switch State

	Identifies the current switch state (ON or OFF) for Crownstones

- Device Type

	Identifies the type of device plugged into the Crownstone

- Type

	Identifies the type of stone, i.e. Crownstone / GuideStone

- Major/Minor/Uid

	The Major, Minor and Uid values used in the advertisement of the stone. They uniquely identify the stone. See [here](https://github.com/crownstone/bluenet/blob/master/docs/PROTOCOL.md#ibeacon-advertisement-packet) for the advertisement protocol

The mandatory properties of a Stone are it's address (BLE MAC address) and the sphere id, as every Stone has to belong to a sphere. Moreover, the address has to be unique among all Stones in the sphere to which it is added.

The following main endpoints are available:

- Get/Create/Update/Delete

	Interact with Stones, e.g. get all stones to which the user has access through one of his spheres, add a new stone to one of the spheres, update a stone or delete a stone.

- Owner. Get

    The sphere which owns the stone.

- Locations. Get/Add/Remove

    A stone can be part of several locations, e.g. a room, a floor, a building.

- Appliance. Get/Add/Remove

	A stone can be linked to an appliance, which identifies the behaviour and type of the device plugged into the Crownstone.

- Scans. Get/Create/Delete

    A Scan is a list of BLE devices (MAC address and RSSI value) together with a timestamp. It defines the devices seen by the Stone at the given time. The RSSI value is an average over all advertisements seen within the scan interval. The scans are used to determine the location of devices and will be processed by the cloud everytime a new scan is uploaded.

- Find Location. Get

    Returns the location of a stone identified by the given address

- Current coordinate and coordinatesHistory.

    A stone has only one current coordinate, but we also keep a history over time of the coordinates for SLAM.

- Notify on Recovery

	Notify the admins of the sphere which owns this stone that it was recovered by somebody else.

Except from these, there are also current and statistical data (history over time) available if it is a Crownstone, i.e.

- Power Usage
- Energy Usage
- Power Curve

Note:  Any endpoint with `{id}` in the name, e.g. `GET /Stones/{id}`, can only be executed by a user which is part of the sphere which owns the stone with the given id.
Note: Requesting the list of stones with `GET /Stones` will return all stones owned by any sphere of which the user is part of.

### Device

A device is a moving BLE device, e.g. a smartphone or a fitbit or any other BLE device which can be used to localize the user. A smartphone can scan itself for BLE devices and upload the scans to the cloud to be processed and update the current location, while a fitbit can be scanned by the stones which then upload the scans and update the current location.

Note: A device is owned by a user, and not part of a sphere.

A device has one mandatory property which is the address (BLE MAC address) which has to be unique among all devices.

The following main endpoints are available:

- Get/Create/Update/Delete

	Interact with a device, e.g. create a new device, update a device or delete a device.

- Owner. Get

    The user which owns the device.

- Scans. Get/Create/Delete

    A Scan is a list of BLE devices (MAC address and RSSI value) together with a timestamp. It defines the devices seen by the device at the given time. The RSSI value is an average over all advertisements seen within the scan interval. The scans are used to determine the location of the device and will be processed by the cloud everytime a new scan is uploaded.

- currentLocation and locationsHistory

    A device can only have one current location, which also determines the current location of the user owning the device. For statistical data we also keep a history of the device's location.

- currentCoordinate and coordinatesHistory

    For more accurate positioning, a device can have a (one) current coordinate. Again we keep a history of the device's coordinates for statistical data.

Note:  Any endpoint with `{id}` in the name, e.g. `GET /Devices/{id}`, can only be executed by the user who owns the device with the given id.

### Appliance

An appliance defines the behaviour and type of device plugged into a Crownstone. The appliances belong to a sphere but can be shared among multiple stones.

The following main endpoints are available:

- Get/Add/Update/Delete

	Interact with Appliances, e.g. get all appliances to which the user has access through one of his spheres, add a new appliance to one of the spheres, update an appliance or delete an appliance.

- Owner. Get

    The sphere which owns the appliance.

- Stones. Get/Remove

	Get all stones which are linked with a given appliance or unlink the appliance from a stone.

Note:  Any endpoint with `{id}` in the name, e.g. `GET /Appliances/{id}`, can only be executed by a user which is part of the sphere which owns the appliance with the given id.
Note: Requesting the list of appliances with `GET /Appliances` will return all appliances owned by any sphere of which the user is part of.

## Example Applications

### Setup

#### User creation

1. A user can create an account using the `POST /users` endpoint
2. Once the user is created and the email is verified to be unique, a verification email is sent to the provided email.
3. After clicking the verification link in the email, the user can login using the `POST /users/login` endpoint providing the email and password as a JSON in the body
4. In the login call, the REST API will return the AccessToken of the user, which then subsequently has to be provided for any other call to the api (The AccessToken identifies the user), as well as the id of the user.

#### Creating content

1. Once the user is logged in, he can create a new sphere using the POST `/users/{id}/spheres` endpoint. He will then become owner of the sphere and can add other users to the sphere using `PUT /Spheres/{id}/admins/`, `PUT /Spheres/{id}/members/` or `PUT /Spheres/{id}/guests/`
by providing the email of the user. If the user doesn't have an account yet, an invitation email will be sent to the provided email.
2. Once a sphere is created, locations can be added to the Sphere using the `POST /Spheres/{id}/ownedLocations` endpoint.
3. Same applies for stones and appliances which can be added to the Sphere using the `POST /Spheres/{id}/ownedStones` and `POST /Spheres/{id}/ownedAppliances` endpoints.
4. Linking a stone with a location can be done either through the stone or through the location, i.e. using one of the following two endpoints:
	a. `PUT /Stones/{id}/locations/rel/{fk}`, where `{id}` is the id of the stone and `{fk}` is the id of the location
	b. `PUT /Locations/{id}/stones/rel/{fk}`, where `{id}` is the id of the location and `{fk}` is the id of the stone
5. Similarly, unlinking a stone from a location can be done using one of the following two endpoints:
	a. `DELETE /Stones/{id}/locations/rel/{fk}`, where `{id}` is the id of the stone and `{fk}` is the id of the location
	b. `DELETE /Locations/{id}/stones/rel/{fk}`, where `{id}` is the id of the location and `{fk}` is the id of the stone
6. Linking a stone with an appliance can be done through `PUT /Stones/{id}/appliance/{fk}`, where `{id}` is the id of the stone and `{fk}` is the id of the appliance
7. Similarly, unlink a stone from an appliance can be done through `DELETE /Stones/{id}/appliance/{fk}`, where `{id}` is the id of the stone and `{fk}` is the id of the appliance

### Localization

1. In order to provide localization, a user needs to create a device using the `POST /users/{id}/devices` endpoint. This device will then be used to localize the user. If the user has more than one device doing localization, the last change (in time) of any one of his devices will be set as the location of the user.
2. To update the current location of a device, use `PUT /Devices/{id}/currentLocation/{fk}`, where `{id}` is the id of the device and `{fk}` is the id of the location. This will also add the current location to the locationsHistory together with the timestamp `now`.
3. To retrieve the current location of a device, use `GET /Devices/{id}/currentLocation`, where `{id}` is the id of the device.
4. To retrieve the current location of a user, use `GET /users/{id}/currentLocation`, where `{id}` is the id of the user.
5. Alternatively, one can also check if a user is at a given location using `HEAD /users/{id}/currentLocation/rel/{fk}`, where `{id}` is the id of the user and `{fk}` is the id of the location.
6. To retrieve the Location of a stone when only the MAC address of the stone is known, the endpoint `GET /Stones/findLocation` can be used.
7. To get all users present at a given location, use `GET /Locations/{id}/presentPeople`, where `{id}` is the id of the location.


### Other use cases

1. Get user object of currently logged in user

        GET /users/me

1. Having the id of the location and wanting to know who is present:

        GET /Locations/{id}/presentPeople

1. Want to know who is present in the room the user is in (without knowing the id of the user)

    1. `GET /users/me`

        -> gives user object -> retrieve user id

    1. `GET /users/{id}/currentLocation`

        -> gives location object -> retrieve location id

    1. `GET /Locations/{id}/presentPeople`

1. Want to know the location of a crownstone given the MAC address

        GET /Stones/findLocation

1. Get Profile Picture of user with email in sphere with id

        GET /Spheres/{id}/profilePic

1. Invite a new member to the sphere with id

        PUT /Spheres/{id}/members

1. Add an existing user by email as a guest to sphere with id

        PUT /Spheres/{id}/guests
