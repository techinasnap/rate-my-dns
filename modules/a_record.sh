#!/usr/bin/env bash
domain="$1"

a=$(dig +short A "$domain" 2>/dev/null)

if [ -z "$a" ]; then
    echo "CAUTION|No A record found for $domain"
    exit 0
fi

a_one_line=$(echo "$a" | tr '\n' ' ')
echo "OK|A record(s): $a_one_line"
exit 0
