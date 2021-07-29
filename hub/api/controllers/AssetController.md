# AssetController

Assets are Bluetooth beacons or wearables that broadcast reliably. The network of Crownstones can listen to the signals (which are called advertisements) from these
devices. From there, we can propagate the measured signal strengths to a hub or run analyses on them. This is a rather new functionality so more will be added in due time.

#### DELETE: /assets/all

> `authorization required`
>
> Delete all assets. Make sure you type YesImSure in the YesImSure field.

<br/>

#### POST: /assets/commit

> `authorization required`
>
> Calling this method will actually deploy any changes regarding assets to the mesh network. This allows you to make changes to multiple assets before they are 
> propaged onto the mesh network. This will be spread from Crownstone to Crownstone and can take a few minutes to reach every single one.

<br/>

#### PUT: /assets/{id}

> `authorization required`
>
> Update a specific asset. You provide the id of the asset to update as well as an Asset datamodel explained below. 
> Don't forget to call commit when you're done with all the changes to the assetController.

<br/>

#### GET: /assets/{id}

> `authorization required`
>
> Get the data of a specific asset.

<br/>

#### DELETE: /assets/{id}

> `authorization required`
>
> Delete a specific asset. Don't forget to call commit when you're done with all the changes to the assetController.

<br/>

#### POST: /assets
> `authorization required`
>
> Create a new asset. You have to provide the Asset datamodel as defined below.

<br/>

#### GET: /assets
> `authorization required`
>
> Get all registered assets.




## Datamodels

### Asset
```
// mandatory
{
    "inputData":            InputData
    "outputDescription":    OutputDescription
    "data":                 string              (details below)
}

// with optional fields
{
    "name":                 string              (optional)
    "description":          string              (optional)
    "type":                 string              (optional)
    "profileId":            number              (optional, details below)
    "exclude":              boolean             (optional, default: false, details below))
    "desiredFilterType":    string              (optional)
    "inputData":            InputData
    "outputDescription":    OutputDescription
    "data":                 string              (details below)
    "updatedAt":            string              (optional)
}
```

We will first explain the InputData and OutputDescription. Finally we will tell you about how the data should be formatted as well as more details on some of the fields.

### InputData

Input data described which part of the BLE advertisement is used to determine if this asset belongs to the group of things you'd like to follow.
This is an advanced feature, so if you're unsure about how BLE advertisements work, we suggest you look into that first.

You can define an asset by it's mac address, one of it's AD data fields (or part thereof) or it's manufacturer id. 
Technically the manufacturer id is also an AD field, but this is just a convenience option. If you use manufacturer id, the data can be Bluetooth SIG format

We'll first give the data type, followed by an example.

The input data format can be one of the following:
- #### FormatMacAddress
    - ```
      { type: "MAC_ADDRESS" }
      ```
- #### FormatFullAdData
    - ```
      { type: "FULL_AD_DATA", adType: number }
      ```
- #### FormatMaskedAdData
    - ```
      { type: "MASKED_AD_DATA", adType: number, mask: number }
      ```
- #### FilterInputManufacturerId
  - ```
    { type: "MANUFACTURER_ID" }
    ```


[Let's take an iBeacon as example.](https://en.wikipedia.org/wiki/IBeacon#BLE_Advertisement_Packet_Structure_Byte_Map)
The ibeacon payload falls under the manufacturer data AD type (0xff). Here is part of the packet:
```
 Byte 4: Type:               0xff (Custom Manufacturer Data)
 Byte 5-6: Manufacturer ID : 0x4c00 (Apple's Bluetooth SIG registered company code, 16-bit Little Endian)
 Byte 7: SubType:            0x02 (Apple's iBeacon type of Custom Manufacturer Data)
 Byte 8: SubType Length:     0x15 (Of the rest of the iBeacon data; UUID + Major + Minor + TXPower)
 Byte 9-24: Proximity UUID   (Random or Public/Registered UUID of the specific beacon)
 Byte 25-26: Major           (User-Defined value)
 Byte 27-28: Minor           (User-Defined value)
 Byte 29: TXPower            (8 bit Signed value, ranges from -128 to 127, use Two's Compliment to "convert" if necessary, Units: Measured Transmission Power in dBm @ 1 meters from beacon) (Set by user, not dynamic, can be used in conjunction with the received RSSI at a receiver to calculate rough distance to beacon)
```

To identify a set of assets to follow based on just the iBeacon UUID, we have to use an FormatMaskedAdData with adType: 0xff.
We now use the mask to only use the bytes containing the UUID.

The data we will work with based on the adType 0xff is:
```
byte:       adType | 0    | 1    | 2    | 3    | 4 ... 19         | 20 .. 21 | 22 ... 23 | 24
value:      0xff   | 0x00 | 0x4c | 0x02 | 0x15 | ...16 uuid bytes | major    | minor     | txpower
```

This is the data the mask will work on. The mask is a number with 32 bits (uint8). To include BYTE 0 in the identifiable part of the packet, we would set bit 0 (which corresponds to value 1) high.

This means a mask that will only look at the uuid of the iBeacon will look like this:
```
byte:       adType | 0    | 1    | 2    | 3    | 4 ... 19         | 20 , 21 | 22 , 23 | 24
value:      0xff   | 0x00 | 0x4c | 0x02 | 0x15 | ...16 uuid bytes | major   | minor   | txpower
bitindex:          | 0    | 1    | 2    | 3    | 4 ... 19         | 20 , 21 | 22 , 23 | 24      | ... 32
mask bit value:    | 0    | 0    | 0    | 0    | 1,1..,1          | 0,0     | 0,0     | 0       | ... 0
```
which leads to a numeric value of ```1048560```, or in hex ```0xffff0```. This is the value we will use for the mask. Any remaining bits that do not correspond to bytes in the payload are also set to 0.
```
{ type: "MASKED_AD_DATA", adType: 0xff, mask: 0xffff0 }
```

### OutputDescription

The output description defines how information about the asset(s) is relayed back to you.

The output description data format is one of the following:
- #### OutputDescription_mac_report
    - ```
      { type: "MAC_ADDRESS_REPORT" }
      ```
- #### OutputDescription_shortId_track
    - ```
      { type: "SHORT_ASSET_ID_TRACK", inputData: InputData }
      ```
    - NOT AVAILABLE YET!
    
If you choose OutputDescription_mac_report, a combination of mac address and rssi from each Crownstone that hears this asset will be relayed to the hub.
You can then choose the webhooks to forward this to an URL of your chosing.

If you choose OutputDescription_shortId_track, a 3 byte identifier describing an individual asset that adheres to your provided input data (in the ASSET model).
You can then use the inputData field in the OutputDescription_shortId_track object to determine which data this should be based on.

To illustrate, if you want to identify a set of Assets based on their iBeacon UUID like in our example, you may want to use the mac address, or major&minor of a scanned
iBeacon to identify it for the shortId.

This shortId will then be used by the Crownstone network localization algorithm. This is WIP and not finished.

## Explanation of specific fields

### data

So you have setup your inputData and outputDescription. How do you then tell the system which data to match with? This depends on the input data.
The format of this data is a byte for byte hexstring in the same order as it is in the BLE packet. The exception here is if you choose FilterInputManufacturerId. More on this below.

For each type of InputData, what you put into your data field is different.
- #### FormatMacAddress
    - data is a mac address hexstring like "e5bd18da2d2b"
- #### FormatFullAdData
    - data is a hexstring of all the bytes that are after the specified AD type. This has to be an exact match, nothing shorter or longer than the expected AD data to match against.
- #### FormatMaskedAdData
    - data is a hexstring of all the bytes for which your mask's bits are set to 1. In our example, you would provide an iBeacon uuid like: "d8b094e7569c4bc68637e11ce4221c18"
- #### FilterInputManufacturerId
    - data is a hexstring as listed in bluetooth sig. So in our example "4c00".


### profileId
If you provide a profileId, any scanned asset that adheres to the inputData will tell the Crownstone network that a certain profile is present in the sphere.
Currently only profile 0 is supported. This means that any Crownstone Behaviour that requires Sphere-level presence (If somebody is home...) will be enabled as long
as this asset is detected. If you do not want this, either set it to 255 or remove it from the datamodel. (WIP)

### exclude
It could be that you want to use a broad range for Input data (like an iBeacon UUID, or manufacturer ID) but want to exclude a few specific devices from the set. You define the specific Asset(s) you want to exclude by settings exclude to true.
