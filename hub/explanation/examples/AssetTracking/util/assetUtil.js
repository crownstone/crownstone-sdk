const config = require("../config");


/**
 * bits is an array of which bit positions should be 1
 * So for the first 2 bytes passing a mask:
 * bits = [0,1]
 * @param bits
 * @returns {number}
 */
function generateMask(bits) {
  let mask = 0;
  for (let bit of bits) {
    mask += 1 << bit;
  }
  return mask;
}

/**
 * Remember, all our hubs for blyott will call the AWS. AWS is free for 1e6 calls per month.
 * @returns {{endPoint: string, batchTimeSeconds: number, apiKey: string, clientSecret: string, compressed: boolean, event: string, apiKeyHeader: string}}
 */
function createWebhook() {
  let maxCallsPerMonth = 3e5;
  return {
    event:            "ASSET_REPORT",
    clientSecret:     "mySecret",
    endPoint:         config.WEBHOOK_ENDPOINT,
    compressed:       true,
    batchTimeSeconds: Math.ceil(maxCallsPerMonth / secondsPerMonth),
    apiKey:           config.WEBHOOK_API_KEY,
    apiKeyHeader:     "x-api-key"
  }
}


/**
 * The data here is the manufacturerId of the device you want to track.
 * Input the data in bluetoothSigformat, reversing it is done automatically
 * @param data
 */
function createAssetWithManuId(bluetoothSigFormat) {
  return {
    name: "my tracker",
    inputData: {
      type: "MANUFACTURER_ID",
    },
    outputDescription: {
      type: "MAC_ADDRESS_REPORT"
    },
    data: bluetoothSigFormat,
  }
}


/**
 * Create a filter that uses the manufacturer id, but is defined by the masked_ad_data input date type.
 * @param data
 */
function createAssetWithMasks(actualByteFormat) {
  return {
    name: "my tracker",
    inputData: {
      type: "MASKED_AD_DATA",
      adType: 0xff, // this is the manufacturer id adType
      mask: generateMask([0,1])
    },
    outputDescription: {
      type: "MAC_ADDRESS_REPORT"
    },
    data: actualByteFormat,  // this is the NOT reversed data. So cd09 instead of 09cd.
  }
}

/**
 * This defines an asset by it's macaddress.
 * Input the mac address in the same way you see it in the nordic app. The reversal is done automatically.
 * @param data
 */
function createAssetWithMacAddress(macAddress) {
  let strippedAddress = macAddress.replace(/:/g,'');
  return {
    name: "my tracker",
    inputData: {
      type: "MAC_ADDRESS",
    },
    outputDescription: {
      type: "MAC_ADDRESS_REPORT"
    },
    data: strippedAddress,
    exclude: false, // SET TO TRUE IF YOU WANT TO EXCLUDE THIS ASSET
  }
}

module.exports = {
  createWebhook,
  createAssetWithManuId,
  createAssetWithMasks,
  createAssetWithMacAddress

}