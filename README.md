# geteduroam RADIUS server

A simple RADIUS server to get you started with geteduroam

## Requirements

* FreeBSD 12 or higher
* A CA to verify client certificates against
* Server certificate with chain and corresponding key for RADIUS
* Server certificate with chain and corresponding key for Radsec

## Instructions

* Copy RADIUS `ca.pem`, `server.key` and `server.pem` to `raddb/certs`
* Copy Radsec `ca.pem`, `server.key` and `server.pem` to `radsecproxy/certs`
* Run install.sh
