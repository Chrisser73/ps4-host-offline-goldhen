#!/usr/bin/env sh
# Applies the versioned 14.00 selector overlay to a freshly cloned PSPulse host.
set -eu

host_dir=${1:-www}
selector="$host_dir/index.html"
route_file="scripts/afterglow-1400-route.html"

if [ ! -f "$selector" ]; then
    echo "Missing PSPulse selector: $selector" >&2
    exit 1
fi

if [ ! -f "$route_file" ]; then
    echo "Missing 14.00 route overlay: $route_file" >&2
    exit 1
fi

if grep -q 'href="1400/index.html"' "$selector"; then
    exit 0
fi

if ! grep -q '\[ <b>ok</b> \] 7 host routes detected' "$selector"; then
    echo "Unexpected PSPulse selector format; 14.00 route was not applied." >&2
    exit 1
fi

temporary_selector=$(mktemp "${selector}.XXXXXX")
trap 'rm -f "$temporary_selector"' EXIT HUP INT TERM

sed \
    -e 's/<span class="num">07<\//<span class="num">08<\//' \
    -e 's/<span class="num">06<\//<span class="num">07<\//' \
    -e 's/<span class="num">05<\//<span class="num">06<\//' \
    -e 's/<span class="num">04<\//<span class="num">05<\//' \
    -e 's/<span class="num">03<\//<span class="num">04<\//' \
    -e 's/<span class="num">02<\//<span class="num">03<\//' \
    -e 's/<span class="num">01<\//<span class="num">02<\//' \
    "$selector" > "${temporary_selector}.numbered"

awk -v route_file="$route_file" '
    /<nav class="grid">/ {
        print
        while ((getline route_line < route_file) > 0) print route_line
        close(route_file)
        next
    }
    { print }
' "${temporary_selector}.numbered" > "$temporary_selector"

sed 's/\[ <b>ok<\/b> \] 7 host routes detected/[ <b>ok<\/b> ] 8 host routes detected/' "$temporary_selector" > "${temporary_selector}.count"
mv "${temporary_selector}.count" "$selector"
