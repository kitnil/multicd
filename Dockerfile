FROM debian:10

RUN apt-get update && apt-get install --no-install-recommends -y \
    genisoimage wget syslinux-utils \
 && rm -rf /var/lib/apt/lists/*
