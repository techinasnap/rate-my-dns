<p align="center">
  <img src="assets/img/banner.png" alt="Rate My DNS Banner" width="600">
</p>

# Rate My DNS

A modular, dependency‑free DNS auditing framework that evaluates DNSSEC, delegation, mail security, and zone health with Lynis‑style scoring. Designed for operators who prefer real diagnostics over web forms.

Rate My DNS consolidates checks normally scattered across tools like DNSViz, Hardenize, MXToolbox, Zonemaster, and various DANE/SPF/DMARC validators — but runs locally, fast, and without SaaS rate limits or 400MB of JavaScript.

---

## Why This Exists

I needed a DNS auditor that aligns with how systems operators and architects actually work.

With production responsibilities — and a homelab that serves as my proving ground — I move between jump hosts, Proxmox clusters, cloud VMs, and the occasional Raspberry Pi that happens to be closest to the problem. Modern DNS diagnostics are scattered across numerous web tools: MXToolbox, DNSViz, Hardenize, Zonemaster, and a long tail of SPF/DKIM/DMARC validators. None of them integrate cleanly into terminal workflows, automation pipelines, or SSH‑only environments.

From an architectural perspective, I wanted something portable, predictable, and platform‑agnostic. A tool that behaves consistently across macOS, Linux, WSL, ephemeral cloud instances, or a rescue shell at 3 AM. No browser dependencies, no JavaScript payloads, no SaaS rate limits — just deterministic, local diagnostics.

Rate My DNS is the tool I kept wishing existed: a single, operator‑grade DNS auditor that runs locally, speaks Bash, and provides clear, actionable signal without ceremony. It’s built for the people who have been up at 4 AM troubleshooting DNS in the dark, so others don’t have to be.

## Features

- **DNSSEC validation**
- **Delegation and glue checks**
- **Zone serial and secondary sync verification**
- **TLSA/DANE validation**
- **SMTP STARTTLS certificate checks**
- **SPF, DKIM, and DMARC linting**
- **EDNS and TCP fallback testing**
- **IPv6 reachability**
- **Reverse DNS sanity checks**
- **Lynis‑style scoring:**  
```
[ OK ] [ CAUTION ] [ DANGER ] [ BRO ]
```
All modules are standalone Bash scripts, making the tool easy to extend and customize.

---

## Project Structure
```
rate-my-dns/
├── rate-my-dns.sh        # main executable
├── modules/              # individual checks
│   ├── dnssec.sh
│   ├── delegation.sh
│   ├── glue.sh
│   ├── tlsa.sh
│   ├── smtp.sh
│   ├── spf.sh
│   ├── dmarc.sh
│   ├── dkim.sh
│   ├── reverse.sh
│   ├── edns.sh
│   ├── tcp-fallback.sh
│   ├── ipv6.sh
│   └── zone-serial.sh
├── lib/                  # shared functions
│   ├── output.sh         # [OK] [CAUTION] [DANGER] [BRO]
│   ├── dns.sh            # wrappers for kdig/dig
│   └── util.sh           # helpers
├── .gitignore
├── LICENSE               # MIT
└── README.md
```
---

## Requirements

- Bash
- `kdig` (from Knot DNS utils)
- `dig` (optional fallback)
- `openssl`
- `swaks` (optional for SMTP testing)

No npm. No Python virtualenvs. No Docker. No nonsense.

---

## Usage

```bash
./rate-my-dns.sh example.com
```

***Modules run automatically and produce a Lynis‑style report.***

Example output:

```
[ OK ] DNSSEC chain validated (example.com)
[ OK ] Glue records consistent across all NS
[ CAUTION ] SPF uses softfail (~all)
[ DANGER ] DKIM key length < 2048 bits
[ BRO ] TCP fallback failed on ns3.example.com
```
---
## Installation (optional)

A Makefile is included for convenience:

```
sudo make install
```

This installs:

- rate-my-dns → /usr/local/bin
- modules → /usr/local/share/rate-my-dns/modules
- lib → /usr/local/share/rate-my-dns/lib

Uninstall:

```
sudo make uninstall
```