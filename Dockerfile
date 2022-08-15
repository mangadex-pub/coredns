ARG DEBIAN_CODENAME=bullseye
FROM debian:${DEBIAN_CODENAME}-slim

RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install ca-certificates && update-ca-certificates

RUN apt -q update && \
    apt -qq -y full-upgrade && \
    apt -qq -y autoremove && \
    apt -qq -y --no-install-recommends install \
      ca-certificates \
      dnsutils \
      libunbound8 && \
    apt -qq -y --purge autoremove && \
    apt -qq -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /var/log/*

ADD docker-entrypoint.sh /bin/docker-entrypoint.sh
ADD coredns              /bin/coredns

RUN groupadd -r -g 999 mangadex && \
    useradd -u 999 -r -g 999 mangadex
USER mangadex
WORKDIR /tmp

RUN /bin/coredns --version

CMD ["/bin/docker-entrypoint.sh"]
