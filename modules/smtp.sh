#!/usr/bin/env bash
domain="$1"

mx=$(dig +short MX "$domain" 2>/dev/null | awk '{print $2}')

if [ -z "$mx" ]; then
    echo "CAUTION|Cannot test SMTP (no MX records)"
    exit 0
fi

# BRO checks: MX must not be CNAME, must have valid A/AAAA, must not be bogon
for host in $mx; do
    # CNAME check
    cname=$(dig +short CNAME "$host" 2>/dev/null)
    if [ -n "$cname" ]; then
        echo "BRO|MX host is a CNAME (illegal): $host -> $cname"
        exit 0
    fi

    # A/AAAA lookup
    a=$(dig +short A "$host" 2>/dev/null)
    aaaa=$(dig +short AAAA "$host" 2>/dev/null)

    if [ -z "$a" ] && [ -z "$aaaa" ]; then
        echo "BRO|MX host has no A/AAAA record: $host"
        exit 0
    fi

    # Bogon detection (IPv4)
    for ip in $a; do
        case "$ip" in
            10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*|127.*|169.254.*|192.0.2.*|198.51.100.*|203.0.113.*)
                echo "BRO|MX host resolves to bogon IPv4: $host -> $ip"
                exit 0
                ;;
        esac
    done

    # Bogon detection (IPv6)
    for ip6 in $aaaa; do
        case "$ip6" in
            ::1|fe80::*|fc??:*|fd??:*|ff??:*)
                echo "BRO|MX host resolves to bogon IPv6: $host -> $ip6"
                exit 0
                ;;
        esac
    done
done

# Normal SMTP reachability test
failed=""
total=0
failed_count=0

for host in $mx; do
    total=$((total+1))
    timeout 3 bash -c "echo > /dev/tcp/$host/25" 2>/dev/null
    if [ $? -ne 0 ]; then
        failed="$failed $host"
        failed_count=$((failed_count+1))
    fi
done

failed=$(echo "$failed" | xargs)

# All MX unreachable → likely ISP block
if [ "$failed_count" -eq "$total" ]; then
    echo "CAUTION|SMTP unreachable from this vantage point (ISP may block outbound port 25)"
    exit 0
fi

# Some MX unreachable → real issue
if [ -n "$failed" ]; then
    echo "DANGER|SMTP unreachable on: $failed"
    exit 0
fi

echo "OK|SMTP reachable on all MX hosts"
exit 0
