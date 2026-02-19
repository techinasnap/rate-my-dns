#!/usr/bin/env bash
domain="$1"

edns=$(dig +short +edns=0 A "$domain" 2>/dev/null)

if [ -z "$edns" ]; then
    echo "CAUTION|EDNS not supported or no response"
    exit 0
fi

echo "OK|EDNS supported"
exit 0
