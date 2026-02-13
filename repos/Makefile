# =========================
# Compiler (can be overridden)
# =========================
CC ?= gcc
TARGET := app
SRC := main.c

# =========================
# Build mode (default debug)
# =========================
RELEASE ?= false
GIT_VERSION ?= unknown

# Set target name based on build mode
ifeq ($(RELEASE),true)
    TARGET := app_release
else
    TARGET := app_linux
endif

# =========================
# Git version
# =========================
GIT_VERSION := $(shell git describe --tags --dirty --always 2>/dev/null)
ifeq ($(GIT_VERSION),)
    GIT_VERSION := unknown
endif

# =========================
# CFLAGS
# =========================
CFLAGS_COMMON := -Wall -Wextra -std=c11 -DGIT_VERSION=\"$(GIT_VERSION)\"

ifeq ($(RELEASE),true)
    CFLAGS := $(CFLAGS_COMMON) -O2 -DRELEASE
else
    CFLAGS := $(CFLAGS_COMMON) -O0 -g
endif

# =========================
# Rules
# =========================
.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f $(TARGET)
