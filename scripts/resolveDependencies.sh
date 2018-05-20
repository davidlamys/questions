#!/usr/bin/env bash

cd $(git rev-parse --show-toplevel)
. scripts/display.script

header "Resolve dependencies:"

# From https://github.com/blender/Rome#ci-workflow
action "Download from cache"
rome download --platform iOS
action "Get all missing frameworks"
rome list --missing --platform iOS | awk '{print $1}' | xargs carthage bootstrap --platform ios --cache-builds
action "Upload to cache"
rome list --missing --platform iOS | awk '{print $1}' | xargs rome upload --platform ios

info "Done\n"
