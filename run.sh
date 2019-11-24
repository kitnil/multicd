#!/bin/sh

# Image manifest.
cat > Dockerfile << EOF
FROM debian:10

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates genisoimage wget syslinux-utils \
 && rm -rf /var/lib/apt/lists/*
EOF

cat > .dockerignore << EOF
*
EOF

# Build the image.
docker build -t multicd .

# Run the image.
docker run                                      \
       --network=host                           \
       --volume "$PWD:/opt/multicd"             \
       --cap-add=SYS_ADMIN                      \
       --device /dev/loop0                      \
       --device /dev/loop-control               \
       --workdir /opt/multicd/                  \
       --interactive                            \
       --tty                                    \
       --name multicd                           \
       multicd
