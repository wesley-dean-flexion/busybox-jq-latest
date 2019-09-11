#!/usr/bin/env make

tag ?= busybox-jq-latest

.DEFAULT: all
.PHONY: all image clean

all: image

image: context/jq context/Dockerfile
	cd context && docker build -t $(tag) . && cd ..

jq/jq:
	cd jq && git submodule update --init && autoreconf -fi && ./configure --disable-docs --disable-maintainer-mode && make -j8 LDFLAGS=-all-static && strip jq && cp jq ../context/ && cd ..

context/jq: context jq/jq
	cp jq/jq context/jq

context/Dockerfile: context Dockerfile
	cp Dockerfile context/

context:
	mkdir context

test: image
	echo '{}' | docker run -i --rm $(tag) 

clean:
	docker image rmi $(tag) ; rm -rf context ; ( cd jq && make clean ) ; cd .. && find . -name "*~" -delete 

distclean: clean
	cd jq && make distclean ; cd ..

