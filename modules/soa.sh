#!/usr/bin/env bash
domain="$1"

soa=$(dig +short SOA "$domain" 2>/dev/null)

if [ -z "$soa" ]; then
    echo "DANGER|No SOA record found for $domain"
    exit 0
fi

soa_one_line=$(echo "$soa" | tr '\n' ' ')
echo "OK|SOA record present: $soa_one_line"
exit 0
