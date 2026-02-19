#!/usr/bin/env bash
domain="$1"

tlsa=$(dig +short TLSA "_25._tcp.$domain" 2>/dev/null)

if [ -z "$tlsa" ]; then
    echo "CAUTION|No TLSA record for SMTP DANE"
    exit 0
fi

tlsa_one_line=$(echo "$tlsa" | tr '\n' ' ')
echo "OK|TLSA record present: $tlsa_one_line"
exit 0
