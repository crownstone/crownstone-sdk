# SwitchController
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

