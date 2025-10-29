#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Builds a Hugo site hosted on a Cloudflare Worker.
#
# The Cloudflare Worker automatically installs Node.js dependencies.
#------------------------------------------------------------------------------

main() {

  DART_SASS_VERSION=1.93.2
  GO_VERSION=1.25.3
  HUGO_VERSION=0.152.2
  NODE_VERSION=22.20.0

  export TZ=Europe/Oslo





  # Install Hugo
  echo "Installing Hugo ${HUGO_VERSION}..."
  curl -sLJO "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  mkdir "${HOME}/.local/hugo"
  tar -C "${HOME}/.local/hugo" -xf "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  rm "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  export PATH="${HOME}/.local/hugo:${PATH}"



  # Verify installations
  echo "Verifying installations..."
  echo Go: "$(go version)"
  echo Hugo: "$(hugo version)"
  echo Node.js: "$(node --version)"

  # Configure Git
  echo "Configuring Git..."
  git config core.quotepath false
  if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    git fetch --unshallow
  fi

  # clone themnes
  echo "Clone Blowfish..."
  git submodule update --init --recursive
  git config core.quotepath false

  # Build the site
  echo "Building the site..."
  hugo --gc --minify

}

set -euo pipefail
main "$@"