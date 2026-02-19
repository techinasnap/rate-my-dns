#!/usr/bin/env bash
domain="$1"

ips=$(dig +short A "$domain" 2>/dev/null; dig +short AAAA "$domain" 2>/dev/null)

if [ -z "$ips" ]; then
    echo "CAUTION|No A/AAAA records to test PTR"
    exit 0
fi

for ip in $ips; do
    ptr=$(dig +short -x "$ip" 2>/dev/null)
    if [ -z "$ptr" ]; then
        echo "CAUTION|No PTR record for $ip"
        exit 0
    fi
done

echo "OK|PTR records present"
exit 0
