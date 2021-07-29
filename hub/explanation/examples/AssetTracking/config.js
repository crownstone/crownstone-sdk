// GET THIS KEY FROM /users/id/keysv2
let sphereAuthorizationToken = "<MySphereAuthorizationToken>";

// set this to the ip of the hub you want to configure.
const HOST = '<hubIp>';
const PORT = 443;

// this is the endpoint which will be invoked by the webhook system.
const WEBHOOK_ENDPOINT = "http://localhost:5000"

const WEBHOOK_API_KEY = '<myApiKey>';


module.exports = {
  TOKEN: sphereAuthorizationToken,
  HOST,
  PORT,
  WEBHOOK_ENDPOINT,
  WEBHOOK_API_KEY,
}