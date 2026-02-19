#!/usr/bin/env bash
domain="$1"

# Basic NS lookup
ns=$(dig +short NS "$domain" 2>/dev/null)

if [ -z "$ns" ]; then
    echo "DANGER|No NS records found for $domain"
    exit 0
fi

echo "OK|Found NS records: $ns"
exit 0
