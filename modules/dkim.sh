#!/usr/bin/env bash
domain="$1"

dkim=$(dig +short TXT "default._domainkey.$domain" 2>/dev/null)

if [ -z "$dkim" ]; then
    echo "CAUTION|No DKIM record found at default selector"
    exit 0
fi

dkim_one_line=$(echo "$dkim" | tr '\n' ' ')
echo "OK|DKIM record present at default selector"
exit 0
