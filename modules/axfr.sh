#!/usr/bin/env bash
domain="$1"

ns=$(dig +short NS "$domain" 2>/dev/null)

if [ -z "$ns" ]; then
    echo "CAUTION|Cannot test AXFR (no NS records)"
    exit 0
fi

for server in $ns; do
    # Only consider AXFR successful if the ANSWER section has multiple records
    answer=$(dig AXFR "$domain" @"$server" +noall +answer 2>/dev/null)

    # If the answer contains more than 1 line, AXFR succeeded
    count=$(echo "$answer" | wc -l)

    if [ "$count" -gt 1 ]; then
        echo "BRO|Zone transfer OPEN on $server"
        exit 0
    fi
done

echo "OK|AXFR properly restricted"
exit 0
