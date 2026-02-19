#!/usr/bin/env bash
domain="$1"

# Try AXFR against each NS
ns=$(dig +short NS "$domain" 2>/dev/null)

if [ -z "$ns" ]; then
    echo "CAUTION|Cannot test AXFR (no NS records)"
    exit 0
fi

for server in $ns; do
    axfr=$(dig AXFR "$domain" @"$server" +short 2>/dev/null)
    if [ -n "$axfr" ]; then
        echo "BRO|Zone transfer OPEN on $server"
        exit 0
    fi
done

echo "OK|AXFR properly restricted"
exit 0
