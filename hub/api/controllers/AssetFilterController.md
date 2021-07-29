# AssetFilterController

Based on the assets you have defined, the hub had generated filters and propagated these to the Crownstones. These filters
are shared by all Crownstones in the mesh. They define how they respond to certain BLE advertisements and how this data should be
brought back to you.


#### GET: /assetFilters/{id}
> `authorization required`
>
> Get a specific assetFilter.

<br/>

#### GET: /assetFilters
> `authorization required`
>
> Get all assetFilters deployed on the mesh.


These methods are purely used for the synchronization systems with the cloud. These are not meant to be used by "normal" users.