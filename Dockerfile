FROM alpine:latest
WORKDIR /workdir
RUN apk update && apk add git autoconf automake libtool build-base
RUN git clone https://github.com/stedolan/jq.git && cd jq && git submodule update --init && autoreconf -fi && ./configure --disable-docs --disable-maintainer-mode --with-oniguruma && make -j8 LDFLAGS=-all-static && strip jq 

FROM busybox:latest
COPY --from=0 /workdir/jq/jq /bin/
RUN chmod 755 /bin/jq
USER nobody
ENTRYPOINT [ "/bin/jq" ]
