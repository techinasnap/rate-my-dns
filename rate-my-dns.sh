#!/usr/bin/env bash

# Clear screen only if running interactively
if [ -t 1 ]; then
    printf "\033[H\033[J"
fi

cat <<'EOF'
╔══════════════════════════════════════════════════╗
║                    RATE MY DNS                   ║
║                 Operator Edition                 ║
╚══════════════════════════════════════════════════╝
EOF

# Version line
VERSION="0.9.0"

# Colors (only if interactive)
if [ -t 1 ]; then
    RED="\033[31m"
    YELLOW="\033[33m"
    GREEN="\033[32m"
    BLUE="\033[36m"
    BOLD="\033[1m"
    RESET="\033[0m"
else
    RED=""; YELLOW=""; GREEN=""; BLUE=""; BOLD=""; RESET=""
fi

echo -e "${BLUE}Rate‑My‑DNS v${VERSION}${RESET}"
echo

# Startup animation
if [ -t 1 ]; then
    printf "Initializing"
    for i in 1 2 3; do
        sleep 0.1
        printf "."
    done
    printf "\n\n"
fi

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
