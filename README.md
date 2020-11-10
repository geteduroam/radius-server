# geteduroam RADIUS server

A simple RADIUS server to get you started with geteduroam

## Requirements

* FreeBSD 12 or higher
* A CA to verify client certificates against
* Server certificate with chain and corresponding key (may be signed by a different CA)

## Instructions

* Copy `ca.pem`, `server.key` and `server.pem` to `raddb/certs`
* Run install.sh
