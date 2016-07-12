# node-fips

> A Dockerfile and shell script to create a Ubuntu 16.04 image with a FIPS
compliant NodeJS build

### HOW TO BUILD
The Dockerfile uses the Ubuntu 16.04 base image, installs some packages needed
by the `fips.sh` script, add the `fips.sh` script and runs it. The script
takes care of the actual NodeJS and OpenSSL installation and FIPS configuration.
Use 'docker build' as you would with any other project:
```bash
docker build -t <username_here>/<reponame_here:<tag_here> .
```

**IMPORTANT:**
To build the Docker image you must have the `Dockerfile` and `fips.sh` script
in the same directory!
