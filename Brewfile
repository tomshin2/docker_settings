# explore_ai — iOS local build toolchain for macOS (exact-version pinned)
#
# Homebrew cannot pin exact versions natively. This file uses `brew extract`,
# the official mechanism: it copies each formula as it was at the pinned
# version into a local tap, then installs from there.
#
# One-time setup (run once, before `brew bundle`):
#   brew tap-new local/extract
#   brew extract --version=22.23.2 node      local/extract
#   brew extract --version=1.17.0  cocoapods local/extract
#   brew extract --version=2026.07.27.00 watchman local/extract
#   brew bundle --file macos/Brewfile
#
# Git is intentionally not listed: it ships with Xcode's command line tools.
#
# Installing:
#   brew bundle --file macos/Brewfile          # install everything in this file
#   brew bundle --file macos/Brewfile --no-upgrade  # skip running `brew update` first
#
# Checking / dumping installed versions:
#   brew list --versions                        # show installed formulas + versions
#   brew bundle dump --file=macos/Brewfile      # regenerate a Brewfile from what's installed
#
# Cleaning up:
#   brew cleanup                                # remove old versions + stale download cache
#   brew cleanup -s                             # also scrub all cached downloads
#   brew autoremove                             # remove dependencies no longer needed
#   brew uninstall <formula>                    # remove a single formula
#   brew tap remove local/extract               # delete the custom tap when done with it
#
# Caveats:
#  - Extracted versions have no pre-built bottles, so they compile from
#    source (Node/watchman ~15-30 min each). Only Node's major line
#    actually matters to this project; the rest are pinned for
#    reproducibility.
#  - keg-only formulas (node): add /opt/homebrew/opt/node@22.23.2/bin to
#    PATH (Apple Silicon) or /usr/local/opt/node@22.23.2/bin (Intel).

brew "local/extract/node@22.23.2"
brew "local/extract/cocoapods@1.17.0"
brew "local/extract/watchman@2026.07.27.00"
