#!/usr/bin/env bash
domain="$1"

aaaa=$(dig +short AAAA "$domain" 2>/dev/null)

if [ -z "$aaaa" ]; then
    echo "CAUTION|No IPv6 AAAA record for $domain"
    exit 0
fi

# Try a DNS query over IPv6 TCP
ipv6test=$(dig +tcp -6 A "$domain" 2>/dev/null)

if [ -z "$ipv6test" ]; then
    echo "DANGER|IPv6 present but unreachable"
    exit 0
fi

echo "OK|IPv6 reachable"
exit 0
