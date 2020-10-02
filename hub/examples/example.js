const https = require('https');
// fill in your own data here:
let sphereAuthorizationToken = "6b44e2e961724a3528fedefa360291ce9b30441b663906a9fdae8159c8592414";
let ipAddress = "10.0.1.176";


// configure the request
const options = {
  method: 'GET',
  rejectUnauthorized: false // !IMPORTANT! This allows us to ignore the self-signed certificate.
}

const req = https.request(`https://${ipAddress}:5050/api/energyAvailability?access_token=${sphereAuthorizationToken}`, options, (res) => {
  console.log('statusCode:', res.statusCode);
  res.on('data', (d) => {
    let str = d.toString('utf8')
    console.log(JSON.stringify(JSON.parse(str), undefined, 2))
  });
});

req.end();