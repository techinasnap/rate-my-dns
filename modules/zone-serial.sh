#!/usr/bin/env bash
domain="$1"

ns=$(dig +short NS "$domain" 2>/dev/null)

if [ -z "$ns" ]; then
    echo "DANGER|No NS records found, cannot check serials"
    exit 0
fi

serials=""
for server in $ns; do
    soa=$(dig +short SOA "$domain" @"$server" 2>/dev/null)
    if [ -z "$soa" ]; then
        echo "DANGER|No SOA response from $server"
        exit 0
    fi

    serial=$(echo "$soa" | awk '{print $3}')
    serials="$serials $serial"
done

# Normalize whitespace
serials=$(echo "$serials" | xargs)

# Count unique serials
unique=$(echo "$serials" | tr ' ' '\n' | sort -u | wc -l)

if [ "$unique" -eq 1 ]; then
    echo "OK|SOA serials match across all NS: $serials"
    exit 0
fi

echo "DANGER|SOA serial mismatch across NS: $serials"
exit 0
