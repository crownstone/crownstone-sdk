# Crownstone-Hub REST

Welcome to the REST endpoint documentation! Our endpoints are split up into a few "Controllers".

You can find your REST interface here: 
```
https://<ip-of-your-hub>:5050/api/
```

You can also explore the endpoints from your browser here:
```
https://<ip-of-your-hub>:5050/api/explorer 
```

Initially, you may get a warning from your browser. This is because we (have to) use self-signed certificates in order
to have HTTPS running on a local network. The HTTPS ensures that all headers, and tokens you send with a request are encrypted!
You have to accept the self-signed (or invalid, depending on how the browser calls it) once before you can use the urls.
More information [here](https://medium.com/@dblazeski/chrome-bypass-net-err-cert-invalid-for-development-daefae43eb12).

In this document we will describe each of the controllers, but first, a bit about authorization!

# Authorization
In order to use some (most) of the endpoints, you need to be authenticated. You do this, you can either use the Authorize button on the explorer,
or provide a http header named `Authorization` or `access_token` or add `?access_token=<your-token>` to the end of your request. If you provide the token
as a query parameter, it will also end up in logs.

To obtain your token (assuming you already set-up your hub), you have to login to the Crownstone cloud, 
copy your accessToken, get your [userId](https://my.crownstone.rocks/explorer/#!/user/user_getUserId) and get your
 [keys](https://my.crownstone.rocks/explorer/#!/user/user_getEncryptionKeysV2). 
The one you need here is the `sphereAuthorizationToken` from the sphere you configured the hub in. In the rest of the document we will
refer to this token as the access token.

Possiblities in this document:
```
admin authorization required  // this means you have to be an admin in your sphere.
authorization required        // this means you have to be an admin or member in your sphere.
no authorization required     // anyone can access this.
```

# Controllers

#### [HubController](#HubController)
#### [MeshController](#MeshController)
#### [EnergyController](#EnergyController)
#### [SwitchController](#SwitchController)

<a name="HubController"></a>
## HubController

This controller is responsible for configuring your hub. A lot of this functionality may change once the integration with the 
Crownstone consumer app is finalized. Adding a new hub will eventually be done via BLE and REST combined. For now however, we can use
these endpoints.



#### POST: /hub
> `no authorization required`
>
> This endpoint is used to instantiate a new hub. You can read the INSTALLATION.MD for more details.
> The datatype is in the following format:
> ```
>{
>  "name":     string,   // name of the Hub
>  "token":    string,   // 128 character (64byte) hex string.
>  "cloudId":  string,   // id of hub in the Crownstone cloud
>  "sphereId": string    // id of the sphere the hub belongs to.
>}
>```
> You can get a token here for convenience or generate one yourself: [https://my.crownstone.rocks/generateHubToken](https://my.crownstone.rocks/generateHubToken)
> 
> If there already is a hub configuration present, this method will throw an error.

<br/>

#### GET: /hubStatus
> `no authorization required`
>
> You can use this endpoint to get some information on how the hub is doing. The returned data type is:
> ```
> {
>    "initialized":     boolean,    // ready to use
>    "loggedIntoCloud": boolean,    // login to the Crownstone cloud successful
>    "loggedIntoSSE":   boolean,    // receiving server-sent events from events.crownstone.rocks
>    "syncedWithCloud": boolean,    // downloaded user, stone and room data from the cloud
>    "uartReady":       boolean,    // connection with USB dongle ready
>    "belongsToSphere": string      // configured to work in this sphere
>    "uptime":          number      // how many seconds the hub has been up. Can be reset when the hub is updated or rebooted.
> }
>```

<br/>

#### DELETE: /hub
> `no authorization required (for now)`
>
> Use this endpoint to delete the hub instance. The entire database will also be cleared. 
> From a user data point of view, the hub will return to the initial state when you first received it.
> Make sure you type YesImSure in the YesImSure field.

<br/>

<a name="MeshController"></a>
## MeshController
This controller will provide you with information on the mesh.

#### GET: /crownstonesInMesh
> `authorization required`
>
> You can use this endpoint to see which Crownstones are reachable in the mesh network connected to your hub. 
> This list will grow over time. The time is the time when the Crownstone is last seen since the Hub has been booted.
>```
> [
>    {
>        "uid":                 number,
>        "name":                string | null,     // can be null if the uid of the crownstone is not known to the hub.
>        "cloudId":             string | null,     // can be null if the uid of the crownstone is not known to the hub.
>        "locationName":        string | null,     // can be null if the uid of the crownstone is not known to the hub.
>        "lastSeen":            Date,              // ISO timestring like "2020-09-28T15:07:54.615Z"
>        "lastSeenSwitchState": number | null      // can be null if the uid of the crownstone is not known to the hub.
>    },
> ]
>```

<br/>

<a name="EnergyController"></a>
## EnergyController
This controller will provide you with everything regarding the collected energy data. 

#### GET: /energyAvailability
> `authorization required`
>
> This endpoint informs you of the amount of data available per Crownstone.
> The format of the returned data is:
>```
>[
>  {
>    "name":         string,         // name of the Crownstone
>    "locationName": string | null,  // name of the room the Crownstone is in.
>    "uid":          number,         // uid of Crownstone (uint8)
>    "cloudId":      string,         // id of Crownstone in the Crownstone cloud.
>    "count":        number          // amount of datapoints.
>  }
>]
>```

<br/>

#### GET: /energyRange
> `authorization required`
>
>This is where you get the energy data. You provide the Crownstone short UID, a from and until ISO timestring and finally a maximum amount of datapoints to collect.
>The more datapoints you ask for, the longer the request could take.
>A timestring looks like this: "2020-09-28T15:34:30.703Z"
>
>Return type is: 
>```
>[
>  {
>    "energyUsage": number,     // Energy in Joule (Watt-second)
>    "timestamp":   Date        // ISO timestring like "2020-09-28T15:07:54.615Z"
>  }
>]
>```

<br/>

#### DELETE: /energyData
> `admin authorization required`
>
> Delete all energy data from this hub.

<br/>

#### DELETE: /energyFromCrownstone
> `admin authorization required`
>
> Delete all energy data for a specific Crownstone from this hub.

<br/>

<a name="SwitchController"></a>
## SwitchController
This controller will handle all your requirements for switching and dimming the Crownstones in your network.

#### POST: /turnOff
> `authorization required`
>
> Turn off the Crownstone with the provided Crownstone short uid. 

<br/>

#### POST: /turnOn
> `authorization required`
>
> Turn on the Crownstone with the provided Crownstone short uid. Turn on will respect behaviour and twilight preferences of the Crownstone,
> whereas switch with 100% will just set the light to 100% regardless of the behaviour.

<br/>

#### POST: /switch
> `authorization required`
>
> Set the switch of the Crownstone that has the provided short UID to the provided percentage (0, 10-100). 
> Dimming between 0 and 10% is not allowed.

<br/>

#### POST: /switchMultiple
> `authorization required`
>
> Switch a number of Crownstones at the same time. You have to provide an array of SwitchData objects which are described below. 
> The difference between turn on and percentage is described above.
>```
>type SwitchData = toggleData | dimmerData;
>
>interface toggleData {
>  type: "TURN_ON" | "TURN_OFF"
>  stoneId: number,
>}
>
>interface dimmerData {
>  type: "PERCENTAGE"
>  stoneId: number,
>  percentage: number // 0 ... 100
>}
>```



