#!/usr/bin/env bash
domain="$1"

mx=$(dig +short MX "$domain" 2>/dev/null | awk '{print $2}')

if [ -z "$mx" ]; then
    echo "CAUTION|Cannot test SMTP (no MX records)"
    exit 0
fi

for host in $mx; do
    timeout 3 bash -c "echo > /dev/tcp/$host/25" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "DANGER|SMTP unreachable on $host:25"
        exit 0
    fi
done

echo "OK|SMTP reachable on all MX hosts"
exit 0
