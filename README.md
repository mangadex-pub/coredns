# CoreDNS

[CoreDNS](https://coredns.io/) is a flexible DNS server with a plugin-based model.

This project provides custom builds mainly to enable full standalone resolution (ie without upstream recursors) using
the [Unbound plugin](https://coredns.io/explugins/unbound/).

You may find weekly updated binaries in the [package registry](https://gitlab.com/mangadex-pub/coredns/-/packages).

## Unbound integration

Since the upstream support for Unbound seems half-abandoned (...), we're replacing it with [Cloudflare's fork of it](https://github.com/cloudflare/unbound).
