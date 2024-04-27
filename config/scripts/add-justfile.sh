#!/usr/bin/env bash
set -oue pipefail

# Add justfile to 60-custom.just
echo 'import "/usr/share/ublue-os/just/65-custom.just"' >> /usr/share/ublue-os/justfile