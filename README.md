# CoreDNS

[CoreDNS](https://coredns.io/) is a flexible DNS server with a plugin-based model.

This project provides custom builds mainly to enable full standalone resolution (ie without upstream recursors) using
the [Unbound plugin](https://coredns.io/explugins/unbound/).

You may find weekly updated binaries in the [package registry](https://gitlab.com/mangadex-pub/coredns/-/packages).

## Get started

```
docker run -it \
    -v /path/to/Corefile:/etc/coredns/Corefile:ro \
    -p "53:53/tcp" \
    -p "53:53/udp" \
    registry.gitlab.com/mangadex-pub/coredns:1.9-bullseye
    -conf /etc/coredns/Corefile
```

> While a default Corefile location or an envvar sounds great, sticking the official image's behaviour is just simpler in the end

## Unbound integration

Since the upstream support for Unbound seems half-abandoned (...), we're replacing it with [Cloudflare's fork of it](https://github.com/cloudflare/unbound).
