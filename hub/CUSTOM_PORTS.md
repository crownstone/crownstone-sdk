# Using custom ports

By default, the Crownstone hub uses port 80 for the HTTP interface, and port 443 for the HTTPS interface.

If you use the hub snap for a different purpose than the normal Crownstone usecase, you may want to change these ports to fit your setup.

You can override them by creating a config file at the CS_HUB_CONFIG_PATH location. By default this location is here:
```
/var/snap/crownstone-hub/common/config/
```

You have to create a file called ```port_config.json``` in the config folder defined above.

The contents of this file are:

```
{
  "httpPort":   80,
  "enableHttp": false,
  "httpsPort":  443
}
```

You can choose to disable the http part of the hub completely if you're only using the REST interface by setting enableHttp to false. If this is false, the httpPort is ignored.

The httpPort defines the port used by the unsecured HTTP server, and the httpsPort defines the port used by the self-certified HTTPS server.

The self-certification will give users a warning on a browser, which they will have to bypass to get to the website. You can't certify a server on a local network without domain.