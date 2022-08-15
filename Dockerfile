ARG DEBIAN_CODENAME=bullseye
FROM debian:${DEBIAN_CODENAME}-slim

RUN apt -q update && \
    apt -qq -y full-upgrade && \
    apt -qq -y autoremove && \
    apt -qq -y --no-install-recommends install \
      ca-certificates \
      dnsutils \
      libunbound8 && \
    update-ca-certificates && \
    apt -qq -y --purge autoremove && \
    apt -qq -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /var/log/*

ADD coredns /bin/coredns

RUN groupadd -r -g 999 mangadex && useradd -u 999 -r -g 999 mangadex
USER mangadex
WORKDIR /tmp

RUN /bin/coredns --version
CMD ["/bin/coredns"]
