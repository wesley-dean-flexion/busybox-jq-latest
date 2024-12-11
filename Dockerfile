FROM alpine:3.21.0 AS builder

# renovate: datasource=repology depName=alpine_3_17/git versioning=loose
ENV GIT_VERSION="2.47"

# renovate: datasource=repology depName=alpine_3_17/autoconf versioning=loose
ENV AUTOCONF_VERSION="2.72"

# renovate: datasource=repology depName=alpine_3_17/automake versioning=loose
ENV AUTOMAKE_VERSION="1.17"

# renovate: datasource=repology depName=alpine_3_17/libtool versioning=loose
ENV LIBTOOL_VERSION="2.4"

# renovate: datasource=repology depName=alpine_3_17/build-base versioning=loose
ENV BUILD_BASE_VERSION="0.5"

WORKDIR /workdir
RUN apk add \
  --no-cache \
  git=~"${GIT_VERSION}" \
  autoconf=~"${AUTOCONF_VERSION}" \
  automake=~"${AUTOMAKE_VERSION}" \
  libtool="~${LIBTOOL_VERSION}" \
  build-base=~"${BUILD_BASE_VERSION}" \
&& git clone https://github.com/stedolan/jq.git

WORKDIR /workdir/jq

RUN git submodule update --init \
  && autoreconf -fi \
  && ./configure --disable-docs --disable-maintainer-mode --with-oniguruma \
  && make -j8 LDFLAGS=-all-static \
  && strip jq

# hadolint ignore=DL3007
FROM busybox:1.37.0
COPY --from=builder /workdir/jq/jq /bin/
RUN chmod 755 /bin/jq
USER nobody
ENTRYPOINT [ "/bin/jq" ]
