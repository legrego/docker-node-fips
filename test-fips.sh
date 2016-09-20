#!/bin/bash -e

# Try to use a disallowed function to prove the system OpenSSL is doing FIPS properly
export OPENSSL_FIPS=1
if openssl md5 &> /dev/null
then
  echo "OpenSSL did not disallow FIPS unapproved functions"
  exit -1
else
  echo "OpenSSL FIPS looks good"
fi

# Ditto with Node.js
if node --enable-fips -e "require('crypto').createHash('md5').update('')" &> /dev/null
then
  echo "Node.js did not disallow FIPS unapproved functions"
  exit -1
else
  echo "Node.js FIPS mode looks good"
fi
unset OPENSSL_FIPS
