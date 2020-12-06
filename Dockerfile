FROM alpine:3.10 AS builder
WORKDIR /workdir
RUN apk update && apk add --no-cache git==2.22.4-r0 autoconf==2.69-r2 automake==1.16.1-r0 libtool==2.4.6-r6 build-base==0.5-r1
RUN git clone https://github.com/stedolan/jq.git
WORKDIR /workdir/jq
RUN git submodule update --init && autoreconf -fi && ./configure --disable-docs --disable-maintainer-mode --with-oniguruma && make -j8 LDFLAGS=-all-static && strip jq

# hadolint ignore=DL3007
FROM busybox:latest
COPY --from=builder /workdir/jq/jq /bin/
RUN chmod 755 /bin/jq
USER nobody
ENTRYPOINT [ "/bin/jq" ]
