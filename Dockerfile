# Lock to a stable base image
FROM rockylinux:8

# Explicitly pin verified active aarch64 repository core versions
ARG AUTOCONF_VERSION=2.69-29.el8
ARG AUTOMAKE_VERSION=1.16.1-8.el8
ARG BINUTILS_VERSION=2.30-123.el8
ARG BISON_VERSION=3.0.4-10.el8
ARG FLEX_VERSION=2.6.1-9.el8
ARG GCC_VERSION=8.5.0-22.el8_10
ARG GCC_CPP_VERSION=8.5.0-22.el8_10
ARG GLIBC_DEVEL_VERSION=2.28-251.el8_10.2
ARG LIBTOOL_VERSION=2.4.6-25.el8
ARG MAKE_VERSION=4.2.1-11.el8
ARG PKGCONF_VERSION=1.4.2-1.el8
ARG WHICH_VERSION=2.21-20.el8
ARG PYTHON312_VERSION=3.12.13-3.el8_10

# 1. Clear package metadata and unlock the hidden developer repository channels
RUN dnf clean all && dnf makecache --enablerepo=devel -y

# 2. Install the native DNF version locking core tool
RUN dnf install -y --enablerepo=devel dnf-plugin-versionlock && dnf clean all

# 3. Securely bind your manifest targets to the version registry
RUN dnf versionlock add --enablerepo=devel \
    autoconf-${AUTOCONF_VERSION} \
    automake-${AUTOMAKE_VERSION} \
    binutils-${BINUTILS_VERSION} \
    bison-${BISON_VERSION} \
    flex-${FLEX_VERSION} \
    gcc-${GCC_VERSION} \
    gcc-c++-${GCC_CPP_VERSION} \
    glibc-devel-${GLIBC_DEVEL_VERSION} \
    libtool-${LIBTOOL_VERSION} \
    make-${MAKE_VERSION} \
    pkgconf-${PKGCONF_VERSION} \
    which-${WHICH_VERSION} \
    python3.12-${PYTHON312_VERSION} \
    python3.12-devel-${PYTHON312_VERSION}

# 4. Strict Deployment Block
# We keep the hardcoded pins for compilers and languages, 
# while letting the system resolve the local ARM architectures for gdb & strace.
RUN dnf install -y --enablerepo=devel \
    autoconf-${AUTOCONF_VERSION} \
    automake-${AUTOMAKE_VERSION} \
    binutils-${BINUTILS_VERSION} \
    bison-${BISON_VERSION} \
    flex-${FLEX_VERSION} \
    gcc-${GCC_VERSION} \
    gcc-c++-${GCC_CPP_VERSION} \
    glibc-devel-${GLIBC_DEVEL_VERSION} \
    libtool-${LIBTOOL_VERSION} \
    make-${MAKE_VERSION} \
    pkgconf-${PKGCONF_VERSION} \
    which-${WHICH_VERSION} \
    python3.12-${PYTHON312_VERSION} \
    python3.12-devel-${PYTHON312_VERSION} \
    gdb \
    strace \
    && dnf clean all

# 5. Clean shortcut symlinks for global execution pathways
RUN ln -s /usr/bin/python3.12 /usr/local/bin/python3 \
    && ln -s /usr/bin/pip3.12 /usr/local/bin/pip3

