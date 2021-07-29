# Crownstone-Hub REST

Welcome to the REST endpoint documentation! Our endpoints are split up into a few "Controllers".

You can find your REST interface here:
```
https://<ip-of-your-hub>/api/
```

You can also explore the endpoints from your browser here:
```
https://<ip-of-your-hub>/api/explorer 
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

- admin authorization required
  - this means you have to be an admin in your sphere.
- authorization required        
  - this means you have to be an admin or member in your sphere.
- no authorization required     
  - anyone can access this.


# Controllers

- #### [HubController](./controllers/HubController.md)
  - This controller is responsible for configuring your hub. This is usually done via the Crownstone consumer app. 
- #### [MeshController](./controllers/MeshController.md)
  - Information on the mesh.
- #### [EnergyController](./controllers/EnergyController.md)
  - Everything regarding the collected energy data.
- #### [SwitchController](./controllers/SwitchController.md)
  - Switching and dimming the Crownstones in your network.
- #### [AssetController](./controllers/AssetController.md)
  - Setting up tracking assets or BLE wearables.
- #### [AssetFilterController](./controllers/AssetFilterController.md)
  - Information on the filters that are deployed on the mesh. This is for advanced usage only.
- #### [WebhookController](./controllers/WebhookController.md)
  - Forward certain events from the hub to an external URL.


