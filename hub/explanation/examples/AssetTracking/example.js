const util = require("./util/restUtil")
const assetUtil = require("./util/assetUtil");


/**
 * This makes sure the webhooks and assets are empty before executing so this script can be run over and over.
 */
async function run() {
  // clean up all webhooks that may exist from a previous invocation
  console.log("DeleteAllWebhooks:", JSON.stringify(await util.delete("/api/webhooks/all", { YesImSure:'YesImSure' })));

  // clean up all Assets that may exist from a previous invocation
  console.log("DeleteAllAssets:",   JSON.stringify(await util.delete("/api/assets/all",   { YesImSure:'YesImSure' })));

  // commit the changes to clean the filters.
  console.log("Committing...:",     JSON.stringify(await util.post(  "/api/assets/commit")));

  // create my my new asset either by manufacturer ID (bluetooth sig format)
  console.log("CreateAsset:",       JSON.stringify(await util.post(  "/api/assets/",            assetUtil.createAssetWithManuId("4c00"))));
  // ... or using masks
  // console.log("CreateAsset:",       JSON.stringify(await util.post(  "/api/assets/",            assetUtil.createAssetWithMasks("004c"))));

  // ... or by mac address
  // console.log("CreateAsset:",       JSON.stringify(await util.post(  "/api/assets/",            assetUtil.createAssetWithMacAddress("aa:bb:cc:dd:ee:ff"))));

  // print the results
  console.log("GetAssets:",         JSON.stringify(await util.get(   "/api/assets")));

  // commit the changes
  console.log("Committing...:",     JSON.stringify(await util.post(  "/api/assets/commit")));

  // create a webhook to use the incoming events.
  console.log("CreateWebhook:",     JSON.stringify(await util.post(  "/api/webhooks",           assetUtil.createWebhook())));
}

// Run the async example!
run()