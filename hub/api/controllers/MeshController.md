
# MeshController

This controller will provide you with information on the mesh. It provides you with all information to construct a network.

#### GET: /network

> `authorization required`
>
> This gives you a topology map of the mesh network.
>```
>Return type:
>  {
>    "edges":     Edge[],
>    "nodes":     { shortUid: Crownstone }
>    "locations": { cloudId:  Location }
>  }
>
>Edge: 
>  {
>    "to":       number,      // shortUid
>    "from":     number,      // shortUid
>    "rssi":     {37: number, 38: number, 39: number},  // rssi value per channel
>    "lastSeen": number,      // timestamp
>  }
>
>Crownstone:
>  {
>    "name":            string,
>    "uid":             number,
>    "macAddress":      string,
>    "type":            string,
>    "switchState":     number | null,  // null if this device can't switch, like a hub.
>    "locked":          boolean,
>    "dimming":         boolean,
>    "switchcraft":     boolean,
>    "tapToToggle":     boolean,
>    "cloudId":         string,
>    "locationCloudId": string,    
>    "updatedAt":       number,          // timestamp
>  }
>
>Location:
>
>  {
>    "name":      string,
>    "uid":       number,
>    "icon":      string,
>    "cloudId":   string,
>    "updatedAt": number,          // timestamp
>  }
>
>```

<br/>

#### GET: /network/crownstones

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

#### POST: /network/refreshTopology

> `authorization required`
>
> Use this method to remove all data you can get from the GET:network/ endpoint. It will be rebuilt over time.
>

<br/>

#### GET: /network/statistics

> `authorization required`
>
> This gives an overview of the health of your mesh network. By comparing the received vs lost values, you can get a per node estimate of the reliability of the network.
> ```
> Return type:
>   { shortCrownstoneUid : LossStatistics }
> 
> LossStatistics:
>   {
>      "lastReset": number,      // timestamp. Since this time the statistics are being collected. Based on hub reboot usually.
>      "lastUpdate": number,     // timestamp. Last time the statistics were updated
>      "messageNumber": number,  // counter of incoming messages. This rotates between 0 and 255.
>      "received": number,       // amount of messages received
>      "lost": number            // amount of intermittent messages lost
>   }
>```

<br/>