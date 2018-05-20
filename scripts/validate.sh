#!/bin/bash

cd $(git rev-parse --show-toplevel)
. scripts/display.script

action "Running swift lint"
swiftlint lint --strict --quiet
error_status=$?

if [ $error_status -ne 0 ]; then
  error "Error: You need to fix your code before pushing it"
  exit $error_status
fi

action "Running synx"
synx -w error Questions.xcodeproj
error_status=$?

if [ $error_status -ne 0 ]; then
  error "Error: You need to synx your code before pushing it. Run:\nsynx Questions.xcodeproj"
  exit $error_status
fi

info "Done\n"
