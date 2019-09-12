#!/usr/bin/env make

DOCKER_TAG ?= busybox-jq

tag ?= $(shell if [ ! "${DOCKER_USERNAME}" = "" ] ; then echo -n "${DOCKER_USERNAME}/" ; fi ; echo "${DOCKER_TAG}")

.DEFAULT: all
.PHONY: all image clean

all: image

image: context busybox context/jq context/jq_version.txt context/busybox_version.txt context/Dockerfile
	cd context && docker build  --label jq_version="$(shell cat context/jq_version.txt)" --label busybox_version="$(shell cat context/busybox_version.txt)" --label build_datetime="$(shell date +%Y%m%d-%H%M%S)"  -t $(tag) . && cd ..

context/jq_version.txt: context context/jq
	context/jq --version > context/jq_version.txt

jq/jq:
	git submodule update --init && cd jq && git submodule update --init && git checkout -f tags/`git tag -l | grep -Ev '[0-9]rc' | tail -1` && autoreconf -fi && ./configure --disable-docs --disable-maintainer-mode && make -j8 LDFLAGS=-all-static && strip jq && cp jq ../context/ && cd ..

busybox:
	if docker pull busybox | grep -qi downloaded ; then make context/busybox_version.txt ; fi

context/busybox_version.txt: context busybox
	docker run --rm -i busybox busybox --help | sed -nre 's/^BusyBox v([a-z0-9.-]*).*/\1/gip' > context/busybox_version.txt

context/jq: context jq/jq
	cp jq/jq context/jq

context/Dockerfile: Dockerfile context
	cp Dockerfile context/

context:
	mkdir context

test: image
	echo '{ "hello":"world" }' | docker run $(tag) .

clean:
	docker image rmi $(tag) ; rm -rf context ; ( cd jq && make clean ) ; cd .. && find . -name "*~" -delete

distclean: clean
	cd jq && make distclean ; cd ..

