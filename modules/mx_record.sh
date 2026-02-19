#!/usr/bin/env bash
domain="$1"

mx=$(dig +short MX "$domain" 2>/dev/null)

if [ -z "$mx" ]; then
    echo "CAUTION|No MX records found for $domain"
    exit 0
fi

mx_one_line=$(echo "$mx" | tr '\n' ' ')
echo "OK|MX record(s): $mx_one_line"
exit 0
