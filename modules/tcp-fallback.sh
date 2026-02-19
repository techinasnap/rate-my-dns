#!/usr/bin/env bash
domain="$1"

tcp=$(dig +tcp +short A "$domain" 2>/dev/null)

if [ -z "$tcp" ]; then
    echo "DANGER|TCP fallback failed for $domain"
    exit 0
fi

echo "OK|TCP fallback working"
exit 0
