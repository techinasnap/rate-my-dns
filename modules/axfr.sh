#!/usr/bin/env bash
domain="$1"

ns=$(dig +short NS "$domain" 2>/dev/null)

if [ -z "$ns" ]; then
    echo "CAUTION|Cannot test AXFR (no NS records)"
    exit 0
fi

for server in $ns; do
    # Only look at the ANSWER section; if it's non-empty, AXFR succeeded
    answer=$(dig AXFR "$domain" @"$server" +noall +answer 2>/dev/null)

    if [ -n "$answer" ]; then
        echo "BRO|Zone transfer OPEN on $server"
        exit 0
    fi
done

echo "OK|AXFR properly restricted"
exit 0
