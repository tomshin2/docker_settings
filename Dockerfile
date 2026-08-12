# Lock to a stable base image
FROM rockylinux:8

# ======================================================================
# TOOL MANIFEST — single source of truth
# ----------------------------------------------------------------------
# Add a line to install a tool, remove a line to drop it.
# All entries are the latest stable builds available on aarch64
# (Rocky Linux 8.10).
#
#   TOOL_MANIFEST   : plain RPMs -> locked via `dnf versionlock`
#   MODULE_MANIFEST : module streams to enable (Node.js, Go)
#   MODULE_PINS     : exact NEVRAs of the module packages
#   EPEL_RELEASE    : EPEL repo package (needed by ripgrep)
# ======================================================================
ARG TOOL_MANIFEST="\
    autoconf-2.69-29.el8_10.1 \
    automake-1.16.1-8.el8 \
    binutils-2.30-128.el8_10 \
    bison-3.0.4-10.el8 \
    flex-2.6.1-9.el8 \
    gcc-8.5.0-28.el8_10 \
    gcc-c++-8.5.0-28.el8_10 \
    glibc-devel-2.28-251.el8_10.40 \
    libtool-2.4.6-25.el8 \
    make-4.2.1-11.el8 \
    pkgconf-1.4.2-1.el8 \
    which-2.21-21.el8_10 \
    python3.12-3.12.13-3.el8_10 \
    python3.12-devel-3.12.13-3.el8_10 \
    python3.12-pip-23.2.1-4.el8 \
    git-2.43.7-1.el8_10 \
    gdb-8.2-20.el8.0.1 \
    strace-5.18-2.1.el8_10 \
    ripgrep-14.1.1-1.el8 \
    jq-1.6-12.el8_10 \
    tree-1.7.0-15.el8 \
    wget-1.19.5-12.el8_10 \
    zsh-5.5.1-10.el8"

ARG MODULE_MANIFEST="nodejs:22 go-toolset:rhel8"
ARG MODULE_PINS="\
    nodejs-22.23.1-2.module+el8.10.0+40261+cde646a4 \
    npm-10.9.8-1.22.23.1.2.module+el8.10.0+40261+cde646a4 \
    golang-1.26.5-1.module+el8.10.0+40244+e7cb3ff8"

ARG EPEL_RELEASE=epel-release-8-22.el8

# 1. Refresh metadata, install the version-locking plugin and EPEL (pinned)
RUN dnf clean all \
    && dnf makecache --enablerepo=devel \
    && dnf install -y --enablerepo=devel dnf-plugin-versionlock ${EPEL_RELEASE} \
    && dnf makecache --enablerepo=devel

# 2. Enable the module streams referenced by the manifest
RUN dnf module enable -y $MODULE_MANIFEST

# 3. Bind every manifest entry to the version registry
RUN dnf versionlock add --enablerepo=devel $TOOL_MANIFEST $MODULE_PINS

# 4. Install the exact locked versions, then drop cached metadata
RUN dnf install -y --enablerepo=devel $TOOL_MANIFEST $MODULE_PINS \
    && dnf clean all

# 5. Clean shortcut symlinks for global execution pathways
RUN ln -s /usr/bin/python3.12 /usr/local/bin/python3 \
    && ln -s /usr/bin/pip3.12 /usr/local/bin/pip3
