#!/usr/bin/env bash
domain="$1"

mx=$(dig +short MX "$domain" 2>/dev/null | awk '{print $2}')

if [ -z "$mx" ]; then
    echo "CAUTION|Cannot test DANE (no MX records)"
    exit 0
fi

found=""
missing=""

for host in $mx; do
    tlsa=$(dig +short TLSA "_25._tcp.$host" 2>/dev/null)
    if [ -n "$tlsa" ]; then
        found="$found $host"
    else
        missing="$missing $host"
    fi
done

found=$(echo "$found" | xargs)
missing=$(echo "$missing" | xargs)

# Case 1: At least one MX has TLSA → OK, but warn if others missing
if [ -n "$found" ]; then
    if [ -n "$missing" ]; then
        echo "CAUTION|TLSA present for: $found (missing for: $missing)"
        exit 0
    fi

    echo "OK|TLSA present for: $found"
    exit 0
fi

# Case 2: No MX has TLSA → DANE not enabled
echo "CAUTION|No TLSA records for any MX hosts (DANE not enabled)"
exit 0
