#!/usr/bin/env bash

TOTO=$(prefetch-npm-deps)
sed -i 's/sha[^"]\+/'"$TOTO"'/' flake.nix
