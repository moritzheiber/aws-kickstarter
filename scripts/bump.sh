#!/bin/bash

set -Eeu -o pipefail

PREVIOUS_VERSION=${1:-}
VERSION="${2:-}"

_check_versions() {
  if [ "x${VERSION}" == "x" ] || [ "x${PREVIOUS_VERSION}" == "x" ]; then
    echo "Missing version numbers"
    echo "${0} previous_version new_version"
    exit 1
  fi
}

_bump_version() {
  cd ../

  #shellcheck disable=SC2046
  sed -i "s/${PREVIOUS_VERSION//v}/${VERSION//v}/g" $(ag "${PREVIOUS_VERSION//v}" -l)
}

_check_versions
_bump_version
