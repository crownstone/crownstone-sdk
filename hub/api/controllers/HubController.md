# HubController

This controller is responsible for configuring your hub. This is usually handled for you by the Crownstone consumer app.
There is no real need to use these yourself, but we've documented them anyway.

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

> `admin authorization required`
>
> Use this endpoint to delete the hub instance. The energy database will be retained. If a new hub will be created and it belongs to a different sphere
> than the previous hub, the energy data will be removed at this point. The goal here is to not remove (important) historical data if a user removes a hub from his sphere and adds it again. 
> Make sure you type YesImSure in the YesImSure field.

<br/>

#### DELETE: /hub/everything
> `admin authorization required`
>
> Use this endpoint to delete the hub instance. The entire database will also be cleared.
> From a user data point of view, the hub will return to the initial state when you first received it.
> Make sure you type YesImSure in the YesImSure field.
