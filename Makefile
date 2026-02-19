PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SHAREDIR = $(PREFIX)/share/rate-my-dns

install:
    mkdir -p $(BINDIR)
    mkdir -p $(SHAREDIR)/modules
    mkdir -p $(SHAREDIR)/lib
    cp rate-my-dns.sh $(BINDIR)/rate-my-dns
    chmod +x $(BINDIR)/rate-my-dns
    cp modules/*.sh $(SHAREDIR)/modules/
    cp lib/*.sh $(SHAREDIR)/lib/
    @echo "Installed to $(PREFIX)"

uninstall:
    rm -f $(BINDIR)/rate-my-dns
    rm -rf $(SHAREDIR)
    @echo "Uninstalled rate-my-dns"

run:
    ./rate-my-dns.sh $(DOMAIN)

lint:
    shellcheck rate-my-dns.sh modules/*.sh lib/*.sh

test:
    ./rate-my-dns.sh example.com

dist:
    tar czf rate-my-dns.tar.gz rate-my-dns.sh modules lib LICENSE README.md

clean:
    rm -f rate-my-dns.tar.gz
