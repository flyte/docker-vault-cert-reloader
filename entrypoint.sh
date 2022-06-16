#!/bin/sh

set -e

cert_path="$1"
if [ "$cert_path" = "" ]; then
  echo "Must include path to cert as first argument"
  exit 1
fi

set -u

cert_hash="$(sha256sum $cert_path | awk '{ print $1 }')"
echo "$(date -u) - Current checksum '$cert_hash'"

inotifywait -q -m "$cert_path" |
  while read -r path action file; do
    new_cert_hash="$(sha256sum $cert_path | awk '{ print $1 }')"
    if [ "$cert_hash" != "$new_cert_hash" ]; then
      echo "$(date -u) - New checksum '$new_cert_hash'"
      cert_hash="$new_cert_hash"
      echo "$(date -u) - Sending SIGHUP signal to Vault"
      killall -SIGHUP "vault"
    fi
  done
