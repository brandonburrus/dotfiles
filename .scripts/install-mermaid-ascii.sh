#!/bin/bash

set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="mermaid-ascii"
REPO="AlexanderGrooff/mermaid-ascii"

OS="$(uname)"
ARCH="$(uname -m)"

echo "Fetching latest release for ${OS}/${ARCH}..."

DOWNLOAD_URL=$(
  curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
    | grep "browser_download_url" \
    | grep "${BINARY_NAME}" \
    | grep "${OS}_${ARCH}" \
    | cut -d'"' -f4
)

if [[ -z "$DOWNLOAD_URL" ]]; then
  echo "Error: no release asset found for ${OS}_${ARCH}" >&2
  echo "Check available releases at https://github.com/${REPO}/releases" >&2
  exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

ARCHIVE="${TMPDIR}/${BINARY_NAME}.tar.gz"

echo "Downloading ${DOWNLOAD_URL}..."
curl -sL "$DOWNLOAD_URL" -o "$ARCHIVE"

echo "Extracting..."
tar -xzf "$ARCHIVE" -C "$TMPDIR"

mkdir -p "$INSTALL_DIR"
mv "${TMPDIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

echo "${BINARY_NAME} installed to ${INSTALL_DIR}/${BINARY_NAME}"

if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
  echo ""
  echo "Note: ${INSTALL_DIR} is not in your PATH."
  echo "Add the following to your shell config (~/.zshrc, ~/.bashrc, etc.):"
  echo ""
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
