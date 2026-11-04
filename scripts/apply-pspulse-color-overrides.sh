#!/usr/bin/env sh
# Keeps the repository's selected PSPulse color overrides when CI fetches upstream.
set -eu

host_dir=${1:-www}
root_selector="$host_dir/index.html"

if [ ! -f "$root_selector" ]; then
    echo "Missing PSPulse selector: $root_selector" >&2
    exit 1
fi

find "$host_dir" -type f \( -name '*.html' -o -name '*.css' \) -exec sed -i 's/#a294ff/#94d4ff/g' {} +

if ! grep -qF -- '--accent-dim: #195bb8;' "$root_selector"; then
    sed -i '/--accent: #94d4ff;/a\            --accent-dim: #195bb8;' "$root_selector"
fi
