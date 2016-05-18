# Crownstone REST API

The crownstone rest api is running on heroku and is available at https://crownstone-cloud.herokuapp.com. The base url for the rest api is https://crownstone-cloud.herokuapp.com/api. The endpoints are then appended to the base url. E.g. `POST /users/login` becomes `POST https://crownstone-cloud.herokuapp.com/api/users/login`

An overview of the available endpoints can be found at https://crownstone-cloud.herokuapp.com/explorer. The endpoints describe the parameters as well as the responses. 

The Parameter Type defines how the parameters have to be provided in the api call:

- body
    
    The parameter (usually in the case of an model object) as to be provided as application/json in the request body.
    
- path

    The parameter (usually in the case of id´s) have to be provided inside the path, e.g. `/Device/{id}/currentLocation` for device with id "1" becomes `/Device/1/currentLocation`
    
- query

    The parameter (usually simple types) have to be provided at the end of the path, e.g. `/Stones/findLocation` for stone with address ¨abcd¨ becomes `/Stones/findLocation?address=abcd`
    
Note: every api call except `/users/login` and `/users/resendVerification` has to provide the user's access token in the api path as access_token=abcdef. 

Note: if there is more than one parameter with type query, they can be combined with &, e.g. `/Stones/findLocation?address=abcd&access_token=abcdef`


## Models

The following models are implemented in the cloud:

- User

    every user interacting with the cloud, is represented as an instance of User. Even if a user is only passively being tracked, he needs to be represented.
    
- Group
    every stone is assigned to a group. only users which are part of the given group can access the stone of that group
    
- Location

    locations are used for localization. for that purpose, stones are assigned to locations. locations are assigned to groups.
    
- Stone

    stones represent crownstones or guidstones, and is a ble device with a fixed location. stones are assigned to groups. Note, we are henceforth only mentioning stones, which stands for Crownstones or Guidstones respectively.
    
- Device

    devices are mobile devices, e.g. a smartphone, or a fitbit. these devices are assigned to a user.

### User

An object of the User model is a user interacting with the Crownstones. This can be actively, i.e. switching Stones, or passively, i.e. being tracked by the Stones. A user has the following mandatory properties to identify:

- First Name
- Last Name
- Email (has to be unique among all users)
- Password
- Profile Picture

For a user to interact with Stones he has to be part of a Group. A user can either create a new Group, and will be then owner of that Group, or he can join an existing Group. Depending on the role inside the Group, the user has different access restrictions on the Stone, Location and Group Models. (see Group for the different roles).

A user can also own devices, which are used by the Stones to track the user.

The following main endpoints are available:

- Current Location. Get/Set/Check

    There are two possible routes to determine the location of the user:
    
    - The Stones will update the current location of the user based on the devices owned by that user.
    - The Device (Smartphone) will update the current location of the user based on the scans
        
- Devices. Get/Add/Delete

    The devices owned by the user
    
- Files. Get/Add/Delete

    Add files, in particular pictures, of the user, e.g. profile picture
    
- Groups. Get/Create/Exit

    Retrieve the groups that the user is part of, create a new one or exit an existing one.
    
Note: Any endpoint with `{id}` in the name, e.g. `GET /users/{id}`, can only be executed by the user with this id. Users can't access objects of other users. 

### Group

A group is a container of a set of Locations and Stones. Every Stone and Location has to belong to a group so that users can interact with them. Only the users which are members of the group owning the Stones can interact with them, be that switching, or just reading the states. A group is identified with a UUID and contains the encryption keys neccessary to encrypt/decrypt the messages to/from the Stones.

A group has exactly one owner, which is the user who created the group. Except from the owner, a group can have any number of other users assigned to it with different roles. The roles in a group can be:

- Owner
- Member
- Guest

The role of a user inside a group determines the access rights to different api endpoints. E.g. a Guest can switch Stones, but not add or delete Stones. While a Member can add new stones, but not delete them.

A group as only one mandatory parameter, which is the name. The UUID will be automatically generated when the group is created.

The following main endpoints are available:

- Files. Get/Add/Delete

    Add files, e.g. pictures of locations/rooms

- Users. Get/Add/Remove

    Get all users registerd with the group. Add/Remove existing users to/from the group

- Members. Get/Add/Remove

    Same as users but only return members, or add user as member

- Guests. Get/Add/Remove

    Same as members but for guests
    
- Owner. Get

    Returns the owner of the group
    
- Owned Locations. Get/Add/Create/Remove

    Interact with the locations that the group owns. 
    
- Owned Stones. Get

    Return all the stones owned by the group. these are obtained through the owned locations and the stones assigned to these.
    
- Profile Picture. Get

    Get the profile picture of a user in the group

Note: Any endpoint with `{id}` in the name, e.g. `GET /Groups/{id}`, can only be executed by a user which is part of the group with the given id.

Note: Creating new locations through the endpoint `POST /Groups/{id}/ownedLocations` will automatically assign it to the Group with the given id. Alternatively, a user can also create new Locations through the `POST /Locations` endpoint and supply the group id as part of the JSON.

### Location

A location can be any space containing Stones. This can be, depending on the required granularity, a part of a room (zone), a room, a floor, a building, etc. A location has two mandatory parameters, the name and the groupId. Since every Location has to belong to a group, the groupId links the location to the group owning the location.

The following main endpoints are available:

- Owner. Get

    The group which owns the location.

- Present People. Get/Check

    The users which have this location set as their current location.

- Stones. Get/Create/Add/Remove

    The stones assigned to this location. E.g. all stones which are located inside this room. This relation will be used to determine the current location of a device/user
    
Note:  Any endpoint with `{id}` in the name, e.g. `GET /Locations/{id}`, can only be executed by a user which is part of the group which owns the location with the given id.
Note: Requesting the list of locations with `GET /Locations` will return all locations owned by any group of which the user is part of.

### Stone

A Stone can be either a Crownstone or a Guidstone.

The mandatory properties of a Stone are it's address (BLE MAC address) and the group id. As every Stone has to belong to a group. Moreover, the address has to be unique among all Stones (over all groups). 

The following main endpoints are available:

- Owner. Get

    The group which owns the stone.

- Locations. Get/Add/Remove

    A stone can be part of several locations, e.g. a room, a floor, a building.

- Scans. Get/Create/Delete

    A Scan is a list of BLE devices (MAC address and RSSI value) together with a timestamp. It defines the devices seen by the Stone at the given time. The RSSI value is an average over all advertisements seen within the scan interval. The scans are used to determine the location of devices and will be processed by the cloud everytime a new scan is uploaded.

- Find Location. Get

    Returns the location of a stone identified by the given address

- Current coordinate and coordinatesHistory.

    A stone has only one current coordinate, but we also keep a history over time of the coordinates for SLAM.

Except from these, there are also current and statistical data (history over time) available if it is a Crownstone, i.e.

- Power Usage
- Energy Usage
- Power Curve
    
Note:  Any endpoint with `{id}` in the name, e.g. `GET /Stones/{id}`, can only be executed by a user which is part of the group which owns the stone with the given id.
Note: Requesting the list of stones with `GET /Stones` will return all stones owned by any group of which the user is part of.

### Device

A device is a moving ble device, e.g. a smartphone or a fitbit or any other ble device which can be used to localize the user. A smartphone can scan itself for ble devices and upload the scans to the cloud to be processed and update the current location, while a fitbit can be scanned by the stones which then upload the scans and update the current location. 

Note: A device is owned by a user, and not part of a group. 

A device has one mandatory property which is the address (ble MAC address). As for the stones, this has to be unique among all devices.

The following main endpoints are available:

- Owner. Get

    The group which owns the device.

- Scans. Get/Create/Delete

    A Scan is a list of BLE devices (MAC address and RSSI value) together with a timestamp. It defines the devices seen by the device at the given time. The RSSI value is an average over all advertisements seen within the scan interval. The scans are used to determine the location of the device and will be processed by the cloud everytime a new scan is uploaded.

- currentLocation and locationsHistory

    A device can only have one current location, which also determines the current location of the user owning the device. For statistical data we also keep a history of the devices location.

- currentCoordinate and coordinatesHistory

    For more accurate positioning, a device can have a (one) current coordinate. Again we keep a history of the devices coordinates for statistical data.

Note:  Any endpoint with `{id}` in the name, e.g. `GET /Devices/{id}`, can only be executed by the user who owns the device with the given id.

## Example Applications

### Setup

#### User creation

1. A user can create an account using the `POST /users` endpoint
2. Once the user is created and the email is verified to be unique, a verification email is sent to the provided email.
3. After clicking the verification link in the email, the user can login using the `POST /users/login` endpoint and providing the email and password as a JSON in the body
4. In the login call, the REST API will return the AccessToken of the user, which then subsequently has to be provided for any other call to the api (The AccessToken identifies the user), as well as the id of the user.

#### Creating content

1. Once the user is logged in, he can create a new group using the POST `/users/{id}/groups` endpoint. He will then become owner of the group and can add other users to the group using `POST /Groups/{id}/members/` or `POST /Groups/{id}/guests/`
by providing the email of the user.
2. Once a group is created, locations can be added to the Group using the `POST /Groups/{id}/ownedLocations` endpoint.
3. Once a location is created, stones can be added to the location using the `POST /Locations/{id}/stones` endpoint.

### Localization

1. In order to provide localization, a user needs to create a device using the `POST /users/{id}/devices` endpoint. This device will then be used to localize the user in one of two ways:
    a. if it is a smartphone, the smartphone can scan for devices, and upload the scans to `POST /Devices/{id}/scans`. They will than be parsed by the cloud and the location of the device will be updated. 
    b. if the device is a ble device that advertises itself, it will be scanned by the stones, which then upload their scans to `POST /Stones/{id}/scans`. Again the scans will be parsed and the current location of the scanned devices will be updated.

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

1. Get Profile Picture of user with email in group with id

        GET /Groups/{id}/profilePic

1. Create a new member and add it to group with id

        POST /Groups/{id}/members
    
1. Add an existing user by email as a guest to group with id

        PUT /Groups/{id}/guests