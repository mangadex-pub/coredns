COREDNS_VERSION = 1.9.3
COREDNS_GITREF = v1.9.3
BUILD_VERSION_REPOSHA = $(shell git rev-parse --short HEAD)
COREDNS_BUILD_VERSION = mangadex-$(BUILD_VERSION_REPOSHA)

COREDNS_SOURCES = https://codeload.github.com/coredns/coredns/tar.gz/$(COREDNS_GITREF)
COREDNS_TARBALL = coredns-$(COREDNS_VERSION).tar.gz
COREDNS_BUILDIR = src
COREDNS_DIST = $(shell pwd)/coredns

all: build dist

$(COREDNS_TARBALL):
	curl -sfS -o "$(COREDNS_TARBALL)" "$(COREDNS_SOURCES)"

$(COREDNS_BUILDIR): $(COREDNS_TARBALL)
	@if ! [ -d "$(COREDNS_BUILDIR)" ]; then mkdir -v "$(COREDNS_BUILDIR)"; fi
	tar -C $(COREDNS_BUILDIR) --strip-components=1 -xf "$(COREDNS_TARBALL)"

# Would it have killed them to make go mod tidy --go=current or something? *eyeroll*
GOVER = $(shell go version | cut -d' ' -f3 | grep -o -E '1.[0-9]+')

.PHONY: build
build: $(COREDNS_BUILDIR)
	cd "$(COREDNS_BUILDIR)" && ! [ -f "coremain/version.go.orig" ] && mv -fv "coremain/version.go" "coremain/version.go.orig" || true
	cd "$(COREDNS_BUILDIR)" && sed 's/^\tCoreVersion.*/\tCoreVersion = "$(COREDNS_VERSION)-$(COREDNS_BUILD_VERSION)"/g' "coremain/version.go.orig" > "coremain/version.go"
	cd "$(COREDNS_BUILDIR)" && grep 'unbound' plugin.cfg || echo "unbound:github.com/mangadex-pub/coredns-plugin-unbound" >> plugin.cfg
	cd "$(COREDNS_BUILDIR)" && go mod tidy -go="$(GOVER)"
	$(MAKE) -C "$(COREDNS_BUILDIR)" CGO_ENABLED=1

.PHONY: dist
dist: build
	cp -v $(COREDNS_BUILDIR)/coredns $(COREDNS_DIST)
	ldd $(COREDNS_DIST)
	$(COREDNS_DIST) --version

clean:
	rm -fv "$(COREDNS_TARBALL)"
	rm -rfv "$(COREDNS_BUILDIR)"
	rm -fv "$(COREDNS_DIST)"
