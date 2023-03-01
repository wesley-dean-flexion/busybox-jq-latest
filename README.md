# busybox-jq-latest

## What this is

This is a daily-built (via cron job) of the latest and greatest BusyBox with JQ.

## How to use this

The 'jq' binary is set as the entrypoint for the image, so it can be run by piping
JSON content to Docker Run:

```sh
cat file.json | docker run -it --rm wesleydeanflexion/busybox-jq '.'
```

Alternatively, I've included a script, 'busybox-jq' that does the above (plus
the requesite 'tty' magic), so this will accomplish the same thing:

```sh
cat file.json | ./busybox-jq '.'
```

### How this is built

The build will:

1. download the latest from the 'master' branch of 'stedolan/jq' from GitHub
2. compile, link, and strip a static 'jq' executable
3. build a Docker image based on BusyBox with 'jq' installed as the entrypoint

Because the base image is BusyBox and the executable is stripped, the
resulting image is pretty small -- roughly 6.24mb at the time I wrote this.

The included .travis.yml file may be used to perform the build using Travis-CI
and push the resulting image up to Docker Hub.  That said, I've daily builds
setup so you're welcome to use mine:

[https://hub.docker.com/r/wesleydeanflexion/busybox-jq]

## Why this exists

This is a convenient (to me) way to use 'jq' on systems where jq is not installed
but Docker is (and we can pull / run Docker images).

## Who wrote this

My role in this is just to build and slap in 'jq'; the fine authors of BusyBox
and JQ did the real heavy lifting.

* [https://github.com/mirror/busybox]
* [https://github.com/stedolan/jq]

Me, I'm a DevSecOps Engineer with Flexion:

* [https://flexion.us/]
