#!/usr/bin/env bash
domain="$1"

ns=$(dig +short NS "$domain" 2>/dev/null)

if [ -z "$ns" ]; then
    echo "CAUTION|Cannot test glue (no NS records)"
    exit 0
fi

for server in $ns; do
    glue=$(dig +short A "$server" 2>/dev/null)
    glue6=$(dig +short AAAA "$server" 2>/dev/null)

    if [ -z "$glue" ] && [ -z "$glue6" ]; then
        echo "DANGER|Missing glue for $server"
        exit 0
    fi
done

echo "OK|Glue records present for all NS"
exit 0
