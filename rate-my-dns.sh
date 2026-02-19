#!/usr/bin/env bash

domain="$1"
total_score=0

score() {
    case "$1" in
        OK) total_score=$((total_score + 1)) ;;
        CAUTION) total_score=$((total_score + 0)) ;;
        DANGER) total_score=$((total_score - 1)) ;;
        BRO) total_score=$((total_score - 2)) ;;
    esac
}

for module in modules/*.sh; do
    output="$("$module" "$domain")"
    severity="${output%%|*}"
    message="${output#*|}"

    score "$severity"

    printf "%-8s %s\n" "$severity" "$message"
done

echo
echo "Final Score: $total_score"
