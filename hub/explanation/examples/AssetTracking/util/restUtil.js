const https  = require('https');
const config = require("../config");


module.exports = {
  post: function(path,data)   { return call_method("POST", path,data)},
  get: function(path,data)    {
    path = _appendToURL(path, data)
    return call_method("GET", path)},
  delete: function(path,data) {
    path = _appendToURL(path, data)
    return call_method("DELETE", path)
  },
  put: function(path,data)    { return call_method("PUT",    path, data)},
  patch: function(path,data)  { return call_method("PATCH",  path, data)},
}

function call_method(method, path, data) {
  return new Promise((resolve, reject) => {
    let stringifiedData = data;
    if (data && typeof data !== 'string') {
      stringifiedData = JSON.stringify(data);
    }

    let options = {
      host: config.HOST,
      port: config.PORT,
      path: path,
      method: method,
      rejectUnauthorized: false, // !IMPORTANT! This allows us to ignore the self-signed certificate.
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': stringifiedData ? stringifiedData.length : 0,
        'access_token': config.TOKEN,
      }
    };

    console.log(method, "Request to", options.host, options.port, path, data)
    const req = https.request(options, res => {
      console.log(`statusCode: ${res.statusCode}`, Date.now())
      let result = '';
      res.on('data', d => { result += d; });
      res.on('end', () => {
        let data = result;
        try {
          data = JSON.parse(data);
        }
        catch(err) {}

        resolve(data);
      });
    })

    req.on('error', error => {
      console.error(error)
    })


    if (data) {
      req.write(stringifiedData);
    }
    req.end()
  })
}


function _appendToURL(url, toAppend) {
  if (toAppend) {
    let appendString = '';
    if (typeof toAppend === 'object') {
      let keyArray = Object.keys(toAppend);
      for (let i = 0; i < keyArray.length; i++) {
        appendString += keyArray[i] + '=' + _htmlEncode(toAppend[keyArray[i]]);
        if (i != keyArray.length - 1) {
          appendString += '&';
        }
      }
    }
    else
      throw new Error('ERROR: cannot append anything except an object to an URL. Received: ' + toAppend);

    if (url.indexOf('?') === -1)
      url += '?';
    else if (url.substr(url.length - 1) !== '&')
      url += '&';

    url += appendString;
  }
  return url;
}

function _htmlEncode(str) {
  if (Array.isArray(str) || typeof str === 'object') {
    return encodeURIComponent(JSON.stringify(str));
  }
  else {
    return encodeURIComponent(str + '');
  }
}
