#!/usr/bin/env sh
# Adds this host's direct GoldHEN entry point to a freshly fetched Afterglow tree.
set -eu

host_dir=${1:-www/1400}
entry_file="scripts/afterglow-goldhen-entry.html"
guard_file="$host_dir/jb.js"
manifest_builder="$host_dir/make-manifest.sh"

for file in "$entry_file" "$guard_file" "$manifest_builder"; do
    if [ ! -f "$file" ]; then
        echo "Missing Afterglow integration file: $file" >&2
        exit 1
    fi
done

cp "$entry_file" "$host_dir/index.html"
cp "$entry_file" "$host_dir/goldhen.html"

if ! grep -q 'file === "goldhen.html"' "$guard_file"; then
    if ! grep -q 'file === "" || file === "index.html"' "$guard_file"; then
        echo "Unexpected Afterglow referrer guard; direct entry was not enabled." >&2
        exit 1
    fi
    sed -i 's/file === "" || file === "index.html"/file === "" || file === "index.html" || file === "goldhen.html"/' "$guard_file"
fi

if ! grep -q 'goldhen.html' "$manifest_builder"; then
    sed -i 's/FILES="index.html jb.html/FILES="index.html goldhen.html jb.html/' "$manifest_builder"
fi

(cd "$host_dir" && sh ./make-manifest.sh)
