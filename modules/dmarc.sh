#!/usr/bin/env bash
domain="$1"

dmarc=$(dig +short TXT "_dmarc.$domain" 2>/dev/null | grep -i "v=dmarc1")

if [ -z "$dmarc" ]; then
    echo "CAUTION|No DMARC record found"
    exit 0
fi

dmarc_one_line=$(echo "$dmarc" | tr '\n' ' ')
echo "OK|DMARC record present: $dmarc_one_line"
exit 0
