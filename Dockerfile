# Base image
FROM ubuntu:22.04
#FROM alpine:3.18

# Build arg
ARG LINUX_CC=gcc
ARG PPC_CC=gcc

ARG RELEASE=false
ARG GIT_VERSION=unknown

# Install compilers + git
RUN apt-get update && \
    apt-get install -y build-essential git clang && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

# Copy source + Makefile
#COPY ./repos/main.c .
#COPY ./repos/Makefile .
COPY ./repos ./repos
WORKDIR /app/repos

# Use Makefile to build, pass RELEASE and select compiler
#RUN if [ "$RELEASE" = "true" ]; then \
#        echo "Release build: using gcc"; \
#        make CC="$PPC_CC" RELEASE=true GIT_VERSION="$GIT_VERSION"; \
#    else \
#        echo "Debug build: using gcc"; \
#        make CC="$LINUX_CC" RELEASE=false GIT_VERSION="$GIT_VERSION"; \
#    fi
    
    
# Build both Linux (Debug) and PPC (Release) versions
RUN echo "Building all targets..." && \
    # 1. Build the Linux Debug version
#    make clean && \
    make CC="$LINUX_CC" RELEASE=false GIT_VERSION="$GIT_VERSION" && \
    \
    # 2. Build the PPC Release version
#    make clean && \
    make CC="$PPC_CC" RELEASE=true GIT_VERSION="$GIT_VERSION"
    

#ENTRYPOINT ["./app_linux"]
#ENTRYPOINT ["./app_release"]
ENTRYPOINT ["/app/init.sh"]


#docker build -t c-gcc-demo:release --build-arg RELEASE=true --build-arg GIT_VERSION=aaa .
#docker build -t c-gcc-demo:release --build-arg RELEASE=true .
#docker build -t c-gcc-demo:release --build-arg RELEASE=true --build-arg GIT_VERSION=$(git describe --tags --dirty --always) .
#docker build -t c-gcc-demo:linux --build-arg RELEASE=false --build-arg GIT_VERSION=$(git describe --tags --dirty --always) .
#docker build -t c-gcc-demo:linux --build-arg GIT_VERSION=$(git describe --tags --dirty --always) .

#docker run --rm c-gcc-demo:release This is a test
#docker run --rm c-gcc-demo:linux This is a test


#docker run c-gcc-demo "This is a test"
#docker run --rm c-gcc-demo This is a test
#docker run --rm -it --entrypoint bash c-gcc-demo

