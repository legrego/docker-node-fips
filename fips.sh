#!/bin/bash -e

# Versions to build
opensslfips=$OPENSSL_FIPS_MODULE
opensslcore=$OPEN_SSL_CORE
nodejs=node-$NODE_VERSION

# Update Ubuntu packages and ensure build tools are installed
sudo apt-get -y update
sudo apt-get -y install build-essential python


# Create a working directory
cd "$(dirname $0)/.."
rm -rf dist
mkdir -p dist
cd dist


# Download source code packages
curl -s "https://www.openssl.org/source/$opensslfips.tar.gz" > "$opensslfips.tar.gz"
curl -s "https://www.openssl.org/source/$opensslcore.tar.gz" > "$opensslcore.tar.gz"
curl -s "https://nodejs.org/dist/${nodejs/node-/}/$nodejs.tar.gz" > "$nodejs.tar.gz"

# Verify packages downloaded successfully
echo "$(curl https://www.openssl.org/source/$opensslfips.tar.gz.sha256) $opensslfips.tar.gz" > openssl-checksums.sha256
echo "$(curl https://www.openssl.org/source/$opensslcore.tar.gz.sha256) $opensslcore.tar.gz" >> openssl-checksums.sha256
sha256sum -c openssl-checksums.sha256

# Unpack packages
tar xzvf "$opensslfips.tar.gz"
tar xzvf "$opensslcore.tar.gz"
tar xzvf "$nodejs.tar.gz"

# Build the FIPS module first
pushd "$opensslfips"
  ./config
  make
  sudo make install
popd

# Then build OpenSSL with FIPS support
pushd "$opensslcore"
  ./config fips shared
  make -j $(nproc)
  sudo make install
popd

# Finally build Node.js with FIPS support
pushd "$nodejs"
  ./configure --openssl-fips=/usr/local/ssl/fips-2.0
  make -j $(nproc)
  sudo make install
popd

# Make the built OpenSSL binary the default one for the system
sudo update-alternatives --force --install /usr/bin/openssl openssl /usr/local/ssl/bin/openssl 50

# Point the built OpenSSL's configuration at the system default (which is the one Node looks at)
sudo ln -f -s /etc/ssl/openssl.cnf /usr/local/ssl/openssl.cnf

# Enable global FIPS mode in that configuration. It's all FIPS, all the time!
sudo cat << 'EOF' > /etc/ssl/openssl.cnf
openssl_conf = openssl_conf_section

[openssl_conf_section]
alg_section = evp_settings

[evp_settings]
fips_mode = no
EOF
