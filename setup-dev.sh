#!/bin/bash
set -euo pipefail

# PyTorch development environment setup
# This script installs all dependencies and prepares caches for offline work.
# Run once with internet connectivity.

# Detect OS (supports Debian/Ubuntu)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        ubuntu|debian)
            pkg_manager="apt-get"
            sudo $pkg_manager update
            sudo DEBIAN_FRONTEND=noninteractive $pkg_manager install -y --no-install-recommends \
                build-essential ca-certificates ccache cmake curl git \
                libjpeg-dev libpng-dev ninja-build python3-venv python3-pip \
                nodejs yarn doxygen
            ;;
        *)
            echo "Unsupported OS: $ID" >&2
            exit 1
            ;;
    esac
else
    echo "Cannot determine operating system" >&2
    exit 1
fi

# Create Python virtual environment
if [ ! -d .venv ]; then
    python3 -m venv .venv
fi
source .venv/bin/activate
python -m pip install --upgrade pip

CACHE_DIR="$(pwd)/.offline/pip"
mkdir -p "$CACHE_DIR"

# Download Python dependencies
pip download -r requirements.txt -d "$CACHE_DIR"
pip download -r docs/requirements.txt -d "$CACHE_DIR"
pip download lintrunner mkl-static mkl-include -d "$CACHE_DIR"

# Install dependencies from local cache
pip install --no-index --find-links "$CACHE_DIR" -r requirements.txt
pip install --no-index --find-links "$CACHE_DIR" -r docs/requirements.txt
pip install --no-index --find-links "$CACHE_DIR" lintrunner mkl-static mkl-include

# Initialize lintrunner to download linter binaries
lintrunner init

# Synchronize and update git submodules
git submodule sync
git submodule update --init --recursive

# Add common environment variables to .bashrc if missing
grep -qxF 'export CMAKE_PREFIX_PATH=/usr/local' ~/.bashrc || \
    echo 'export CMAKE_PREFIX_PATH=/usr/local' >> ~/.bashrc
grep -qxF 'export LDFLAGS="-L/usr/local/cuda/lib64/ $LDFLAGS"' ~/.bashrc || \
    echo 'export LDFLAGS="-L/usr/local/cuda/lib64/ $LDFLAGS"' >> ~/.bashrc

# Verification
python -m pip --version
cmake --version
ninja --version
lintrunner --version

cat <<'INFO'
Setup complete.
Activate the virtual environment with 'source .venv/bin/activate' before development.
INFO
