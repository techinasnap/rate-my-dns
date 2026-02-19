#!/usr/bin/env bash
domain="$1"

dnskey=$(dig +short DNSKEY "$domain" 2>/dev/null)

if [ -z "$dnskey" ]; then
    echo "CAUTION|No DNSSEC DNSKEY records found"
    exit 0
fi

echo "OK|DNSSEC DNSKEY records present"
exit 0
