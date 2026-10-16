#!/bin/sh
# Puts your app's Client ID into shopify.app.toml (the only line you need to change).
#
#   ./set-client-id.sh <Client ID>
#   sh set-client-id.sh <Client ID>       (if the first form says "permission denied")
#
# The Client ID is in the Shopify Dev Dashboard: your "Rotation Feed" app > Settings > Credentials.
# It is 32 characters, only 0-9 and a-f. Do NOT paste the Client secret here.
# Works on macOS and Linux (POSIX sh). On Windows, see README.md ("Windows").
set -eu

dir=$(cd "$(dirname "$0")" && pwd)
file="$dir/shopify.app.toml"

if [ "$#" -ne 1 ]; then
  echo "Usage: ./set-client-id.sh <Client ID>" >&2
  echo "Find the Client ID in the Shopify Dev Dashboard: your app > Settings > Credentials." >&2
  exit 2
fi

# trim spaces/quotes a copy-paste may bring along, then lower-case
id=$(printf '%s' "$1" | tr -d ' \t\r\n"'"'" | tr 'ABCDEF' 'abcdef')

case "$id" in
  *[!0-9a-f]* | "")
    echo "That does not look like a Client ID: it may only contain 0-9 and a-f." >&2
    echo "Copy the Client ID (not the Client secret) from Dev Dashboard > your app > Settings > Credentials." >&2
    exit 1 ;;
esac
if [ "${#id}" -ne 32 ]; then
  echo "That does not look like a Client ID: it has ${#id} characters, a Client ID has 32." >&2
  echo "Copy the Client ID (not the Client secret) from Dev Dashboard > your app > Settings > Credentials." >&2
  exit 1
fi

if [ ! -f "$file" ]; then
  echo "Cannot find $file. Run this script from the downloaded rotation-feed-partner-app folder." >&2
  exit 1
fi
if ! grep -q '^client_id = ' "$file"; then
  echo "Cannot find the client_id line in shopify.app.toml. Download the folder again and retry." >&2
  exit 1
fi

# portable in-place edit (no sed -i: it differs between macOS and Linux)
tmp="$file.tmp.$$"
sed "s/^client_id = .*/client_id = \"$id\"/" "$file" > "$tmp"
mv "$tmp" "$file"

echo "Done: shopify.app.toml now uses Client ID $id"
echo
echo "Next steps (README.md, step D):"
echo "  1. shopify auth login"
echo "  2. shopify app deploy        (answer Yes to release the new version)"
