#!/usr/bin/env bash
set -euo pipefail

# Keep the publishing toolchain pinned; computation results live in _freeze.
quarto_version=1.11.9
quarto_sha256=9d037baa3b38ffac7217edca1d2e53760b0fab4d5749220740a32056e03a1530
quarto_tmp=$(mktemp -d)
trap 'rm -rf "$quarto_tmp"' EXIT
curl --fail --location --retry 3 \
  "https://github.com/quarto-dev/quarto-cli/releases/download/v${quarto_version}/quarto-${quarto_version}-linux-amd64.tar.gz" \
  --output "$quarto_tmp/quarto.tar.gz"
echo "$quarto_sha256  $quarto_tmp/quarto.tar.gz" | sha256sum --check
tar -xzf "$quarto_tmp/quarto.tar.gz" -C "$quarto_tmp"
"$quarto_tmp/quarto-${quarto_version}/bin/quarto" render
