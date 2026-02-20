<p align="center">
  <img src="assets/img/banner.png" alt="Rate My DNS Banner" width="600">
</p>

# Rate My DNS

A modular, dependency‑free DNS auditing framework for authoritative and recursive DNS servers. It evaluates DNSSEC, delegation, mail‑related records, and zone health using a Lynis‑style scoring model — designed for operators who need deterministic, local diagnostics.

Rate My DNS consolidates functionality normally spread across DNSViz, Hardenize, MXToolbox, Zonemaster, and various SPF/DKIM/DMARC validators, providing a single, consistent interface without SaaS dependencies or browser tooling.

---

## Why This Exists

I needed a DNS auditor that aligns with how systems operators and architects actually work.

Most tooling in this space focuses on DNS resolvers or whatever your router exposes. Rate My DNS is intentionally different: it audits DNS servers themselves — authoritative and recursive — where correctness, delegation, and security actually matter.

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

Rate My DNS currently uses dig for all DNS lookups, kdig support is planned for future releases.

- `bash`
- `dig`
- `openssl`
- `swaks` (optional for SMTP testing)
- `kdig` (from Knot DNS utils)

No npm. No Python virtualenvs. No Docker. No nonsense.

---

## Initial Setup

```bash
git clone https://github.com/techinasnap/rate-my-dns
cd rate-my-dns
chmod +x rate-my-dns.sh
```

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