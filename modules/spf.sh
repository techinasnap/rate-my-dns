#!/usr/bin/env bash
domain="$1"

txt=$(dig +short TXT "$domain" 2>/dev/null | grep "v=spf1")

if [ -z "$txt" ]; then
    echo "CAUTION|No SPF record found"
    exit 0
fi

echo "OK|SPF record present"
exit 0
