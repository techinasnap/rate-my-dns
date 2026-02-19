#!/usr/bin/env bash
domain="$1"

ns=$(dig +short NS "$domain" 2>/dev/null)

if [ -z "$ns" ]; then
    echo "CAUTION|Cannot test AXFR (no NS records)"
    exit 0
fi

open_ns=""

for server in $ns; do
    # Only consider AXFR successful if the ANSWER section has multiple records
    answer=$(dig AXFR "$domain" @"$server" +noall +answer 2>/dev/null)
    count=$(echo "$answer" | wc -l)

    if [ "$count" -gt 1 ]; then
        open_ns="$open_ns $server"
    fi
done

# Trim whitespace
open_ns=$(echo "$open_ns" | xargs)

if [ -n "$open_ns" ]; then
    echo "BRO|Zone transfer OPEN on: $open_ns"
    exit 0
fi

echo "OK|AXFR properly restricted"
exit 0
