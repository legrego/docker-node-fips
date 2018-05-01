# node-fips

> A Dockerfile and helper script to create an Ubuntu 16.04 image with a FIPS
compliant 8.11.0 NodeJS build.

## Overview
To build the Docker image you must have the `Dockerfile` and `fips.sh` script
in the same directory!
The Dockerfile uses a Ubuntu 16.04 base image, installs some packages needed
by the _fips.sh_ script, adds the _fips.sh_ script and runs it. The script
takes care of the actual NodeJS and OpenSSL installation and FIPS configuration.

* Node: `v8.11.0`
* OpenSSL: `openssl-1.0.2h`
* OpenSSL FIPS Module: `openssl-fips-2.0.12`

## Running FIPS Enabled Container
OpenSSL FIPS mode is OFF by default. It can be turned on by either setting
the environment variable:
```
docker run -it -e "OPENSSL_FIPS=1" --name gcosta/node-fips /bin/bash
```
OR editing `/etc/ssl/openssl.cnf` and enabling FIPS mode once in the container:
```
fips_mode = yes
```
