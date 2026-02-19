#!/usr/bin/env bash
domain="$1"

aaaa=$(dig +short AAAA "$domain" 2>/dev/null)

if [ -z "$aaaa" ]; then
    echo "CAUTION|No AAAA record found for $domain"
    exit 0
fi

aaaa_one_line=$(echo "$aaaa" | tr '\n' ' ')
echo "OK|AAAA record(s): $aaaa_one_line"
exit 0
