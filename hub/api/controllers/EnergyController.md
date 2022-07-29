# EnergyController

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
> This is where you get the energy data. You provide the Crownstone short UID, a from and until ISO timestring, an interval between datapoints, and finally a maximum amount of datapoints to collect.
> The more datapoints you ask for, the longer the request could take. The interval is a string and the valid values are:
> ```
> '1m' | '5m' | '10m' | '15m' | '30m' | '1h' | '3h' | '6h' | '12h' | '1d' | '1w'
> ```
> This means an interval of '5m' gives you energy data with 5 minutes between datapoints.
> A timestring looks like this: "2020-09-28T15:34:30.703Z"
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
> Delete all energy data from this hub . You optionally provide a from and until ISO timestring.
> A timestring looks like this: "2020-09-28T15:34:30.703Z"

<br/>

#### DELETE: /energyFromCrownstone

> `admin authorization required`
>
> Delete all energy data for a specific Crownstone from this hub. You provide the Crownstone short UID and optionally a from and until ISO timestring.
> A timestring looks like this: "2020-09-28T15:34:30.703Z"

<br/>
